import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;

class GraficosHome extends StatefulWidget {
  final dynamic dados;
  GraficosHome(this.dados) : super();

  @override
  GraficosHomeState createState() => GraficosHomeState(dados);
}

class GraficosHomeState extends State<GraficosHome> {
  final dynamic _dados;
  GraficosHomeState(this._dados);
  List<charts.Series> seriesList;
   List<charts.Series<DiasDaSemana, String>> _carregaDados() {

    final minhaHorasSemana = [
      DiasDaSemana("S", _dados["weektime"][0]["achieved"]),
      DiasDaSemana("T", _dados["weektime"][1]["achieved"]),
      DiasDaSemana("Q", _dados["weektime"][2]["achieved"]),
      DiasDaSemana("Q ", _dados["weektime"][3]["achieved"]),
      DiasDaSemana("S ", _dados["weektime"][4]["achieved"]),
      DiasDaSemana("S  ", _dados["weektime"][5]["achieved"]),
      DiasDaSemana("D", _dados["weektime"][6]["achieved"]),
    ];

    final minhasMetas = [
      DiasDaSemana("S", _dados["weektime"][0]["goal"]),
      DiasDaSemana("T", _dados["weektime"][1]["goal"]),
      DiasDaSemana("Q", _dados["weektime"][2]["goal"]),
      DiasDaSemana("Q ", _dados["weektime"][3]["goal"]),
      DiasDaSemana("S ", _dados["weektime"][4]["goal"]),
      DiasDaSemana("S  ",_dados["weektime"][5]["goal"]),
      DiasDaSemana("D", _dados["weektime"][6]["goal"]),
    ];

    final vizihosHorasSemana = [
      DiasDaSemana("S", _dados["weektime"][0]["neighbour"]),
      DiasDaSemana("T", _dados["weektime"][1]["neighbour"]),
      DiasDaSemana("Q", _dados["weektime"][2]["neighbour"]),
      DiasDaSemana("Q ", _dados["weektime"][3]["neighbour"]),
      DiasDaSemana("S ", _dados["weektime"][4]["neighbour"]),
      DiasDaSemana("S  ", _dados["weektime"][5]["neighbour"]),
      DiasDaSemana("D", _dados["weektime"][6]["neighbour"]),
    ];

    return [
      charts.Series<DiasDaSemana, String>(
        id: 'Horas',
        domainFn: (DiasDaSemana dias, _) => dias.dia,
        measureFn: (DiasDaSemana dias, _) => dias.horas,
        data: minhaHorasSemana,
        fillColorFn: (DiasDaSemana dias, _) {
          return charts.MaterialPalette.blue.shadeDefault;
        },
      ),

      charts.Series<DiasDaSemana, String>(
        id: 'Horas',
        domainFn: (DiasDaSemana dias, _) => dias.dia,
        measureFn: (DiasDaSemana dias, _) => dias.horas,
        data: vizihosHorasSemana,
      ),

      charts.Series<DiasDaSemana, String>(
        id: 'meta',
        domainFn: (DiasDaSemana dias, _) => dias.dia,
        measureFn: (DiasDaSemana dias, _) => dias.horas,
        data: minhasMetas,
      )..setAttribute(charts.rendererIdKey, 'customTargetLine'),
    ];
  }

  barChart() {
    return charts.BarChart(
      seriesList,
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.grouped,
        strokeWidthPx: 1.0,
      ),

        customSeriesRenderers: [
          new charts.BarTargetLineRendererConfig<String>(
            // ID used to link series to this renderer.
            overDrawOuterPx: 8,
            customRendererId: 'customTargetLine',)
        ]
    );
  }

  @override
  void initState() {
    super.initState();
    seriesList = _carregaDados();

  }

  @override
  Widget build(BuildContext context) {
    return barChart();
  }
}

class DiasDaSemana {
  final String dia;
  final int horas;

  DiasDaSemana(this.dia, this.horas);
}