import 'package:curriculo_lattes_viewer/src/models/trabalho.dart';
import 'package:curriculo_lattes_viewer/src/views/components/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoTotalProducao extends StatefulWidget {
  final List<Trabalho> trabalhos;

  const GraficoTotalProducao({super.key, required this.trabalhos});

  @override
  State<GraficoTotalProducao> createState() {
    return GraficoTotalProducaoState();
  }
}

class GraficoTotalProducaoState extends State<GraficoTotalProducao> {
  String _labelLivro = 'Livro';
  String _labelArtigo = 'Artigo';
  int _touchedIndex = -1;

  List<PieChartSectionData> showingSections() {
    const shadows = [Shadow(color: Colors.black, blurRadius: 1)];
    var porcentagemLivros =
        (widget.trabalhos.where((trabalho) => trabalho.tipo == 'LIVRO').length /
            widget.trabalhos.length);
    var porcentagemArtigos = 1 - porcentagemLivros;
    porcentagemLivros *= 100;
    porcentagemArtigos *= 100;
    var porcentagemLivrosStr = porcentagemLivros.toStringAsFixed(2);
    var porcentagemArtigosStr = porcentagemArtigos.toStringAsFixed(2);
    porcentagemLivros = double.parse(porcentagemLivrosStr);
    porcentagemArtigos = double.parse(porcentagemArtigosStr);

    setState(() {
      _labelLivro = 'LIVRO $porcentagemLivrosStr%';
      _labelArtigo = 'ARTIGO $porcentagemArtigosStr%';
    });

    PieChartSectionData secaoLivros = PieChartSectionData(
      color: Colors.blue,
      value: porcentagemLivros,
      radius: _touchedIndex == 0 ? 60.0 : 50.0,
      titleStyle: TextStyle(
        fontSize: _touchedIndex == 0 ? 25.0 : 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: shadows,
      ),
    );
    PieChartSectionData secaoArtigos = PieChartSectionData(
      color: Colors.red,
      value: porcentagemArtigos,
      radius: _touchedIndex == 1 ? 60.0 : 50.0,
      titleStyle: TextStyle(
        fontSize: _touchedIndex == 1 ? 25.0 : 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: shadows,
      ),
    );

    return [secaoLivros, secaoArtigos];
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          _touchedIndex = -1;
                          return;
                        }
                        _touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: Colors.blue,
                text: _labelLivro,
                isSquare: true,
              ),
              const SizedBox(
                height: 4,
              ),
              Indicator(
                color: Colors.red,
                text: _labelArtigo,
                isSquare: true,
              ),
              const SizedBox(
                height: 18,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }
}
