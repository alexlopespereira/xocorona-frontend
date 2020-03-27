import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;

class GraficosTop10 extends StatefulWidget {
  final dynamic dados;
  final String myNickName;
  GraficosTop10(this.dados, this.myNickName) : super();

  @override
  GraficosTop10State createState() => GraficosTop10State(dados, myNickName);
}

class GraficosTop10State extends State<GraficosTop10> {
  final dynamic _dados;
  final String _myNickName;

  List<int> list2 = [5, 6, 7, 8, 9];
  GraficosTop10State(this._dados, this._myNickName);
  List<charts.Series> seriesList;


   List<charts.Series<DiasDaSemana, String>> _carregaDados() {

     final data = List<DiasDaSemana>();

     if(_dados.length > 0) {
       for(int i = 0; i < 10; i++){
         if(_dados[i]!= null) {
           if(_dados[i]["nickName"] == _myNickName)
           _dados[i]["nickName"] = "VOCÊ";
           data.add(new DiasDaSemana(
           _dados[i]["nickName"], _dados[i]["user_hometime"]));
         }
       }
     }




     return [
     new charts.Series<DiasDaSemana, String>(
       id: 'dias',
       colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
       domainFn: (DiasDaSemana semana, _) => semana.amigo,
       measureFn: (DiasDaSemana semana, _) => semana.horas,
       data: data,
       labelAccessorFn: (DiasDaSemana semana, _) =>
       '${semana.horas}',
       insideLabelStyleAccessorFn: (DiasDaSemana sales, _) {
         final color = (sales.amigo == 'VOCÊ')
             ? charts.MaterialPalette.white
             : charts.MaterialPalette.red.shadeDefault;
         return new charts.TextStyleSpec(color: color);
       },

       fillColorFn: (DiasDaSemana sales, _) {
         final color = (sales.amigo == 'VOCÊ')
             ? charts.MaterialPalette.yellow.shadeDefault
             : charts.MaterialPalette.blue.shadeDefault;
         return color;
       },

       outsideLabelStyleAccessorFn: (DiasDaSemana semana, _) {
         final color = (semana.amigo == 'VOCÊ')
             ? charts.MaterialPalette.purple.shadeDefault
             : charts.MaterialPalette.white;
         return new charts.TextStyleSpec(color: color);
       },
     ),
     ];
  }

  barChart() {
    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: false,

      barRendererDecorator: new charts.BarLabelDecorator<String>(labelPosition: charts.BarLabelPosition.outside, labelPadding: -25),
      // Hide domain axis.

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
  final String amigo;
  final int horas;

  DiasDaSemana(this.amigo, this.horas);
}