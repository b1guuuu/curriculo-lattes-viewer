import 'package:curriculo_lattes_viewer/src/controllers/intitutos_controller.dart';
import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:quickalert/quickalert.dart';

class InstitutosPage extends StatefulWidget {
  static const rota = '/institutos';

  const InstitutosPage({super.key});

  @override
  State<InstitutosPage> createState() {
    return InstitutosPageState();
  }
}

class InstitutosPageState extends State<InstitutosPage> {
  final InstitutosController _controller = InstitutosController();
  final TextEditingController _codigoTFController = TextEditingController();
  final TextEditingController _nomeTFController = TextEditingController();
  final TextEditingController _acronimoTFController = TextEditingController();

  final _tableController = PagedDataTableController<String, int, Instituto>();

  @override
  void initState() {
    super.initState();
  }

  void _defineTextControllersNovoInstituto() {
    setState(() {
      _codigoTFController.value = const TextEditingValue(text: '');
      _nomeTFController.value = const TextEditingValue(text: '');
      _acronimoTFController.value = const TextEditingValue(text: '');
    });
  }

  void _defineTextControllersEditarInstituto() {
    var institutoSelecionado = _tableController.getSelectedRows().first;
    setState(() {
      _codigoTFController.value =
          TextEditingValue(text: institutoSelecionado.id.toString());
      _nomeTFController.value =
          TextEditingValue(text: institutoSelecionado.nome);
      _acronimoTFController.value =
          TextEditingValue(text: institutoSelecionado.acronimo);
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
                onPressed: () async {
                  if (_codigoTFController.value.text.isEmpty) {
                    await _controller.inserir(_nomeTFController.value.text,
                        _acronimoTFController.value.text);
                  } else {}
                  Navigator.of(context).pop();
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

  Future<void> _excluirInstitutosSelecionados() async {
    var institutosSelecionados = _tableController.getSelectedRows();
    institutosSelecionados.forEach((Instituto instituto) async {
      await _controller.deletar(instituto.id);
      _tableController.removeRow(instituto.id);
    });
  }

  @override
  void dispose() {
    _tableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Institutos'),
      ),
      body: Container(
        color: const Color.fromARGB(255, 208, 208, 208),
        padding: const EdgeInsets.all(20.0),
        child: PagedDataTable<String, int, Instituto>(
          rowsSelectable: true,
          idGetter: (instituto) => instituto.id,
          controller: _tableController,
          fetchPage: (pageToken, pageSize, sortBy, filtering) async {
            print(pageToken);
            print(pageSize);
            print(sortBy);
            print(filtering);
            var temp = await _controller.listar();
            return PaginationResult.items(elements: temp, nextPageToken: 'abc');
          },
          initialPage: '',
          columns: [
            TableColumn(
                id: "nomeFiltro",
                title: "Nome",
                cellBuilder: (instituto) => Text(instituto.nome),
                sortable: true),
            TableColumn(
                id: "acronimoFiltro",
                title: "Acronimo",
                cellBuilder: (instituto) => Text(instituto.acronimo),
                sortable: true),
          ],
          filters: [
            TextTableFilter(
                chipFormatter: (texto) => texto,
                id: "nomeFiltro",
                title: "Filtrar por nome"),
            TextTableFilter(
                chipFormatter: (texto) => texto,
                id: "acronimoFiltro",
                title: "Filtrar por acronimo"),
          ],
          menu: PagedDataTableFilterBarMenu(items: [
            FilterMenuItem(
              title: const Text("Adicionar instituto"),
              onTap: () async {
                _defineTextControllersNovoInstituto();
                await _modalBuilder(context);
                await _tableController.refresh();
              },
            ),
            const FilterMenuDivider(),
            FilterMenuItem(
              title: const Text("Editar selecionado"),
              onTap: () async {
                if (_tableController.getSelectedRows().isEmpty) {
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: "Nenhum instituto foi selecionado");
                } else {
                  if (_tableController.getSelectedRows().length > 1) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        text: "Selecione apenas 1 instituto");
                  } else {
                    _defineTextControllersEditarInstituto();
                    await _modalBuilder(context);
                    await _tableController.refresh();
                  }
                }
              },
            ),
            const FilterMenuDivider(),
            FilterMenuItem(
                title: const Text("Excluir selecionados"),
                onTap: () {
                  if (_tableController.getSelectedRows().isEmpty) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        text: "Selecione pelo menos 1 instituto");
                  } else {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        text:
                            'Deseja excluir ${_tableController.getSelectedRows().length} institutos?',
                        confirmBtnText: 'Confirmar',
                        cancelBtnText: 'Cancelar',
                        confirmBtnColor: Colors.red,
                        title: 'Você tem certeza?',
                        onConfirmBtnTap: () async {
                          await _excluirInstitutosSelecionados();
                          Navigator.of(context).pop();
                        });
                  }
                }),
            const FilterMenuDivider(),
          ]),
        ),
      ),
    );
  }
}
