import 'package:curriculo_lattes_viewer/src/views/components/carregando.dart';
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

  bool _box1 = true;
  bool _box2 = true;
  bool _box3 = true;

  @override
  void initState() {
    super.initState();
    _carretaDropBoxIndividualmente();
  }

  void _carretaDropBoxIndividualmente() async {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _box1 = false;
      });
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _box2 = false;
      });
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        _box3 = false;
      });
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
      body: Container(
        color: const Color.fromARGB(255, 208, 208, 208),
        padding: const EdgeInsets.all(20.0),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                          child:
                              _box1 ? const Carregando() : DropboxInstituto()),
                      Expanded(
                          child: _box2
                              ? const Carregando()
                              : DropboxPesquisador()),
                      Expanded(
                          child:
                              _box3 ? const Carregando() : DropboxProducao()),
                      const Expanded(child: DropboxVertices()),
                    ],
                  ),
                  const SizedBox(height: 150),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Regas de plotagem'),
                  ),
                  Table(
                    border: TableBorder.all(),
                    children: [
                      const TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Aresta (cor)',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Valor NP (início)',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Valor NP (fim)',
                                style: TextStyle(fontWeight: FontWeight.bold)),
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
                                items: <String>['Vermelho', 'Amarelo', 'Verde']
                                    .map((String value) {
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
                                child:
                                    Text(_vertexValues[i]['inicio'].toString()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: i == 0 ||
                                      i == 1 // Make the third row editable
                                  ? TextField(
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      onChanged: (text) {
                                        setState(() {
                                          _vertexValues[i]['fim'] =
                                              int.parse(text);
                                          _vertexValues[i + 1]['inicio'] =
                                              int.parse(text) + 1;

                                          if (_vertexValues[i + 1]['inicio']! >
                                              _vertexValues[i + 1]['fim']!) {
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
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 8),
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          _vertexValues[i]['fim'].toString()),
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
