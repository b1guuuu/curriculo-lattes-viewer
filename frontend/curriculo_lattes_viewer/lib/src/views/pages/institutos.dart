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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Institutos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SizedBox(
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
                      SizedBox(
                        width: 10,
                      ),
                      FilledButton(
                          onPressed: () => print('click'),
                          child: Text('Aplicar'))
                    ],
                  ),
                ),
                const Text('Institutos:'),
                Table(
                  children: [TableRow()],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
