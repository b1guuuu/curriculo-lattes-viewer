import 'package:curriculo_lattes_viewer/src/controllers/pesquisadores_controller.dart';
import 'package:curriculo_lattes_viewer/src/models/pesquisador.dart';
import 'package:curriculo_lattes_viewer/src/views/components/carregando.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class DropboxPesquisador extends StatefulWidget {
  const DropboxPesquisador({super.key});

  @override
  DropboxPesquisadorState createState() => DropboxPesquisadorState();
}

class DropboxPesquisadorState extends State<DropboxPesquisador> {
  final _pesquisadoresController = PesquisadoresController();

  late List<Pesquisador> _pesquisadores = [];
  List<String> selectedPesquisadores = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _loadPesquisadores();
  }

  Future<void> _loadPesquisadores() async {
    setState(() {
      _carregando = true;
    });
    var temp = await _pesquisadoresController.listar();
    setState(() {
      _pesquisadores = temp;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<String> allNomes =
        _pesquisadores.map((pesquisador) => pesquisador.nome).toList();

    return _carregando
        ? const Carregando()
        : Container(
            width: screenWidth / 4,
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Pesquisador:'),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: DropDownMultiSelect(
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).colorScheme.onPrimary,
                          focusColor: Theme.of(context).colorScheme.onPrimary,
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 208, 208, 208),
                              width: 1.8,
                            ),
                          ),
                        ),
                        options: ['  Selecionar Todos', ...allNomes],
                        selectedValues: selectedPesquisadores,
                        onChanged: (List<String> values) {
                          setState(() {
                            if (values.contains('  Selecionar Todos')) {
                              if (selectedPesquisadores.length ==
                                  allNomes.length + 1) {
                                selectedPesquisadores = [];
                              } else {
                                selectedPesquisadores = [
                                  '  Selecionar Todos',
                                  ...allNomes
                                ];
                              }
                            } else {
                              selectedPesquisadores = values;
                            }
                          });
                        },
                        whenEmpty: '  Selecione Pesquisadores',
                        childBuilder: (List<String> selectedValues) {
                          return Text(
                            selectedValues.isEmpty ||
                                    selectedValues
                                        .contains('  Selecionar Todos')
                                ? '  Selecione Pesquisadores'
                                : '  Selecione Pesquisadores',
                            style: const TextStyle(color: Colors.black54),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
