import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xocorona/controller/acesso_controller.dart';
import 'package:xocorona/themes/theme.dart' as thema;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:xocorona/uteis/uteis.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';


class Challenge extends StatefulWidget {
  @override
  _ChallengeState createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {

  String _platformVersion = 'Unknown';
  String strUID = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _desafioEditado = true;
  double _horasMeta = 24;
  bool notificacoes = true;
  String urlConvite = Uteis.urlConvite;


  @override
  void initState() {
    super.initState();
    _getDadosUsuario();
  }



  void _getDadosUsuario() {
    UserModel().geDatatUser().then((userDoc) {
      setState(() {
        strUID = userDoc["uid"];
        _horasMeta = double.parse(userDoc["goal"].toString());
      });
    });
  }



  slideChanged(double value) {
    setState(() {
      _horasMeta = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Determine sua meta",
                      style: thema.TextStyles.textoTitulo,
                      textAlign: TextAlign.left,
                    ),

                  ],
                ),
              ),
              Divider(),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  "Meta diária",
                  textAlign: TextAlign.left,
                  style: thema.TextStyles.textoSubTitulo,
                ),
              ),
              Container(
                height: 30,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(0),
                      child: Text("0", style: thema.TextStyles.textoSubTitulo,),
                      width: 15,
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width * 0.9) - 50,
                      padding: EdgeInsets.all(0),
                       child: SliderTheme(
                         data: SliderTheme.of(context).copyWith(
                           activeTrackColor: Colors.blueAccent[800],
                           inactiveTrackColor: Colors.blue[100],
                           trackShape: RoundedRectSliderTrackShape(),
                           trackHeight: 8.0,
                           thumbColor: thema.Cores.corBarraMenu,
                           thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                           overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                         ),
                         child: Slider(value: _horasMeta,
                         onChanged:(x) { slideChanged(x); },
                         min: 0.0,
                         max: 24.0,
                         divisions: 24,
                         label: _horasMeta.toString(),
                       ), ),
                    ),

                    Container(
                      padding: EdgeInsets.all(0),
                      child: Text("24", style: thema.TextStyles.textoSubTitulo,),
                      width: 20,
                    ),
                  ],
                ),
              ),
              Container(
                height: 35,
                padding: EdgeInsets.only(top: 5),
                child: Text("Meta selecionada:  " + _horasMeta.toStringAsFixed(0)  + " Horas", style: thema.TextStyles.textoDestaquePequeno2, textAlign: TextAlign.center,),
              ),

              Divider(),


              Container(
                padding: EdgeInsets.only(top: 20),
                width: 280,
                child: RaisedButton(
                  color: thema.Cores.corBotoes,
                  child: Text(
                    "Salvar Meta",
                    style: thema.TextStyles.textoBotoes,
                  ),
                  onPressed: () {
                    UserModel.of(context).updateGoal(
                        goalUser: int.parse(_horasMeta.toStringAsFixed(0)),
                        onSuccess: _onSuccess,
                        onFail: _onFail,
                        context: context);
                  },
                ),
              ),
              Container(
                height: 70.0,
              ),

              Container(
                padding: EdgeInsets.only(top: 15),
                width: 250,
                height: 60,
                child: RaisedButton(
                  color: thema.Cores.corBotoes,
                  child:
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     Icon(Icons.share, color: Colors.white, size: 30,),
                     Text("Compartilhar com Amigo", style: thema.TextStyles.textoClaro),
                   ],
                 ),
                  onPressed: () async => await _shareImage(),
                ),
              ),

              /*
              Container(
                child: FlatButton(
                  onPressed: () async => await _shareImageSemTexto(),
                  child: Image.asset(
                    "assets/icons/share_instagram.png",
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
              ),
              Container(
                height: 10.0,
              ),
              Container(
                child: FlatButton(
                  onPressed: () async => await _shareImage(),
                  child: Image.asset(
                    "assets/icons/share_facebook.png",
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
              ),
              Container(
                height: 15.0,
              ),

              Container(
                child: FlatButton(
                  onPressed: () async => await _shareImage(),
                  child: Image.asset(
                    "assets/icons/share_whatsapp.png",
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
              ),
              Container(
                height: 15.0,
              ),

*/
/*
    - assets/icons/share_instagram.png
    - assets/icons/share_facebook.png
    - assets/icons/share_whatsapp.png
 */

            ],
          ),
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

  Future<void> _shareImageSemTexto() async {
    try {
      print("clicou");
      var userUID = UserModel.of(context).userData["uid"];
      final ByteData bytes = await rootBundle.load('assets/images/xocorona.jpg');
      await Share.file(
          'esys image', 'xocorona.jpg', bytes.buffer.asUint8List(), 'image/jpg');
    } catch (e) {
      print('error: $e');
    }
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Ocorreu um ão salvar informações"),
      duration: Duration(seconds: 3),
    ));
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Informações Salvar com Sucesso"),
      duration: Duration(seconds: 1),
    ));
  }
}
