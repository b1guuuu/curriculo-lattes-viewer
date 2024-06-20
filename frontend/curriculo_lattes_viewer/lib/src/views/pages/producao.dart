// ignore_for_file: prefer_null_aware_operators, prefer_if_null_operators

import 'package:curriculo_lattes_viewer/src/controllers/dropbox_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/intitutos_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/pesquisadores_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/trabalho_controller.dart';
import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
import 'package:curriculo_lattes_viewer/src/models/pesquisador.dart';
import 'package:curriculo_lattes_viewer/src/models/trabalho.dart';
import 'package:curriculo_lattes_viewer/src/views/components/carregando.dart';
import 'package:curriculo_lattes_viewer/src/views/components/dropbox.dart';
import 'package:curriculo_lattes_viewer/src/views/components/navegacao.dart';
import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ProducaoPage extends StatefulWidget {
  static const rota = 'producao';
  final Map<String, dynamic>? filtros;

  const ProducaoPage({super.key, this.filtros});

  @override
  State<ProducaoPage> createState() {
    return ProducaoPageState();
  }
}

class ProducaoPageState extends State<ProducaoPage> {
  final _institutosController = InstitutosController();
  final _pesquisadoresController = PesquisadoresController();
  final _trabalhosController = TrabalhoController();
  final _anoInicioTxtController = TextEditingController();
  final _anoFimTxtController = TextEditingController();
  final _tipoProducao = [
    {'id': 1, 'label': 'Todos', 'value': "('LIVRO', 'ARTIGO')"},
    {'id': 2, 'label': 'Livro', 'value': "('LIVRO')"},
    {'id': 3, 'label': 'Artigo', 'value': "('ARTIGO')"},
  ];
  final _tableController = PagedDataTableController<String, Trabalho>();
  late List<Pesquisador> _pesquisadores;
  late List<Instituto> _institutos;
  late DropboxController _institutosDropboxController;
  late DropboxController _pesquisadoresDropboxController;
  late DropboxController _tipoProducaoDropboxController;
  int? _filtroAnoInicio = null;
  int? _filtroAnoFim = null;
  List<int>? _filtroInstitutos = null;
  List<String>? _filtroPesquisadores = null;
  String? _filtroTipo = null;
  bool _carregando = true;
  int _contador = 0;

  @override
  void initState() {
    super.initState();
    _buscaDadosIniciais();
  }

  void _verificaFiltros() {
    if (widget.filtros != null) {
      print('verificando filtros');
      setState(() {
        _filtroAnoInicio = widget.filtros!['_filtroAnoInicio'];
        _filtroAnoFim = widget.filtros!['_filtroAnoFim'];
        _filtroInstitutos = widget.filtros!['_filtroInstitutos'];
        _filtroPesquisadores = widget.filtros!['_filtroPesquisadores'];
        _filtroTipo = _tipoProducao
            .where((tipo) => tipo['id'] == widget.filtros!['_filtroTipo'])
            .first['value'] as String?;
        _anoInicioTxtController.text = _filtroAnoInicio.toString();
        _anoFimTxtController.text = _filtroAnoFim.toString();

        if (widget.filtros!['_filtroPesquisadores'].length !=
            _pesquisadores.length) {
          _pesquisadoresDropboxController.selectedItems =
              _pesquisadoresDropboxController.items
                  .where((item) => widget.filtros!['_filtroPesquisadores']
                      .contains(item['id']))
                  .toList();
        }

        if (widget.filtros!['_filtroInstitutos'].length != _institutos.length) {
          _institutosDropboxController.selectedItems =
              _institutosDropboxController.items
                  .where((item) =>
                      widget.filtros!['_filtroInstitutos'].contains(item['id']))
                  .toList();
        }

        _tipoProducaoDropboxController.selectedItems =
            _tipoProducaoDropboxController.items
                .where((item) => item['value'] == _filtroTipo)
                .toList();
      });
    }
  }

