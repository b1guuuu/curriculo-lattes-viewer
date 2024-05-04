import 'package:curriculo_lattes_viewer/src/controllers/intitutos_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/pesquisadores_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/trabalho_controller.dart';
import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
import 'package:curriculo_lattes_viewer/src/models/pesquisador.dart';
import 'package:curriculo_lattes_viewer/src/models/trabalho.dart';
import 'package:curriculo_lattes_viewer/src/views/components/navegacao.dart';
import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';

class ProducaoPage extends StatefulWidget {
  static const rota = 'producao';

  const ProducaoPage({super.key});

  @override
  State<ProducaoPage> createState() {
    return ProducaoPageState();
  }
}

class ProducaoPageState extends State<ProducaoPage> {
  final _trabalhoController = TrabalhoController();
  final _institutosController = InstitutosController();
  final _pesquisadoresController = PesquisadoresController();
  final _tableController = PagedDataTableController<int, int, Trabalho>();
  List<Instituto> _institutos = [];
  List<Pesquisador> _pesquisadores = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _buscarInstitutos() async {
    var temp = await _institutosController.listar();
    setState(() {
      _institutos = temp;
    });
  }

  Future<void> _buscarPesquisadores() async {
    var temp = await _pesquisadoresController.listar();
    setState(() {
      _pesquisadores = temp;
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
          title: const Text('Itens de produção'),
        ),
        drawer: const Drawer(
          child: Navegacao(),
        ),
        body: Container(
          color: const Color.fromARGB(255, 208, 208, 208),
          padding: const EdgeInsets.all(20.0),
          child: PagedDataTable<int, int, Trabalho>(
            rowsSelectable: true,
            idGetter: (trabalho) => trabalho.id,
            controller: _tableController,
            fetchPage: (pageToken, pageSize, sortBy, filtering) async {
              print('pageToken');
              print(pageToken);
              print('pageSize');
              print(pageSize);
              print('sortBy');
              print(sortBy);
              print('filtering');
              print(filtering);
              var temp = await _trabalhoController.filtrar();
              return PaginationResult.items(
                  elements: temp, nextPageToken: null);
            },
            initialPage: 0,
            columns: [
              TableColumn(
                  id: "tipo",
                  title: "Tipo",
                  cellBuilder: (trabalho) => Text(trabalho.tipo),
                  sortable: true,
                  sizeFactor: 0.1),
              TableColumn(
                  id: "detalhamento",
                  title: "Detalhamento",
                  cellBuilder: (trabalho) => Text(
                        trabalho.formataDetalhamento(),
                        maxLines: 3,
                        softWrap: true,
                      ),
                  sortable: false,
                  sizeFactor: 0.8),
            ],
            filters: [
              TextTableFilter(
                id: "ano.inicio",
                title: "Ano inicício",
                chipFormatter: (texto) => texto,
              ),
              TextTableFilter(
                  id: "ano.fim",
                  title: "Ano fim",
                  chipFormatter: (texto) => texto),
              DropdownTableFilter(
                id: 'instituto',
                title: 'Instituto',
                items: _institutos
                    .map((instituto) => DropdownMenuItem(
                          value: instituto,
                          child: Text(instituto.nome),
                        ))
                    .toList(),
                chipFormatter: (instituto) => instituto.nome,
              ),
              DropdownTableFilter(
                id: 'pesquisador',
                title: 'Pesquisador',
                items: _pesquisadores
                    .map((pesquisador) => DropdownMenuItem(
                          value: pesquisador,
                          child: Text(pesquisador.nome),
                        ))
                    .toList(),
                chipFormatter: (pesquisador) => pesquisador.nome,
              ),
              DropdownTableFilter(
                id: 'tipo',
                title: 'Tipo de publicação',
                items: const [
                  DropdownMenuItem(
                    value: 'LIVRO',
                    child: Text('LIVRO'),
                  ),
                  DropdownMenuItem(value: 'ARTIGO', child: Text('ARTIGO')),
                ],
                chipFormatter: (tipo) => tipo,
              ),
            ],
          ),
        ));
  }
}
