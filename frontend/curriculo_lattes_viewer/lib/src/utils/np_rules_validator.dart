import 'package:curriculo_lattes_viewer/src/models/regra_plotagem_grafo.dart';

class NpRulesValidator {
  final List<RegraPlotagemGrafo> regrasPlotagem;

  NpRulesValidator({required this.regrasPlotagem});

  bool validateColors() {
    return regrasPlotagem.every((regra) =>
        regrasPlotagem.lastWhere((r) => r.cor == regra.cor) == regra);
  }

  bool validateValues() {
    bool line1Valid = regrasPlotagem[0].inicio.getValue() <
            regrasPlotagem[0].fim.getValue() &&
        regrasPlotagem[0].fim.getValue() < regrasPlotagem[1].inicio.getValue();

    bool line2Valid = regrasPlotagem[1].inicio.getValue() <
            regrasPlotagem[1].fim.getValue() &&
        regrasPlotagem[1].fim.getValue() < regrasPlotagem[2].inicio.getValue();
    return line1Valid && line2Valid;
  }

  bool validadeAll() {
    return validateColors() && validateValues();
  }
}
