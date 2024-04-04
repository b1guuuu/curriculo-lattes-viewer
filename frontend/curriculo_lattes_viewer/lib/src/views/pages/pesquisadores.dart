import 'dart:convert';

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
  static const rota = '/pesquisadores';

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

  final TextEditingController _codigoTFController = TextEditingController();
  final TextEditingController _institutoTFController = TextEditingController();

  final _tableController = PagedDataTableController<int, String, Pesquisador>();

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
    var pesquisador = _tableController.getSelectedRows().first;
    await _pesquisadoresController.deletar(pesquisador.id);
    setState(() {
      _tableController.unselectAllRows();
    });
    await _tableController.refresh();
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
        title: const Text('Pesquisadores'),
      ),
      drawer: const Drawer(
        child: Navegacao(),
      ),
      body: Container(
        color: const Color.fromARGB(255, 208, 208, 208),
        padding: const EdgeInsets.all(20.0),
        child: PagedDataTable<int, String, Pesquisador>(
          rowsSelectable: true,
          idGetter: (pesquisador) => pesquisador.id,
          controller: _tableController,
          fetchPage: (pageToken, pageSize, sortBy, filtering) async {
            print(pageToken);
            print(pageSize);
            print(jsonEncode(sortBy.toString()));
            print(jsonEncode(filtering.toString()));
            var temp = await _pesquisadoresController.filtrar(
                filtering.valueOrNullAs<String>('pesquisador.nome'),
                filtering.valueOrNullAs<String>('instituto.nome'),
                sortBy?.columnId,
                (sortBy?.descending ?? false) ? 'ASC' : 'DESC');
            print('object');
            return PaginationResult.items(
                elements: temp, nextPageToken: pageToken + pageSize);
          },
          initialPage: 1,
          columns: [
            TableColumn(
                id: "pesquisador.nome",
                title: "Nome",
                cellBuilder: (pesquisador) => Text(pesquisador.nome),
                sortable: true,
                sizeFactor: 0.4),
            TableColumn(
                id: "email",
                title: "Email",
                cellBuilder: (pesquisador) => Text(pesquisador.email),
                sortable: false,
                sizeFactor: 0.1),
            TableColumn(
                id: "instituto.nome",
                title: "Instituto",
                cellBuilder: (pesquisador) => Text((_institutos.firstWhere(
                        (instituto) => instituto.id == pesquisador.idInstituto))
                    .nome),
                sortable: true,
                sizeFactor: 0.4),
          ],
          filters: [
            TextTableFilter(
                chipFormatter: (texto) => texto,
                id: "pesquisador.nome",
                title: "Filtrar por nome do pesquisador"),
            TextTableFilter(
                chipFormatter: (texto) => texto,
                id: "instituto.nome",
                title: "Filtrar por nome do instituto"),
          ],
          menu: PagedDataTableFilterBarMenu(items: [
            FilterMenuItem(
              title: const Text("Adicionar pesquisador"),
              onTap: () async {
                await _modalBuilder(context);
                await _tableController.refresh();
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
                        text: "Selecione um pesquisador");
                  } else {
                    if (_tableController.getSelectedRows().length > 1) {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          text: "Selecione apenas 1 pesquisador");
                    } else {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text:
                              'Deseja mesmo excluir o ID: ${_tableController.getSelectedRows().first.id} de ${_tableController.getSelectedRows().first.nome}?',
                          confirmBtnText: 'Confirmar',
                          cancelBtnText: 'Cancelar',
                          confirmBtnColor: Colors.red,
                          title: 'Você tem certeza?',
                          onConfirmBtnTap: () async {
                            await _excluirPesquisadorSelecionado();
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
