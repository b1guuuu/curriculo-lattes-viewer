import 'package:curriculo_lattes_viewer/src/controllers/intitutos_controller.dart';
import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
import 'package:curriculo_lattes_viewer/src/views/components/carregando.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class DropboxInstituto extends StatefulWidget {
  const DropboxInstituto({super.key});

  @override
  DropboxInstitutoState createState() => DropboxInstitutoState();
}

class DropboxInstitutoState extends State<DropboxInstituto> {
  final InstitutosController _institutosController = InstitutosController();

  late List<Instituto> _institutos = [];
  List<String> selectedCheckBoxValue = [];
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
    var temp = await _institutosController.listar();
    setState(() {
      _institutos = temp;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<String> allacronimos =
        _institutos.map((instituto) => instituto.acronimo).toList();

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
                    const Text('Instituto:'),
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
                        options: ['  Selecionar Todos', ...allacronimos],
                        selectedValues: selectedCheckBoxValue,
                        onChanged: (List<String> values) {
                          setState(() {
                            if (values.contains('  Selecionar Todos')) {
                              if (selectedCheckBoxValue.length ==
                                  allacronimos.length + 1) {
                                selectedCheckBoxValue = [];
                              } else {
                                selectedCheckBoxValue = [
                                  '  Selecionar Todos',
                                  ...allacronimos
                                ];
                              }
                            } else {
                              selectedCheckBoxValue = values;
                            }
                          });
                        },
                        whenEmpty: '  Selecione Pesquisadores',
                        // Customização do display quando o dropdown está fechado
                        childBuilder: (List<String> selectedValues) {
                          return Text(
                            selectedValues.isEmpty ||
                                    selectedValues
                                        .contains('  Selecionar Todos')
                                ? '  Selecione Institutos'
                                : '  Selecione Institutos',
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
