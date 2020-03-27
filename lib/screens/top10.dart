import 'package:flutter/material.dart';
import 'package:xocorona/charts/graficos_home.dart';
import 'package:xocorona/charts/graficos_top10.dart';
import 'package:xocorona/controller/acesso_controller.dart';
import 'package:xocorona/themes/theme.dart' as thema;
import 'package:xocorona/controller/api_controller.dart';
import 'package:xocorona/uteis/uteis.dart';

class Top10 extends StatefulWidget {
  @override
  _Top10State createState() => _Top10State();
}

class _Top10State extends State<Top10> {
  bool graficoCarregado = false;
  dynamic dadosGraficos = null;



  Widget grafico = Container(
    height: 400,
    child: Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        strokeWidth: 2,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    carregaDadosGraficos();
  }

  Future<Null> carregaDadosGraficos() async {
    ApiControler api = new ApiControler();


    String MyNickName = await Uteis().getMyNickLocal();

    api.getfriendschart()
        .then((doc) {
          print(doc.data["weektime"]);
      if (doc.data["weektime"] != null) {
        setState(() {
          grafico = SizedBox(
            height: 400.0,
            child: GraficosTop10(doc.data["weektime"], MyNickName),
          );
        });
      } else {
        setState(() {
          grafico = SizedBox(
            height: 240.0,
            child: Center(
              child: Text("Usuário ainda sem horas contabilizadas para geração de gráfico.", style: thema.TextStyles.textoDestaqueMedio, textAlign: TextAlign.center,),
            ),
          );
        });
        print("Sem Informações no banco por enquanto");
      }



    });


  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 40, bottom: 8),
              child: Text(
                "Top 10 - Você e seus amigos!",
                style: thema.TextStyles.textoDestaqueMedio, textAlign: TextAlign.center,
              ),
            ),
            Container(
              child: Text(
                "em casa nesta semana",
                style: thema.TextStyles.textoSubTiuloTop10,
              ),
            ),
            grafico,
          ]),
    );
  }
}