  Future<void> _buscaDadosIniciais() async {
    setState(() {
      _carregando = true;
    });

    var pesquisadores = await _pesquisadoresController.listar();
    var institutos = await _institutosController.listar();

    setState(() {
      _pesquisadores = pesquisadores;
      _institutos = institutos;
    });
    _defineInstitutosDropboxController();
    _definePesquisadoresDropboxController();
    _defineTipoProducaoDropboxController();
    _verificaFiltros();
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

  @override
  void dispose() {
    _tableController.dispose();
    super.dispose();
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
      setState(() {
        _filtroAnoInicio = anoInicio;
        _filtroAnoFim = anoFim;
        _filtroInstitutos = _institutosDropboxController.selectedItems
            .where((instituto) => instituto['id'] != -1)
            .map((instituto) => instituto['id'])
            .cast<int>()
            .toList();
        _filtroPesquisadores = _pesquisadoresDropboxController.selectedItems
            .where((pesquisador) => pesquisador['id'] != -1)
            .map((pesquisador) => "'${pesquisador['id']}'")
            .cast<String>()
            .toList();
        _filtroTipo =
            _tipoProducaoDropboxController.selectedItems.first['value'];
        _tableController.refresh();
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

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text('$_contador Itens de produção'),
        ),
        drawer: const Drawer(
          child: Navegacao(),
        ),
        body: _carregando
            ? const Carregando()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.2,
                    child: Column(
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
                                padding: const EdgeInsetsDirectional.only(
                                    start: 6.0),
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
                                padding: const EdgeInsetsDirectional.only(
                                    start: 15.0),
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
                                      dropboxController:
                                          _institutosDropboxController,
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
                                  dropboxController:
                                      _tipoProducaoDropboxController,
                                  label: 'Tipo Prod.',
                                  enableOptionAll: false),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.7,
                    child: Container(
                      color: const Color.fromARGB(255, 208, 208, 208),
                      padding: const EdgeInsets.all(20.0),
                      child: PagedDataTable<String, Trabalho>(
                        controller: _tableController,
                        fetcher: (int pageSize, SortModel? sortModel,
                            FilterModel filterModel, String? pageToken) async {
                          try {
                            var temp =
                                await _trabalhosController.filtrarAtualizado(
                                    _filtroAnoInicio,
                                    _filtroAnoFim,
                                    _filtroInstitutos?.join(','),
                                    _filtroPesquisadores?.join(','),
                                    _filtroTipo,
                                    sortModel?.fieldName,
                                    (sortModel?.descending ?? false)
                                        ? 'ASC'
                                        : 'DESC',
                                    int.parse(pageToken ?? '0'),
                                    pageSize);
                            var totalTrabalhos =
                                await _trabalhosController.contarAtualizado(
                                    _filtroAnoInicio,
                                    _filtroAnoFim,
                                    _filtroInstitutos?.join(','),
                                    _filtroPesquisadores?.join(','),
                                    _filtroTipo);
                            setState(() {
                              _contador = totalTrabalhos;
                            });
                            var nextPageToken =
                                int.parse(pageToken ?? '0') + pageSize;
                            return (
                              temp,
                              nextPageToken > totalTrabalhos
                                  ? null
                                  : nextPageToken.toString()
                            );
                          } catch (e) {
                            print(e);

                            return (List<Trabalho>.empty(), null);
                          }
                        },
                        initialPage: '0',
                        columns: [
                          TableColumn(
                              id: "tipo",
                              title: const Text('Tipo'),
                              cellBuilder: (context, trabalho, index) =>
                                  Text(trabalho.tipo),
                              sortable: true),
                          TableColumn(
                              id: "detalhamento",
                              title: const Text('Detalhamento'),
                              cellBuilder: (context, trabalho, index) => Text(
                                    trabalho.formataDetalhamento(),
                                    maxLines: 5,
                                    softWrap: true,
                                  ),
                              sortable: false,
                              size: const RemainingColumnSize()),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }
}
