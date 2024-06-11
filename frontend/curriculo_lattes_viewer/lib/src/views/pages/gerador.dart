import 'package:curriculo_lattes_viewer/src/controllers/dropbox_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/graph_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/intitutos_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/pesquisadores_controller.dart';
import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
import 'package:curriculo_lattes_viewer/src/models/pesquisador.dart';
import 'package:curriculo_lattes_viewer/src/models/regra_plotagem_grafo.dart';
import 'package:curriculo_lattes_viewer/src/utils/graph_options_builder.dart';
import 'package:curriculo_lattes_viewer/src/utils/np_rules_validator.dart';
import 'package:curriculo_lattes_viewer/src/views/components/carregando.dart';
import 'package:curriculo_lattes_viewer/src/views/components/dropbox.dart';
import 'package:curriculo_lattes_viewer/src/views/components/navegacao.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class GeradorPage extends StatefulWidget {
  static const rota = 'gerador';

  const GeradorPage({super.key});

  @override
  State<GeradorPage> createState() {
    return GeradorPageState();
  }
}

class GeradorPageState extends State<GeradorPage> {
  final _cores = [
    {"label": "Vermelho", "value": "red"},
    {"label": "Amarelo", "value": "yellow"},
    {"label": "Verde", "value": "green"},
  ];

  final _tipoProducao = [
    {'id': 1, 'label': 'Todos'},
    {'id': 2, 'label': 'Livro'},
    {'id': 3, 'label': 'Artigo'},
  ];

  final List<RegraPlotagemGrafo> _regrasPlotagem = [
    RegraPlotagemGrafo(
        cor: 'red',
        inicio: NP(
            controller: TextEditingController.fromValue(
                const TextEditingValue(text: '1')),
            readonly: true),
        fim: NP(
            controller: TextEditingController.fromValue(
                const TextEditingValue(text: '2')),
            readonly: false)),
    RegraPlotagemGrafo(
        cor: 'yellow',
        inicio: NP(
            controller: TextEditingController.fromValue(
                const TextEditingValue(text: '3')),
            readonly: true),
        fim: NP(
            controller: TextEditingController.fromValue(
                const TextEditingValue(text: '4')),
            readonly: false)),
    RegraPlotagemGrafo(
        cor: 'green',
        inicio: NP(
            controller: TextEditingController.fromValue(
                const TextEditingValue(text: '5')),
            readonly: true),
        fim: NP(
            controller: TextEditingController.fromValue(
                const TextEditingValue(text: ' >= 5')),
            readonly: true))
  ];

  late DropboxController _institutosDropboxController;
  late DropboxController _pesquisadoresDropboxController;
  late DropboxController _verticeDropboxController;
  late DropboxController _tipoProducaoDropboxController;
  late List<Instituto> _institutos;
  late List<Pesquisador> _pesquisadores;
  late dynamic _grafo;

  bool _carregando = true;
  bool _displayGrafo = false;

  @override
  void initState() {
    super.initState();
    defineVerticesDropboxController();
    _listagemDados();
  }

  void _listagemDados() async {
    setState(() {
      _carregando = true;
    });
    var institutos = await InstitutosController().listar();
    var pesquisadores = await PesquisadoresController().listar();
    setState(() {
      _institutos = institutos;
      _pesquisadores = pesquisadores;
    });
    defineInstitutosDropboxController();
    definePesquisadoresDropboxController();
    defineTipoProducaoDropboxController();
    setState(() {
      _carregando = false;
    });
  }

  void defineVerticesDropboxController() {
    setState(() {
      _verticeDropboxController = DropboxController(items: [
        {"label": "Instituto"},
        {"label": "Pesquisador"},
      ], displayField: 'label', onSelect: null);
      _verticeDropboxController.selectedItems
          .add(_verticeDropboxController.items.first);
    });
  }

  void defineInstitutosDropboxController() {
    List<Map<String, dynamic>> institutosMapList = [];
    for (var instituto in _institutos) {
      institutosMapList.add(instituto.toMap());
    }
    setState(() {
      _institutosDropboxController = DropboxController(
          items: institutosMapList,
          displayField: 'acronimo',
          onSelect: () {
            definePesquisadoresDropboxController();
          });
      _institutosDropboxController.selectedItems = [...institutosMapList];
      _institutosDropboxController.loading = false;
    });
  }

