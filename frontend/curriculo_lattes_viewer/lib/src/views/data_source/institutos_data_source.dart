import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
import 'package:flutter/material.dart';

class InstitutosDataSource extends DataTableSource {
  final List<Instituto> _institutos;
  final double _larguraTabela;

  InstitutosDataSource(
      {required List<Instituto> institutos, required double larguraTabela})
      : _institutos = institutos,
        _larguraTabela = larguraTabela;

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: <DataCell>[
      DataCell(SizedBox(
        width: _larguraTabela * 0.7,
        child: Text(_institutos[index].nome),
      )),
      DataCell(SizedBox(
        width: _larguraTabela * 0.3,
        child: Text(_institutos[index].acronimo),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _institutos.length;

  @override
  int get selectedRowCount => 0;
}
