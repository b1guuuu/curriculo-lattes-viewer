import 'package:curriculo_lattes_viewer/src/models/trabalho.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoProducaoAno extends StatefulWidget {
  final List<Trabalho> trabalhos;

  const GraficoProducaoAno({super.key, required this.trabalhos});

  @override
  State<GraficoProducaoAno> createState() {
    return GraficoProducaoAnoState();
  }
}

class GraficoProducaoAnoState extends State<GraficoProducaoAno> {
  late int showingTooltip;
  @override
  void initState() {
    showingTooltip = -1;
    super.initState();
  }

  List<BarChartGroupData> _generateData() {
    List<BarChartGroupData> data = [];
    var trabalhosOrdenadosPorAno = [...widget.trabalhos];
    trabalhosOrdenadosPorAno.sort((a, b) => a.ano.compareTo(b.ano));
    int contadorTrabalhos = 0;
    int ultimoAno = -1;

    for (var trabalho in trabalhosOrdenadosPorAno) {
      if (trabalho.ano != ultimoAno) {
        if (ultimoAno == -1) {
          ultimoAno = trabalho.ano;
        } else {
          data.add(BarChartGroupData(
              x: ultimoAno,
              showingTooltipIndicators: showingTooltip == ultimoAno ? [0] : [],
              barRods: [BarChartRodData(toY: contadorTrabalhos.toDouble())]));
          contadorTrabalhos = 0;
          ultimoAno = trabalho.ano;
        }
      }
      contadorTrabalhos++;
    }
    data.add(BarChartGroupData(
        x: ultimoAno,
        showingTooltipIndicators: showingTooltip == ultimoAno ? [0] : [],
        barRods: [BarChartRodData(toY: contadorTrabalhos.toDouble())]));

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AspectRatio(
            aspectRatio: 4,
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(value.toString()),
                    ))),
                barGroups: _generateData(),
                barTouchData: BarTouchData(
                    enabled: true,
                    handleBuiltInTouches: false,
                    touchCallback: (event, response) {
                      if (response != null &&
                          response.spot != null &&
                          event is FlTapUpEvent) {
                        setState(() {
                          final x = response.spot!.touchedBarGroup.x;
                          final isShowing = showingTooltip == x;
                          if (isShowing) {
                            showingTooltip = -1;
                          } else {
                            showingTooltip = x;
                          }
                        });
                      }
                    },
                    mouseCursorResolver: (event, response) {
                      return response == null || response.spot == null
                          ? MouseCursor.defer
                          : SystemMouseCursors.click;
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
