import 'package:curriculo_lattes_viewer/src/controllers/intitutos_controller.dart';
import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
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
  List<Instituto> _institutos = [];
  InstitutosDataSource _institutosDataSource =
      InstitutosDataSource(institutos: [], larguraTabela: 1080);
  final InstitutosController _controller = InstitutosController();
  final TextEditingController _termoTFController = TextEditingController();
  final TextEditingController _codigoTFController = TextEditingController();
  final TextEditingController _nomeTFController = TextEditingController();
  final TextEditingController _acronimoTFController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listaInstitutos();
  }

  Future<void> _listaInstitutos() async {
    var temp = await _controller.listar();
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

  void _defineTextControllersNovoInstituto() {
    setState(() {
      _codigoTFController.value = const TextEditingValue(text: '');
      _nomeTFController.value = const TextEditingValue(text: '');
      _acronimoTFController.value = const TextEditingValue(text: '');
    });
  }

  void _defineTextControllersEditarInstituto(int indexInstituto) {
    setState(() {
      _codigoTFController.value =
          TextEditingValue(text: _institutos[indexInstituto].id.toString());
      _nomeTFController.value =
          TextEditingValue(text: _institutos[indexInstituto].nome);
      _acronimoTFController.value =
          TextEditingValue(text: _institutos[indexInstituto].acronimo);
    });
  }

  Future<void> _modalBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Novo Instituto'),
            content: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                      hintText: 'Código', border: OutlineInputBorder()),
                  readOnly: true,
                  controller: _codigoTFController,
                ),
                TextField(
                  decoration: const InputDecoration(
                      hintText: 'Nome', border: OutlineInputBorder()),
                  controller: _nomeTFController,
                ),
                TextField(
                  decoration: const InputDecoration(
                      hintText: 'Acronimo', border: OutlineInputBorder()),
                  controller: _acronimoTFController,
                )
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () => {
                  if (_codigoTFController.value.text.isEmpty)
                    {
                      _controller
                          .inserir(_nomeTFController.value.text,
                              _acronimoTFController.value.text)
                          .then((value) => Navigator.pop(context))
                    }
                  else
                    {}
                },
                child: const Text('Gravar'),
              ),
              FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')),
            ],
          );
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
                            controller: _termoTFController,
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
                          child: const Text('Aplicar'))
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
                  padding: const EdgeInsets.all(10),
                  child: PaginatedDataTable(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FilledButton(
                              onPressed: () async {
                                _defineTextControllersNovoInstituto();
                                await _modalBuilder(context);
                                await _listaInstitutos();
                                _inicializaInstitutoDataSource();
                              },
                              child: const Text('Incluir')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FilledButton(
                              onPressed: () => print('Excluir'),
                              child: const Text('Excluir')),
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
