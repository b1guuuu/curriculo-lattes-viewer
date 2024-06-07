import 'package:curriculo_lattes_viewer/src/controllers/dropbox_controller.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class Dropbox extends StatefulWidget {
  final DropboxController dropboxController;
  final String label;
  final bool enableOptionAll;

  const Dropbox(
      {super.key,
      required this.dropboxController,
      required this.label,
      required this.enableOptionAll});

  @override
  State<Dropbox> createState() {
    return enableOptionAll
        ? DropboxWithOptionAllState()
        : DropboxWithoutOptionAllState();
  }
}

class DropboxWithOptionAllState extends State<Dropbox> {
  final _opcaoTodos = {"id": -1, "label": "Todos"};

  @override
  void initState() {
    super.initState();
    if (widget.dropboxController.optionAllSelected) {
      widget.dropboxController.selectedItems.add(_opcaoTodos);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var mainContainerWidth = screenWidth / 4;
    var optionContainerWidth = mainContainerWidth - 50;
    var optionTextWidth = optionContainerWidth - 150;

    return Container(
      width: mainContainerWidth,
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${widget.label}: '),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: DropDownMultiSelect(
                options: [_opcaoTodos, ...widget.dropboxController.items],
                selectedValues: widget.dropboxController.selectedItems,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.onPrimary,
                  focusColor: Theme.of(context).colorScheme.onPrimary,
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5)),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 208, 208, 208),
                      width: 1.8,
                    ),
                  ),
                ),
                whenEmpty: 'Não há ${widget.label} para os filtros definidos',
                menuItembuilder: (option) => SizedBox(
                  width: optionContainerWidth,
                  child: Row(
                    children: [
                      Checkbox.adaptive(
                          value: option['id'] == -1
                              ? widget.dropboxController.optionAllSelected
                              : widget.dropboxController.selectedItems
                                  .contains(option),
                          onChanged: null),
                      SizedBox(
                        width: optionTextWidth,
                        child: Text(
                          option['id'] == -1
                              ? option['label']
                              : option[widget.dropboxController.displayField],
                          style:
                              const TextStyle(overflow: TextOverflow.ellipsis),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                ),
                childBuilder: (selectedValues) => Text(
                  selectedValues.isEmpty
                      ? 'Selecione ${widget.label}'
                      : '  ${widget.dropboxController.optionAllSelected && widget.dropboxController.selectedItems.contains(_opcaoTodos) ? selectedValues.length - 1 : selectedValues.length} itens selecionados',
                  style: const TextStyle(color: Colors.black54),
                ),
              ))
            ],
          )
        ],
      ),
    );
  }

  void _onChanged(List<Map<String, dynamic>> changedItems) {
    setState(() {
      widget.dropboxController.loading = true;
    });
    if (changedItems.contains(_opcaoTodos) &&
        !widget.dropboxController.optionAllSelected) {
      widget.dropboxController.selectedItems = [
        _opcaoTodos,
        ...widget.dropboxController.items
      ];
      widget.dropboxController.optionAllSelected = true;
    } else {
      if (!changedItems.contains(_opcaoTodos) &&
          widget.dropboxController.optionAllSelected) {
        setState(() {
          widget.dropboxController.selectedItems.clear();
          widget.dropboxController.optionAllSelected = false;
        });
      } else {
        if (widget.dropboxController.selectedItems.contains(_opcaoTodos)) {
          setState(() {
            widget.dropboxController.selectedItems.remove(_opcaoTodos);
            widget.dropboxController.optionAllSelected = false;
          });
        }
      }
    }

    if (widget.dropboxController.onSelect != null) {
      widget.dropboxController.onSelect!();
    }
  }
}

class DropboxWithoutOptionAllState extends State<Dropbox> {
  @override
  void initState() {
    super.initState();
    setState(() {
      widget.dropboxController.optionAllSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var mainContainerWidth = screenWidth / 4;

    return Container(
      width: mainContainerWidth,
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${widget.label}: '),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: DropdownButtonFormField(
                      value: widget.dropboxController.selectedItems.first,
                      items: widget.dropboxController.items
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(item[
                                    widget.dropboxController.displayField]),
                              ))
                          .toList(),
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).colorScheme.onPrimary,
                        focusColor: Theme.of(context).colorScheme.onPrimary,
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5)),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 208, 208, 208),
                            width: 1.8,
                          ),
                        ),
                      ),
                      onChanged: _onChanged))
            ],
          )
        ],
      ),
    );
  }

  void _onChanged(dynamic selectedItem) {
    print(selectedItem);
    setState(() {
      widget.dropboxController.selectedItems.clear();
      widget.dropboxController.selectedItems.add(selectedItem);
    });
    if (widget.dropboxController.onSelect != null) {
      widget.dropboxController.onSelect!();
    }
  }
}
