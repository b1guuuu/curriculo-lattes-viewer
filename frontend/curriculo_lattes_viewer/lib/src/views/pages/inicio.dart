import 'package:curriculo_lattes_viewer/src/controllers/dropbox_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/intitutos_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/pesquisadores_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/trabalho_controller.dart';
import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
import 'package:curriculo_lattes_viewer/src/models/pesquisador.dart';
import 'package:curriculo_lattes_viewer/src/models/trabalho.dart';
import 'package:curriculo_lattes_viewer/src/views/components/carregando.dart';
import 'package:curriculo_lattes_viewer/src/views/components/dropbox.dart';
import 'package:curriculo_lattes_viewer/src/views/components/grafico_producao_ano.dart';
import 'package:curriculo_lattes_viewer/src/views/components/grafico_total_producao.dart';
import 'package:curriculo_lattes_viewer/src/views/components/navegacao.dart';
import 'package:curriculo_lattes_viewer/src/views/pages/gerador.dart';
import 'package:curriculo_lattes_viewer/src/views/pages/producao.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class InicioPage extends StatefulWidget {
  static const rota = '';

  const InicioPage({super.key});

  @override
  State<InicioPage> createState() {
    return InicioPageState();
  }
}

class InicioPageState extends State<InicioPage> {
  final _institutosController = InstitutosController();
  final _pesquisadoresController = PesquisadoresController();
  final _trabalhosController = TrabalhoController();
  final _anoInicioTxtController = TextEditingController();
  final _anoFimTxtController = TextEditingController();
  final _tipoProducao = [
    {'id': 1, 'label': 'Todos', 'value': '(LIVRO, ARTIGO)'},
    {'id': 2, 'label': 'Livro', 'value': '(LIVRO)'},
    {'id': 3, 'label': 'Artigo', 'value': '(ARTIGO)'},
  ];
  late List<Pesquisador> _pesquisadores;
  late List<Instituto> _institutos;
  late List<Trabalho> _trabalhos;
  late List<Trabalho> _trabalhosFiltrados;
  late DropboxController _institutosDropboxController;
  late DropboxController _pesquisadoresDropboxController;
  late DropboxController _tipoProducaoDropboxController;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscaDadosIniciais();
  }

  Future<void> _buscaDadosIniciais() async {
    setState(() {
      _carregando = true;
    });

    var pesquisadores = await _pesquisadoresController.listar();
    var institutos = await _institutosController.listar();
    var trabalhos = await _trabalhosController.listarRelacoes();

    setState(() {
      _pesquisadores = pesquisadores;
      _institutos = institutos;
      _trabalhos = trabalhos;
      _trabalhosFiltrados = trabalhos;
    });
    _defineInstitutosDropboxController();
    _definePesquisadoresDropboxController();
    _defineTipoProducaoDropboxController();
    setState(() {
      _carregando = false;
    });
  }

  void _defineInstitutosDropboxController() {
    List<Map<String, dynamic>> institutosMapList = [];
    for (var instituto in _institutos) {
      institutosMapList.add(instituto.toMap());
    }
    setState(() {
      _institutosDropboxController = DropboxController(
          items: institutosMapList,
          displayField: 'acronimo',
          onSelect: () {
            _definePesquisadoresDropboxController();
          });
      _institutosDropboxController.selectedItems = [...institutosMapList];
      _institutosDropboxController.loading = false;
    });
  }

  void _definePesquisadoresDropboxController() {
    setState(() {
      _institutosDropboxController.loading = false;
    });
    var idsInstitutosSelecionados = _institutosDropboxController.selectedItems
        .map((institutoSelecionado) => institutoSelecionado['id']);
    List<Pesquisador> pesquisadoresFiltrados;
    if (idsInstitutosSelecionados.contains(-1)) {
      pesquisadoresFiltrados = [..._pesquisadores];
    } else {
      pesquisadoresFiltrados = _pesquisadores
          .where((pesquisador) =>
              idsInstitutosSelecionados.contains(pesquisador.idInstituto))
          .toList();
    }

    List<Map<String, dynamic>> pesquisadoresMapList = [];
    for (var pesquisador in pesquisadoresFiltrados) {
      pesquisadoresMapList.add(pesquisador.toMap());
    }
    setState(() {
      _pesquisadoresDropboxController = DropboxController(
          items: pesquisadoresMapList, displayField: 'nome', onSelect: null);
      _pesquisadoresDropboxController.selectedItems = [...pesquisadoresMapList];
      _pesquisadoresDropboxController.loading = false;
    });
  }

  void _defineTipoProducaoDropboxController() {
    setState(() {
      _tipoProducaoDropboxController = DropboxController(
          items: _tipoProducao, displayField: 'label', onSelect: null);
      _tipoProducaoDropboxController.selectedItems
          .add(_tipoProducaoDropboxController.items.first);
    });
  }

  bool _validaFiltroAno(String anoInicioStr, String anoFimStr) {
    int? anoInicioInt;
    int? anoFimInt;
    if (anoInicioStr.trim().isNotEmpty) {
      try {
        anoInicioInt = int.parse(anoInicioStr.trim());
      } catch (e) {
        return false;
      }
    }
    if (anoFimStr.trim().isNotEmpty) {
      try {
        anoFimInt = int.parse(anoFimStr.trim());
      } catch (e) {
        return false;
      }
    }

    if (anoInicioInt != null && anoFimInt != null) {
      return anoInicioInt <= anoFimInt;
    }

    return true;
  }

  void _filtraTrabalhos() {
    if (_validaFiltroAno(_anoInicioTxtController.text.trim(),
        _anoFimTxtController.text.trim())) {
      int anoInicio = 1988;
      int anoFim = 2024;
      if (_anoInicioTxtController.text.trim().isNotEmpty) {
        anoInicio = int.parse(_anoInicioTxtController.text.trim());
      }
      if (_anoFimTxtController.text.trim().isNotEmpty) {
        anoFim = int.parse(_anoFimTxtController.text.trim());
      }
      var trabalhosFiltrados = _filtroAno(_trabalhos, anoInicio, anoFim);
      trabalhosFiltrados = _filtroInstituto(trabalhosFiltrados);
      trabalhosFiltrados = _filtroPesquisador(trabalhosFiltrados);
      trabalhosFiltrados = _filtroTipoProducao(trabalhosFiltrados);
      setState(() {
        _trabalhosFiltrados = trabalhosFiltrados;
        _pesquisadoresDropboxController.loading = false;
      });
    } else {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Ano(s) com valor(es) incorreto(s)',
          text: 'Verifique o(s) valor(es) inserido(s);',
          confirmBtnText: 'Fechar');
    }
  }

  List<Trabalho> _filtroAno(
      List<Trabalho> trabalhos, int anoInicio, int anoFim) {
    return trabalhos
        .where(
            (trabalho) => trabalho.ano >= anoInicio && trabalho.ano <= anoFim)
        .toList();
  }

  List<Trabalho> _filtroInstituto(List<Trabalho> trabalhos) {
    if (_institutosDropboxController.optionAllSelected) {
      return trabalhos;
    } else {
      var idsInstitutosSelecionados = _institutosDropboxController.selectedItems
          .map((institutoSelecionado) => institutoSelecionado['id']);
      return trabalhos
          .where((trabalho) => trabalho.institutos!
              .toSet()
              .intersection(idsInstitutosSelecionados.toSet())
              .isNotEmpty)
          .toList();
    }
  }

  List<Trabalho> _filtroPesquisador(List<Trabalho> trabalhos) {
    if (_pesquisadoresDropboxController.optionAllSelected) {
      return trabalhos;
    } else {
      var idsPesquisadoresSelecionados = _pesquisadoresDropboxController
          .selectedItems
          .map((pesquisador) => pesquisador['id']);
      return trabalhos
          .where((trabalho) => trabalho.pesquisadores!
              .toSet()
              .intersection(idsPesquisadoresSelecionados.toSet())
              .isNotEmpty)
          .toList();
    }
  }

  List<Trabalho> _filtroTipoProducao(List<Trabalho> trabalhos) {
    return trabalhos
        .where((trabalho) => _tipoProducaoDropboxController
            .selectedItems.first['value']
            .toString()
            .contains(trabalho.tipo))
        .toList();
  }

  void irParaTelaProducao(int ano) {
    int filtroAnoInicio = ano;
    int filtroAnoFim = ano;
    List<int> filtroInstitutos = _institutosDropboxController.selectedItems
        .map((instituto) => instituto['id'])
        .cast<int>()
        .toList();
    List<String> filtroPesquisadores = _pesquisadoresDropboxController
        .selectedItems
        .where((pesquisador) => pesquisador['id'] != -1)
        .map((pesquisador) => pesquisador['id'])
        .cast<String>()
        .toList();
    int filtroTipo = _tipoProducaoDropboxController.selectedItems.first['id'];

    print('irParaTelaProducao');

    Navigator.of(context).pushNamed(ProducaoPage.rota, arguments: {
      '_filtroAnoInicio': filtroAnoInicio,
      '_filtroAnoFim': filtroAnoFim,
      '_filtroInstitutos': filtroInstitutos,
      '_filtroPesquisadores': filtroPesquisadores,
      '_filtroTipo': filtroTipo
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Início'),
        ),
        drawer: const Drawer(
          child: Navegacao(),
        ),
        body: _carregando
            ? const Center(
                child: Carregando(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth / 3,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 6.0),
                          child: Row(
                            children: [
                              const Text('Ano início: '),
                              const SizedBox(
                                width: 10.0,
                              ),
                              SizedBox(
                                width: (screenWidth / 3) - 100,
                                child: TextField(
                                  decoration: const InputDecoration(
                                      hintText: '2000',
                                      border: OutlineInputBorder()),
                                  controller: _anoInicioTxtController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth / 3,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.only(start: 15.0),
                          child: Row(
                            children: [
                              const Text('Ano fim: '),
                              const SizedBox(
                                width: 10.0,
                              ),
                              SizedBox(
                                width: (screenWidth / 3) - 100,
                                child: TextField(
                                  decoration: const InputDecoration(
                                      hintText: '2020',
                                      border: OutlineInputBorder()),
                                  controller: _anoFimTxtController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth / 3,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 20.0, end: 20.0),
                          child: FilledButton(
                              onPressed: () => _filtraTrabalhos(),
                              child: const Text('Aplicar')),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth / 3,
                        child: _institutosDropboxController.loading
                            ? const Carregando()
                            : Dropbox(
                                dropboxController: _institutosDropboxController,
                                label: 'Instituto',
                                enableOptionAll: true),
                      ),
                      SizedBox(
                        width: screenWidth / 3,
                        child: _pesquisadoresDropboxController.loading
                            ? const Carregando()
                            : Dropbox(
                                dropboxController:
                                    _pesquisadoresDropboxController,
                                label: 'Pesquisador',
                                enableOptionAll: true),
                      ),
                      SizedBox(
                        width: screenWidth / 3,
                        child: Dropbox(
                            dropboxController: _tipoProducaoDropboxController,
                            label: 'Tipo Prod.',
                            enableOptionAll: false),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: screenWidth,
                    height: 360,
                    child: GraficoProducaoAno(
                      trabalhos: _trabalhosFiltrados,
                      onTap: (p0) => irParaTelaProducao(p0),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth / 3,
                        height: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Produção'),
                            GraficoTotalProducao(trabalhos: _trabalhos)
                          ],
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * (2 / 9),
                        height: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Institutos'),
                            Text(_institutos.length.toString())
                          ],
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * (2 / 9),
                        height: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Pesquisadores'),
                            Text(_pesquisadores.length.toString())
                          ],
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * (2 / 9),
                        height: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Grafos'),
                            IconButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(GeradorPage.rota),
                              icon: const Icon(
                                Icons.stacked_line_chart_rounded,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ));
  }
}
