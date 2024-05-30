import 'package:curriculo_lattes_viewer/src/controllers/trabalho_controller.dart';
import 'package:curriculo_lattes_viewer/src/models/trabalho.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class DropboxProducao extends StatefulWidget {
  const DropboxProducao({Key? key}) : super(key: key);

  @override
  _DropboxProducaoState createState() => _DropboxProducaoState();
}

class _DropboxProducaoState extends State<DropboxProducao> {
  final _trabalhosController = TrabalhoController();

  late List<Trabalho> _trabalhos = [];
  List<String> selectedCheckBoxValue = [];

  @override
  void initState() {
    super.initState();
    _loadTabalhos();
  }

  Future<void> _loadTabalhos() async {
    _trabalhos = await _trabalhosController.listar();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<String> allTitulos =
        _trabalhos.map((trabalho) => trabalho.titulo).toList();

    return Container(
      width: screenWidth / 4,
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Produção:'),
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
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 208, 208, 208),
                        width: 1.8,
                      ),
                    ),
                  ),
                  options: ['  Selecionar Todos', ...allTitulos],
                  selectedValues: selectedCheckBoxValue,
                  onChanged: (List<String> values) {
                    setState(() {
                      if (values.contains('  Selecionar Todos')) {
                        if (selectedCheckBoxValue.length ==
                            allTitulos.length + 1) {
                          selectedCheckBoxValue = [];
                        } else {
                          selectedCheckBoxValue = [
                            '  Selecionar Todos',
                            ...allTitulos
                          ];
                        }
                      } else {
                        selectedCheckBoxValue = values;
                      }
                    });
                  },
                  whenEmpty: '  Selecione Produções',
                  // Customização do display quando o dropdown está fechado
                  childBuilder: (List<String> selectedValues) {
                    return Text(
                      selectedValues.isEmpty ||
                              selectedValues.contains('  Selecionar Todos')
                          ? '  Selecione Produções'
                          : '  Selecione Produções',
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
