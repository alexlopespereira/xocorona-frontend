import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xocorona/charts/graficos_home.dart';
import 'package:xocorona/controller/acesso_controller.dart';
import 'package:xocorona/themes/theme.dart' as thema;
import 'package:xocorona/uteis/uteis.dart';
import 'package:xocorona/controller/api_controller.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  GlobalKey _globalKey = new GlobalKey();
  String nome = " ";
  Uteis uteis = new Uteis();
  String patchFile = " - ";
  String urlConvite = Uteis.urlConvite;
  String suasHoras = "0";
  String horasSeusAmigos = "0";


  @override
  void initState() {
    super.initState();
    _getDadosUsuario();

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

  void _getDadosUsuario() {

    Uteis().getMyNickLocal().then((nickName){
      setState(() {
        nome = nickName;
      });

      ApiControler api = new ApiControler();
      api.getDataChartNeighbourchart()
          .then((doc) {
        if (doc.data != null) {
          setState(() {
            suasHoras = doc.data["user_totalhometime"].toString();
            if(doc.data["user_totalhometime"] != null && doc.data["total_friends_hometime"] != null){
              horasSeusAmigos = (doc.data["user_totalhometime"] + doc.data["total_friends_hometime"]).toString();
            }

            grafico = SizedBox(
              height: 240.0,
              child: GraficosHome(doc.data),
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

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 45, 10, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Parabéns, " + nome +
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
              child: Text('$suasHoras horas',
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
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
              child: Text('$horasSeusAmigos  horas',
                style: thema.TextStyles.textoDestaqueGrande,
              ),
            ),
            Container(
              child: Text(
                "em casa nesta semana",
                style: thema.TextStyles.textoDestaquePequeno2,
              ),
            ),


            Container(
              padding: EdgeInsets.only(top: 15),
              width: 250,
              child: RaisedButton(
                color: thema.Cores.corBotoes,
                child:
                Text("Convidar Amigo", style: thema.TextStyles.textoClaro),
                  onPressed: () async => await _shareImage(),
              ),
            ),
          ],
        ),
      ),
    );

  }

  Future<void> _shareImage() async {
    try {
      print("clicou");
      var userUID = UserModel.of(context).userData["uid"];
      final ByteData bytes = await rootBundle.load('assets/images/xocorona.png');
      await Share.file(
          'esys image', 'xocorona.png', bytes.buffer.asUint8List(), 'image/png', text: 'Ajude você também! Baixe o aplicativo agora mesmo: https://xocorona.page.link/?link=$urlConvite/invite?inviter=$userUID&apn=br.xocorona');
    } catch (e) {
      print('error: $e');
    }
  }



}

