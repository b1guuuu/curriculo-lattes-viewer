import 'package:curriculo_lattes_viewer/src/models/regra_plotagem_grafo.dart';

class GraphOptionsBuilder {
  final List<Map<String, dynamic>> institutos;
  final List<Map<String, dynamic>> pesquisadores;
  final List<RegraPlotagemGrafo> regras;
  final String tipoProducao;
  final String vertice;

  GraphOptionsBuilder(
      {required this.institutos,
      required this.pesquisadores,
      required this.regras,
      required this.tipoProducao,
      required this.vertice});

  List<int> getInstitutosIds() {
    List<int> ids = [];
    for (var instituto in institutos) {
      if (instituto['id'] != -1) {
        ids.add(instituto['id']);
      }
    }
    return ids;
  }

  List<String> getPesquisadoresIds() {
    List<String> ids = [];
    for (var pesquisador in pesquisadores) {
      if (pesquisador['id'] != -1) {
        ids.add(pesquisador['id']);
      }
    }
    return ids;
  }

  List<Map<String, dynamic>> getRegrasMaps() {
    List<Map<String, dynamic>> maps = [];
    for (var regra in regras) {
      maps.add(regra.toMap());
    }
    return maps;
  }

  Map<String, dynamic> buildOptions() {
    return {
      'institutos': getInstitutosIds(),
      'pesquisadores': getPesquisadoresIds(),
      'tipoProducao': tipoProducao,
      'vertice': vertice,
      'regras': getRegrasMaps()
    };
  }
}
