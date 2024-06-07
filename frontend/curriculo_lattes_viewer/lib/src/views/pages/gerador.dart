import 'package:curriculo_lattes_viewer/src/controllers/dropbox_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/intitutos_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/pesquisadores_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/trabalho_controller.dart';
import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
import 'package:curriculo_lattes_viewer/src/models/pesquisador.dart';
import 'package:curriculo_lattes_viewer/src/models/trabalho.dart';
import 'package:curriculo_lattes_viewer/src/views/components/carregando.dart';
import 'package:curriculo_lattes_viewer/src/views/components/dropbox.dart';
import 'package:curriculo_lattes_viewer/src/views/components/dropbox_instituto.dart';
import 'package:curriculo_lattes_viewer/src/views/components/dropbox_pesquisador.dart';
import 'package:curriculo_lattes_viewer/src/views/components/dropbox_producao.dart';
import 'package:curriculo_lattes_viewer/src/views/components/dropbox_vertices.dart';
import 'package:curriculo_lattes_viewer/src/views/components/navegacao.dart';
import 'package:flutter/material.dart';

class GeradorPage extends StatefulWidget {
  static const rota = 'gerador';

  const GeradorPage({super.key});

  @override
  State<GeradorPage> createState() {
    return GeradorPageState();
  }
}

class GeradorPageState extends State<GeradorPage> {
  List<String> _selectedColors = List.filled(3, 'Vermelho');
  List<Map<String, int>> _vertexValues = [
    {'inicio': 1, 'fim': 2},
    {'inicio': 3, 'fim': 4},
    {'inicio': 4, 'fim': 5},
  ];
  late DropboxController _institutosDropboxController;
  late DropboxController _pesquisadoresDropboxController;
  late DropboxController _trabalhosDropboxController;
  late DropboxController _verticeDropboxController;
  late List<Instituto> _institutos;
  late List<Pesquisador> _pesquisadores;
  late List<Trabalho> _trabalhos;

  bool _carregando = true;

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
    var trabalhos = await TrabalhoController()
        .filtrar(null, null, null, null, null, null, null, 0, 600);
    setState(() {
      _institutos = institutos;
      _pesquisadores = pesquisadores;
      _trabalhos = trabalhos;
    });
    defineInstitutosDropboxController();
    definePesquisadoresDropboxController();
    defineTrabalhosDropboxController();
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
            defineTrabalhosDropboxController();
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
    print(pesquisadoresMapList);
    setState(() {
      _pesquisadoresDropboxController = DropboxController(
          items: pesquisadoresMapList,
          displayField: 'nome',
          onSelect: () => defineTrabalhosDropboxController());
      _pesquisadoresDropboxController.selectedItems = [...pesquisadoresMapList];
      _pesquisadoresDropboxController.loading = false;
    });
  }

  void defineTrabalhosDropboxController() {
    setState(() {
      _pesquisadoresDropboxController.loading = false;
    });
    var nomeReferenciaPesquisadoresSelecionados =
        _pesquisadoresDropboxController.selectedItems.map(
            (pesquisadorSelecionado) =>
                pesquisadorSelecionado['nomeReferencia']);
    List<Trabalho> trabalhosFiltrados = _trabalhos
        .where((trabalho) => trabalho.nomes.any(
            (nome) => nomeReferenciaPesquisadoresSelecionados.contains(nome)))
        .toList();
    List<Map<String, dynamic>> trabalhosMapList = [];
    for (var trabalho in trabalhosFiltrados) {
      trabalhosMapList.add(trabalho.toMap());
    }
    setState(() {
      _trabalhosDropboxController = DropboxController(
          items: trabalhosMapList,
          displayField: 'titulo',
          onSelect: () => null);
      _trabalhosDropboxController.selectedItems = [...trabalhosMapList];
      _trabalhosDropboxController.loading = false;
    });
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
                        const SizedBox(height: 30),
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
                            _trabalhosDropboxController.loading
                                ? const Carregando()
                                : Expanded(
                                    child: Dropbox(
                                    dropboxController:
                                        _trabalhosDropboxController,
                                    label: 'Trabalho',
                                    enableOptionAll: true,
                                  )),
                            Expanded(
                                child: Dropbox(
                                    dropboxController:
                                        _verticeDropboxController,
                                    label: 'Vértice',
                                    enableOptionAll: false)),
                          ],
                        ),
                        const SizedBox(height: 150),
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
                                      value: _selectedColors[i],
                                      items: <String>[
                                        'Vermelho',
                                        'Amarelo',
                                        'Verde'
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedColors[i] = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(_vertexValues[i]['inicio']
                                          .toString()),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: i == 0 ||
                                            i ==
                                                1 // Make the third row editable
                                        ? TextField(
                                            keyboardType: TextInputType.number,
                                            autocorrect: false,
                                            onChanged: (text) {
                                              setState(() {
                                                _vertexValues[i]['fim'] =
                                                    int.parse(text);
                                                _vertexValues[i + 1]['inicio'] =
                                                    int.parse(text) + 1;

                                                if (_vertexValues[i + 1]
                                                        ['inicio']! >
                                                    _vertexValues[i + 1]
                                                        ['fim']!) {
                                                  _vertexValues[i + 1]['fim'] =
                                                      _vertexValues[i + 1]
                                                              ['inicio']! +
                                                          1;
                                                }
                                              });
                                              print(_vertexValues);
                                            },
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 8),
                                            ),
                                          )
                                        : Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(_vertexValues[i]['fim']
                                                .toString()),
                                          ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
