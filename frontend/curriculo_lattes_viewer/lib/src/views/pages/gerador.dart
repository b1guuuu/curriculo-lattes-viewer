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
  List<String> _vertexValues =
      List.filled(3, '1'); // To hold the values of the second column

  @override
  void initState() {
    super.initState();
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
                  const Row(
                    children: [
                      Expanded(child: DropboxInstituto()),
                      Expanded(child: DropboxPesquisador()),
                      Expanded(child: DropboxProducao()),
                      Expanded(child: DropboxVertices()),
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
                                child: Text('${i + 1}'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: i == 0 ||
                                      i == 1 // Make the third row editable
                                  ? TextField(
                                      onChanged: (text) {
                                        setState(() {
                                          _vertexValues[i] = text;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 8),
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('${i + 1}'),
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
