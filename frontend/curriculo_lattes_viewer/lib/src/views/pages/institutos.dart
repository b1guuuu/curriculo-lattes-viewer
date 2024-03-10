import 'package:curriculo_lattes_viewer/src/views/data_source/institutos_data_source.dart';
import 'package:flutter/material.dart';

class InstitutosPage extends StatefulWidget {
  static const rota = '/institutos';

  const InstitutosPage({super.key});

  @override
  State<InstitutosPage> createState() {
    return InstitutosPageState();
  }
}

final List<Map<String, dynamic>> _opcoesDropdown = [
  {'texto': 'Todos', 'valor': 'nome = ? OR acronimo = ?'},
  {'texto': 'Nome', 'valor': 'nome = ?'},
  {'texto': 'Acrônimo', 'valor': 'acronimo = ?'},
];

class InstitutosPageState extends State<InstitutosPage> {
  String _valorDropdown = _opcoesDropdown.first['valor'];
  List<Map<String, dynamic>> _institutos = [];
  InstitutosDataSource _institutosDataSource =
      InstitutosDataSource(institutos: [], larguraTabela: 1080);

  @override
  void initState() {
    super.initState();
    List<Map<String, dynamic>> temp = [];
    for (var element in _opcoesDropdown) {
      temp.add({'nome': 'nome', 'acronimo': 'acronimo'});
    }
    setState(() {
      _institutos = temp;
    });
  }

  void _inicializaInstitutoDataSource() {
    setState(() {
      _institutosDataSource = InstitutosDataSource(
          institutos: _institutos,
          larguraTabela: MediaQuery.of(context).size.width * 0.9);
    });
  }

  @override
  Widget build(BuildContext context) {
    _inicializaInstitutoDataSource();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Institutos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Container(
            color: Colors.grey,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          const Text('Termo: '),
                          TextField(
                            decoration: const InputDecoration(
                                hintText: 'Digite o título...',
                                border: InputBorder.none,
                                constraints: BoxConstraints(
                                    maxHeight: 200, maxWidth: 200)),
                            onChanged: (valor) => print(valor),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          const Text('Campo: '),
                          DropdownButton(
                            value: _valorDropdown,
                            onChanged: (valor) {
                              print(valor);
                              setState(() {
                                _valorDropdown = valor!;
                              });
                            },
                            items: _opcoesDropdown
                                .map<DropdownMenuItem<dynamic>>((valor) {
                              return DropdownMenuItem(
                                value: valor['valor'],
                                child: Text(valor['texto']),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      FilledButton(
                          onPressed: () => print('click'),
                          child: Text('Aplicar'))
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [Text('Institutos:')],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: PaginatedDataTable(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FilledButton(
                              onPressed: () => print('Incluir'),
                              child: Text('Incluir')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FilledButton(
                              onPressed: () => print('Excluir'),
                              child: Text('Excluir')),
                        ),
                      ],
                    ),
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Nome')),
                      DataColumn(label: Text('Acronimo'))
                    ],
                    source: _institutosDataSource,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
