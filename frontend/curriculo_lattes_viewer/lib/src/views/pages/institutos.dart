import 'package:curriculo_lattes_viewer/src/controllers/intitutos_controller.dart';
import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
import 'package:curriculo_lattes_viewer/src/views/components/informacoes_instituto_dialog.dart';
import 'package:curriculo_lattes_viewer/src/views/components/navegacao.dart';
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
          return InformacoesInstitutoDialog(
              codigoTFController: _codigoTFController,
              nomeTFController: _nomeTFController,
              acronimoTFController: _acronimoTFController);
        });
  }

  Future<void> _excluirInstitutoSelecionado() async {
    var instituto = _tableController.getSelectedRows().first;
    await _controller.deletar(instituto.id);
    _tableController.removeRow(instituto.id);
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
      drawer: const Drawer(
        child: Navegacao(),
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
            var temp = await _controller.filtrar(
                filtering.valueOrNullAs<String>('nome'),
                filtering.valueOrNullAs<String>('acronimo'),
                sortBy?.columnId,
                (sortBy?.descending ?? false) ? 'ASC' : 'DESC');
            return PaginationResult.items(elements: temp, nextPageToken: 'abc');
          },
          initialPage: '',
          columns: [
            TableColumn(
                id: "nome",
                title: "Nome",
                cellBuilder: (instituto) => Text(instituto.nome),
                sortable: true,
                sizeFactor: 0.7),
            TableColumn(
                id: "acronimo",
                title: "Acronimo",
                cellBuilder: (instituto) => Text(instituto.acronimo),
                sortable: true,
                sizeFactor: 0.2),
          ],
          filters: [
            TextTableFilter(
                chipFormatter: (texto) => texto,
                id: "nome",
                title: "Filtrar por nome"),
            TextTableFilter(
                chipFormatter: (texto) => texto,
                id: "acronimo",
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
                title: const Text("Excluir selecionado"),
                onTap: () {
                  if (_tableController.getSelectedRows().isEmpty) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        text: "Selecione um instituto");
                  } else {
                    if (_tableController.getSelectedRows().length > 1) {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          text: "Selecione apenas 1 instituto");
                    } else {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text:
                              'Deseja excluir ${_tableController.getSelectedRows().first.nome}?',
                          confirmBtnText: 'Confirmar',
                          cancelBtnText: 'Cancelar',
                          confirmBtnColor: Colors.red,
                          title: 'Você tem certeza?',
                          onConfirmBtnTap: () async {
                            await _excluirInstitutoSelecionado();
                            Navigator.of(context).pop();
                          });
                    }
                  }
                }),
            const FilterMenuDivider(),
          ]),
        ),
      ),
    );
  }
}
