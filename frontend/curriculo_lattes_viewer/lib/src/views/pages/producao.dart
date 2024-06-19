// ignore_for_file: prefer_null_aware_operators, prefer_if_null_operators

import 'package:curriculo_lattes_viewer/src/controllers/intitutos_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/pesquisadores_controller.dart';
import 'package:curriculo_lattes_viewer/src/controllers/trabalho_controller.dart';
import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
import 'package:curriculo_lattes_viewer/src/models/pesquisador.dart';
import 'package:curriculo_lattes_viewer/src/models/trabalho.dart';
import 'package:curriculo_lattes_viewer/src/views/components/carregando.dart';
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
  final _tableController = PagedDataTableController<String, Trabalho>();
  List<Instituto> _institutos = [];
  List<Pesquisador> _pesquisadores = [];
  bool _carregando = true;
  int _contador = 0;

  @override
  void initState() {
    super.initState();
    _buscarInstitutos().then((value) => _buscarPesquisadores());
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
      _carregando = false;
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
          title: Text('$_contador Itens de produção'),
        ),
        drawer: const Drawer(
          child: Navegacao(),
        ),
        body: _carregando
            ? const Carregando()
            : Flexible(
                child: Container(
                  color: const Color.fromARGB(255, 208, 208, 208),
                  padding: const EdgeInsets.all(20.0),
                  child: Flexible(
                    child: Flexible(
                      child: PagedDataTable<String, Trabalho>(
                        controller: _tableController,
                        fetcher: (int pageSize, SortModel? sortModel,
                            FilterModel filterModel, String? pageToken) async {
                          try {
                            var temp = await _trabalhoController.filtrar(
                                filterModel['ano.inicio'] == null
                                    ? null
                                    : int.parse(filterModel['ano.inicio']),
                                filterModel['ano.fim'] == null
                                    ? null
                                    : int.parse(filterModel['ano.fim']),
                                filterModel['instituto'] == null
                                    ? null
                                    : filterModel['instituto'].id,
                                filterModel['pesquisador'] == null
                                    ? null
                                    : filterModel['pesquisador'].id,
                                filterModel['tipo'] == null
                                    ? null
                                    : filterModel['tipo'],
                                sortModel?.fieldName,
                                (sortModel?.descending ?? false)
                                    ? 'ASC'
                                    : 'DESC',
                                int.parse(pageToken ?? '0'),
                                pageSize);
                            var totalTrabalhos =
                                await _trabalhoController.contar(
                                    filterModel['ano.inicio'] == null
                                        ? null
                                        : int.parse(filterModel['ano.inicio']),
                                    filterModel['ano.fim'] == null
                                        ? null
                                        : int.parse(filterModel['ano.fim']),
                                    filterModel['instituto'] == null
                                        ? null
                                        : filterModel['instituto'].id,
                                    filterModel['pesquisador'] == null
                                        ? null
                                        : filterModel['pesquisador'].id,
                                    filterModel['tipo'] == null
                                        ? null
                                        : filterModel['tipo']);
                            setState(() {
                              _contador = totalTrabalhos;
                            });
                            var nextPageToken =
                                int.parse(pageToken ?? '0') + pageSize;
                            return (
                              temp,
                              nextPageToken > totalTrabalhos
                                  ? null
                                  : nextPageToken.toString()
                            );
                          } catch (e) {
                            print(e);

                            return (List<Trabalho>.empty(), null);
                          }
                        },
                        initialPage: '0',
                        columns: [
                          TableColumn(
                              id: "tipo",
                              title: const Text('Tipo'),
                              cellBuilder: (context, trabalho, index) =>
                                  Text(trabalho.tipo),
                              sortable: true),
                          TableColumn(
                              id: "detalhamento",
                              title: const Text('Detalhamento'),
                              cellBuilder: (context, trabalho, index) => Text(
                                    trabalho.formataDetalhamento(),
                                    maxLines: 5,
                                    softWrap: true,
                                  ),
                              sortable: false,
                              size: const RemainingColumnSize()),
                        ],
                        filters: [
                          TextTableFilter(
                            id: "ano.inicio",
                            name: "Ano inicício",
                            chipFormatter: (texto) => texto,
                          ),
                          TextTableFilter(
                              id: "ano.fim",
                              name: "Ano fim",
                              chipFormatter: (texto) => texto),
                          DropdownTableFilter(
                            id: 'instituto',
                            name: 'Instituto',
                            items: _institutos
                                .map((instituto) => DropdownMenuItem(
                                      value: instituto,
                                      child: Text(instituto.nome),
                                    ))
                                .toList(),
                            chipFormatter: (instituto) =>
                                (instituto as Instituto).nome,
                          ),
                          DropdownTableFilter(
                            id: 'pesquisador',
                            name: 'Pesquisador',
                            items: _pesquisadores
                                .map((pesquisador) => DropdownMenuItem(
                                      value: pesquisador,
                                      child: Text(pesquisador.nome!),
                                    ))
                                .toList(),
                            chipFormatter: (pesquisador) =>
                                (pesquisador as Pesquisador).nome!,
                          ),
                          DropdownTableFilter(
                            id: 'tipo',
                            name: 'Tipo de publicação',
                            items: const [
                              DropdownMenuItem(
                                value: 'LIVRO',
                                child: Text('LIVRO'),
                              ),
                              DropdownMenuItem(
                                  value: 'ARTIGO', child: Text('ARTIGO')),
                            ],
                            chipFormatter: (tipo) => tipo.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}
