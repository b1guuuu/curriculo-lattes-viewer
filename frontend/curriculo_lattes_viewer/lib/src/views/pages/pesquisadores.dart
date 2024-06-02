import 'package:curriculo_lattes_viewer/src/controllers/intitutos_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/pesquisadores_controller.dart';
import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
import 'package:curriculo_lattes_viewer/src/models/pesquisador.dart';
import 'package:curriculo_lattes_viewer/src/views/components/cadastrar_pesquisador_dialog.dart';
import 'package:curriculo_lattes_viewer/src/views/components/navegacao.dart';
import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:quickalert/quickalert.dart';

class PesquisadoresPage extends StatefulWidget {
  static const rota = 'pesquisadores';

  const PesquisadoresPage({super.key});

  @override
  State<PesquisadoresPage> createState() {
    return PesquisadoresPageState();
  }
}

class PesquisadoresPageState extends State<PesquisadoresPage> {
  final PesquisadoresController _pesquisadoresController =
      PesquisadoresController();
  final InstitutosController _institutosController = InstitutosController();

  final _tableController = PagedDataTableController<String, Pesquisador>();

  late List<Instituto> _institutos = [];

  @override
  void initState() {
    super.initState();
    _buscarInstitutos();
  }

  Future<void> _buscarInstitutos() async {
    var temp = await _institutosController.listar();
    setState(() {
      _institutos = temp;
    });
  }

  Future<void> _modalBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CadastrarPesquisadorDialog(institutos: _institutos);
        });
  }

  Future<void> _excluirPesquisadorSelecionado() async {
    var pesquisador = _tableController.selectedItems.first;
    await _pesquisadoresController.deletar(pesquisador.id);
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
        title: const Text('Pesquisadores'),
      ),
      drawer: const Drawer(
        child: Navegacao(),
      ),
      body: Container(
        color: const Color.fromARGB(255, 208, 208, 208),
        padding: const EdgeInsets.all(20.0),
        child: PagedDataTable<String, Pesquisador>(
          controller: _tableController,
          fetcher: (int pageSize, SortModel? sortModel, FilterModel filterModel,
              String? pageToken) async {
            var temp = await _pesquisadoresController.filtrar(
                filterModel['pesquisador.nome'],
                filterModel['instituto.nome'],
                sortModel?.fieldName,
                (sortModel?.descending ?? false) ? 'ASC' : 'DESC',
                int.parse(pageToken ?? '0'),
                pageSize);
            var totalPesquisadores = await _pesquisadoresController.contar(
              filterModel['pesquisador.nome'],
              filterModel['instituto.nome'],
            );
            var nextPageToken = int.parse(pageToken ?? '0') + pageSize;

            return (
              temp,
              nextPageToken > totalPesquisadores
                  ? null
                  : nextPageToken.toString()
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
                        _tableController.selectRow(index);
                      } else {
                        _tableController.unselectRow(index);
                      }
                    }),
                sortable: false,
                size: const FractionalColumnSize(0.05)),
            TableColumn(
                id: "pesquisador.nome",
                title: const Text('Nome'),
                cellBuilder: (context, pesquisador, index) =>
                    Text(pesquisador.nome),
                sortable: true,
                size: const FractionalColumnSize(0.15)),
            TableColumn(
              id: "email",
              title: const Text('Email'),
              cellBuilder: (context, pesquisador, index) =>
                  Text(pesquisador.email),
              sortable: false,
            ),
            TableColumn(
                id: "instituto.nome",
                title: const Text('Instituto'),
                cellBuilder: (context, pesquisador, index) => Text(
                    (_institutos.firstWhere((instituto) =>
                        instituto.id == pesquisador.idInstituto)).nome),
                sortable: true,
                size: const RemainingColumnSize()),
          ],
          filters: [
            TextTableFilter(
              id: "pesquisador.nome",
              name: "Filtrar por nome do pesquisador",
              chipFormatter: (texto) => texto,
            ),
            TextTableFilter(
              id: "instituto.nome",
              name: "Filtrar por nome do instituto",
              chipFormatter: (texto) => texto,
            ),
          ],
          filterBarChild: PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text("Adicionar pesquisador"),
                  onTap: () async {
                    await _modalBuilder(context);
                    _tableController.refresh();
                  },
                ),
                PopupMenuItem(
                    child: const Text("Excluir selecionado"),
                    onTap: () {
                      if (_tableController.selectedItems.isEmpty) {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            text: "Selecione um pesquisador");
                      } else {
                        if (_tableController.selectedItems.length > 1) {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              text: "Selecione apenas 1 pesquisador");
                        } else {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              text:
                                  'Deseja mesmo excluir o ID: ${_tableController.selectedItems.first.id} de ${_tableController.selectedItems.first.nome}?',
                              confirmBtnText: 'Confirmar',
                              cancelBtnText: 'Cancelar',
                              confirmBtnColor: Colors.red,
                              title: 'Você tem certeza?',
                              onConfirmBtnTap: () async {
                                await _excluirPesquisadorSelecionado();
                                _tableController.refresh();
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
