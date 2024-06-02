import 'package:curriculo_lattes_viewer/src/controllers/intitutos_controller.dart';
import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
import 'package:curriculo_lattes_viewer/src/views/components/informacoes_instituto_dialog.dart';
import 'package:curriculo_lattes_viewer/src/views/components/navegacao.dart';
import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:quickalert/quickalert.dart';

class InstitutosPage extends StatefulWidget {
  static const rota = 'institutos';

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

  final _tableController = PagedDataTableController<String, Instituto>();

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
    var institutoSelecionado = _tableController.selectedItems.first;
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
    var instituto = _tableController.selectedItems.first;
    await _controller.deletar(instituto.id);
    setState(() {
      _tableController.unselectAllRows();
      _tableController.refresh();
    });
  }

  @override
  void dispose() {
    _tableController.dispose();
    super.dispose();
  }

  void _alternaSelecao(bool? selecionado) {
    if (selecionado == true) {
      setState(() {
        _tableController.selectAllRows();
      });
    } else {
      setState(() {
        _tableController.unselectAllRows();
      });
    }
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
        child: PagedDataTable<String, Instituto>(
          controller: _tableController,
          fetcher: (int pageSize, SortModel? sortModel, FilterModel filterModel,
              String? pageToken) async {
            var temp = await _controller.filtrar(
                filterModel['nome'],
                filterModel['acronimo'],
                sortModel?.fieldName,
                (sortModel?.descending ?? false) ? 'ASC' : 'DESC',
                int.parse(pageToken ?? '0'),
                pageSize);
            var totalInstitutos = await _controller.contar(
                filterModel['nome'], filterModel['acronimo']);
            var nextPageToken = int.parse(pageToken ?? '0') + pageSize;
            return (
              temp,
              nextPageToken > totalInstitutos ? null : nextPageToken.toString()
            );
          },
          initialPage: '0',
          columns: [
            TableColumn(
                id: "select",
                title: Checkbox.adaptive(
                    value: _tableController.selectedRows.length ==
                        _tableController.totalItems,
                    onChanged: _alternaSelecao),
                cellBuilder: (context, pesquisador, index) => Checkbox.adaptive(
                    value: _tableController.selectedItems.contains(pesquisador),
                    onChanged: (bool? selecionado) {
                      if (selecionado == true) {
                        setState(() {
                          _tableController.selectRow(index);
                        });
                      } else {
                        setState(() {
                          _tableController.unselectRow(index);
                        });
                      }
                    }),
                sortable: false,
                size: const FractionalColumnSize(0.05)),
            TableColumn(
              id: "acronimo",
              title: const Text('Acrônimo'),
              cellBuilder: (context, instituto, index) =>
                  Text(instituto.acronimo),
              sortable: true,
            ),
            TableColumn(
                id: "nome",
                title: const Text('Nome'),
                cellBuilder: (context, instituto, index) =>
                    Text(instituto.nome),
                sortable: true,
                size: const RemainingColumnSize()),
          ],
          filters: [
            TextTableFilter(
              id: "nome",
              name: "Filtrar por nome",
              chipFormatter: (texto) => texto,
            ),
            TextTableFilter(
              id: "acronimo",
              name: "Filtrar por acronimo",
              chipFormatter: (texto) => texto,
            ),
          ],
          filterBarChild: PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: const Text("Adicionar instituto"),
                  onTap: () async {
                    _defineTextControllersNovoInstituto();
                    await _modalBuilder(context);
                    setState(() {
                      _tableController.refresh();
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Text("Editar selecionado"),
                  onTap: () async {
                    if (_tableController.selectedItems.isEmpty) {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          text: "Nenhum instituto foi selecionado");
                    } else {
                      if (_tableController.selectedItems.length > 1) {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            text: "Selecione apenas 1 instituto");
                      } else {
                        _defineTextControllersEditarInstituto();
                        await _modalBuilder(context);
                        setState(() {
                          _tableController.refresh();
                        });
                      }
                    }
                  },
                ),
                PopupMenuItem(
                    child: const Text("Excluir selecionado"),
                    onTap: () {
                      if (_tableController.selectedItems.isEmpty) {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            text: "Selecione um instituto");
                      } else {
                        if (_tableController.selectedItems.length > 1) {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              text: "Selecione apenas 1 instituto");
                        } else {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              text:
                                  'Deseja excluir ${_tableController.selectedItems.first.nome}?',
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
              ];
            },
          ),
        ),
      ),
    );
  }
}
