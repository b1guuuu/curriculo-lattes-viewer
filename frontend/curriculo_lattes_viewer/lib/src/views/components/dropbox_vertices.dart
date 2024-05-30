import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class DropboxVertices extends StatefulWidget {
  const DropboxVertices({Key? key}) : super(key: key);

  @override
  _DropboxVerticesState createState() => _DropboxVerticesState();
}

class _DropboxVerticesState extends State<DropboxVertices> {
  List<String> _vertices = ['Pesquisador', 'Instituto'];
  List<String> selectedCheckBoxValue = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth / 4,
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Vertices:'),
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
                  options: ['  Selecionar Todos', ..._vertices],
                  selectedValues: selectedCheckBoxValue,
                  onChanged: (List<String> values) {
                    setState(() {
                      if (values.contains('  Selecionar Todos')) {
                        if (selectedCheckBoxValue.length == _vertices.length + 1) {
                          selectedCheckBoxValue = [];
                        } else {
                          selectedCheckBoxValue = ['  Selecionar Todos', ..._vertices];
                        }
                      } else {
                        selectedCheckBoxValue = values;
                      }
                    });
                  },
                  whenEmpty: '  Selecione Vertices',
                  // Customização do display quando o dropdown está fechado
                  childBuilder: (List<String> selectedValues) {
                    return Text(
                      selectedValues.isEmpty || selectedValues.contains('  Selecionar Todos')
                          ? '  Selecione Vertices'
                          : '  ${selectedValues.join(', ')}',
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