  void definePesquisadoresDropboxController() {
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

  void defineTipoProducaoDropboxController() {
    setState(() {
      _tipoProducaoDropboxController = DropboxController(
          items: _tipoProducao, displayField: 'label', onSelect: null);
      _tipoProducaoDropboxController.selectedItems
          .add(_tipoProducaoDropboxController.items.first);
    });
  }

  void _onChangeNP(String text, int index) {
    if (text.trim().isNotEmpty) {
      setState(() {
        _regrasPlotagem[1].inicio.controller.text =
            '${_regrasPlotagem[0].fim.getValue() + 1}';
        _regrasPlotagem[2].inicio.controller.text =
            '${_regrasPlotagem[1].fim.getValue() + 1}';
        _regrasPlotagem[2].fim.controller.text =
            ' >= ${_regrasPlotagem[2].inicio.controller.text}';
      });
    }
  }

  void _validaConfiguracoesNP() {
    if (NpRulesValidator(regrasPlotagem: _regrasPlotagem).validadeAll()) {
      _solicitaGrafo();
    } else {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          confirmBtnText: 'Fechar',
          title: 'Erro regras de plotagem',
          text:
              'Verifique se as regras de plotagem estão corretas:\nSem cores repetidas\nCom valores corretos');
    }
  }

  Future<void> _solicitaGrafo() async {
    setState(() {
      _displayGrafo = false;
    });
    try {
      var temp = await GraphController().gerarGrafo(GraphOptionsBuilder(
              institutos: _institutosDropboxController.selectedItems,
              pesquisadores: _pesquisadoresDropboxController.selectedItems,
              regras: _regrasPlotagem,
              tipoProducao:
                  _tipoProducaoDropboxController.selectedItems.first['label'],
              vertice: _verticeDropboxController.selectedItems.first['label'])
          .buildOptions());
      setState(() {
        _grafo = temp;
        _displayGrafo = true;
        _pesquisadoresDropboxController.loading = false;
        _institutosDropboxController.loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerador de grafo'),
      ),
      drawer: const Drawer(
        child: Navegacao(),
      ),
      body: _carregando
          ? const Carregando()
          : Container(
              color: const Color.fromARGB(255, 208, 208, 208),
              padding: const EdgeInsets.all(20.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: ListView(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _institutosDropboxController.loading
                                ? const Carregando()
                                : Expanded(
                                    child: Dropbox(
                                    dropboxController:
                                        _institutosDropboxController,
                                    label: 'Instituto',
                                    enableOptionAll: true,
                                  )),
                            _pesquisadoresDropboxController.loading
                                ? const Carregando()
                                : Expanded(
                                    child: Dropbox(
                                    dropboxController:
                                        _pesquisadoresDropboxController,
                                    label: 'Pesquisador',
                                    enableOptionAll: true,
                                  )),
                            Expanded(
                                child: Dropbox(
                              dropboxController: _tipoProducaoDropboxController,
                              label: 'Tipo Produção',
                              enableOptionAll: false,
                            )),
                            Expanded(
                                child: Dropbox(
                                    dropboxController:
                                        _verticeDropboxController,
                                    label: 'Vértice',
                                    enableOptionAll: false)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Regras de plotagem'),
                        ),
                        Table(
                          border: TableBorder.all(),
                          children: [
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Aresta (cor)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Valor NP (início)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Valor NP (fim)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            for (int i = 0; i < 3; i++)
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButton<String>(
                                      value: _regrasPlotagem[i].cor,
                                      items: _cores.map((dynamic cor) {
                                        return DropdownMenuItem<String>(
                                          value: cor['value'],
                                          child: Text(cor['label']),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _regrasPlotagem[i].cor = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      controller:
                                          _regrasPlotagem[i].inicio.controller,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 8),
                                      ),
                                      readOnly:
                                          _regrasPlotagem[i].inicio.readonly,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      controller:
                                          _regrasPlotagem[i].fim.controller,
                                      onChanged: (text) => _onChangeNP(text, i),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 8),
                                      ),
                                      readOnly: _regrasPlotagem[i].fim.readonly,
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                        ElevatedButton(
                            onPressed: _validaConfiguracoesNP,
                            child: const Text('Grafo')),
                        _displayGrafo
                            ? Container(
                                child: Image.memory(_grafo),
                              )
                            : SizedBox()
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
