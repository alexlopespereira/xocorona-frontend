import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xocorona/charts/graficos_home.dart';
import 'package:xocorona/controller/acesso_controller.dart';
import 'package:xocorona/themes/theme.dart' as thema;
import 'package:xocorona/uteis/uteis.dart';
import 'package:xocorona/controller/api_controller.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
//import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  GlobalKey _globalKey = new GlobalKey();

  bool graficoCarregado = false;
  dynamic dadosGraficos = null;
  ApiControler api = new ApiControler();
  GlobalKey globalKey = GlobalKey();
  Uteis uteis = new Uteis();

  String patchFile = " - ";

  Future<Uint8List> _capturePng() async {
    return new Future.delayed(const Duration(milliseconds: 20), () async {
      RenderRepaintBoundary boundary =
      _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return (pngBytes);
    });
  }



  Widget grafico = Container(
    height: 240,
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
        api.getDataChartNeighbourchart()
        .then((doc) {
      if (doc.data != null) {
        setState(() {
          grafico = SizedBox(
            height: 240.0,
            child: GraficosHome(doc.data),
          );
          graficoCarregado = true;
        });
      } else {
        setState(() {
          grafico = SizedBox(
            height: 240.0,
            child: Center(
              child: Text("Usuário ainda sem horas contabilizadas para geração de gráfico.", style: thema.TextStyles.textoDestaqueMedio, textAlign: TextAlign.center,),
            ),
          );
          graficoCarregado = true;
        });

        print("Sem Informações no banco por enquanto");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(10, 45, 10, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Parabéns, " +
                  UserModel.of(context).userData["nickName"] +
                  "!!!",
              style: thema.TextStyles.textoDestaqueGrande,
            ),
          ),
          Container(
            child: Text(
              "Você já ficou",
              style: thema.TextStyles.textoDestaquePequeno,
            ),
          ),
          Container(
            child: Text(
              "146 horas",
              style: thema.TextStyles.textoDestaqueGrande,
            ),
          ),
          Container(
            child: Text(
              "em casa nesta semana",
              style: thema.TextStyles.textoDestaquePequeno2,
            ),
          ),
          grafico,
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Image.asset(
              "assets/icons/legenda_grafico_vizinhanca.png",
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Você e seus amigos já ficaram",
              style: thema.TextStyles.textoDestaquePequeno,
            ),
          ),
          Container(
            child: Text(
              "1645 horas",
              style: thema.TextStyles.textoDestaqueGrande,
            ),
          ),
          Container(
            child: Text(
              "em casa nesta semana",
              style: thema.TextStyles.textoDestaquePequeno2,
            ),
          ),

            FlatButton(
              color: Colors.white,
              child: Text(
                'Gerar Imagem',
                textDirection: TextDirection.ltr,
              ),
              onPressed: () async {
                uteis.writeFile(await _capturePng()).then((onValue) {
                  setState(() {
                    patchFile = onValue;
                  });
                });
              },
            ),

            Container(
              child: Text(patchFile),
            ),

            Container(
              child: Image.file(
                File(patchFile),
                width: 400,
              ),
            ),


          Container(
            child: FlatButton(
              onPressed: ()  async {
                /*   var userUID = UserModel.of(context).userData["uid"];
                    Share.share('Ajude você também! Baixe o aplicativo agora mesmo: https://xocorona.page.link/?link=https://xocorona.com.br/invite?inviter=$userUID&apn=br.xocorona');

                  */



              },
              child: Image.asset(
                "assets/icons/share_instagram.png",
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
          ),


          Container(
            padding: EdgeInsets.only(top: 15),
            width: 250,
            child: RaisedButton(
              color: thema.Cores.corBotoes,
              child:
              Text("Convidar Amigo", style: thema.TextStyles.textoClaro),
              onPressed: () {
              //  var userUID = "456465456";//UserModel.of(context).userData["uid"];
             //   Share.share('Ajude você também! Baixe o aplicativo agora mesmo: https://xocorona.page.link/?link=https://xocorona.com.br/invite?inviter=$userUID&apn=br.xocorona');
              },
            ),
          ),
        ],
      ),

    );
  }
}
