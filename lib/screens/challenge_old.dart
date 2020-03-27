/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xocorona/themes/theme.dart' as thema;

class Challenge extends StatefulWidget {
  @override
  _ChallengeState createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _desafioEditado = true;

  final _nameFocus = FocusNode();
  final _nomeController = TextEditingController();
  final _defasioController = TextEditingController();

  int _radio3Dias = 1;
  int _radio7Dias = 0;

  void _alteraPeriodo(int value, int dias) {
    setState(() {
      if (dias == 3) {
        setState(() {
          _radio3Dias = 1;
          _radio7Dias = 0;
        });
      } else {
        setState(() {
          _radio3Dias = 0;
          _radio7Dias = 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Ajuste Sua Meta",
                      style: thema.TextStyles.textoTituloPaginas,
                      textAlign: TextAlign.left,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        size: 35.0,
                        color: Colors.redAccent[400],
                      ),
                      tooltip: "Menu",
                      onPressed: () {
                        print("mostrar alerta pra confirmar a exclusão.");
                      },
                    )
                  ],
                ),
              ),
              TextField(
                focusNode: _nameFocus,
                controller: _nomeController,
                decoration: InputDecoration(
                    labelText: "Amigo Monitor",
                    hintText: "exemplo: @Clarice",
                    icon: Icon(
                      Icons.person,
                      color: Colors.lightBlueAccent,
                    ),
                    labelStyle: thema.TextStyles.textoLabelForms,
                    hintStyle: thema.TextStyles.textoHintForms),
                onChanged: (text) {
                  _desafioEditado = true;
                },
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "É o amigo com quem você vai se comprometer",
                  style: thema.TextStyles.textoLegendaForms,
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Período",
                  style: thema.TextStyles.textoLabelForms,
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 30,
                padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '3 Dias',
                        style: thema.TextStyles.textoLegendaFormsPreto,
                      ),
                      Radio(
                        value: 1,
                        groupValue: _radio3Dias,
                        onChanged: (value) {
                          _alteraPeriodo(value, 3);
                        },
                      ),
                    ]),
              ),
              Container(
                height: 30,
                padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '7 Dias',
                        style: thema.TextStyles.textoLegendaFormsPreto,
                      ),
                      Radio(
                        value: 1,
                        groupValue: _radio7Dias,
                        onChanged: (value) {
                          _alteraPeriodo(value, 7);
                        },
                      ),
                    ]),
              ),
              Divider(
                height: 20,
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Auto Punição",
                        style: thema.TextStyles.textoLabelForms,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "Ex.: pagar uma R\$ 5,00 ao \n seu amigo.",
                        style: thema.TextStyles.textoLegendaFormsPreto,
                        textAlign: TextAlign.left,
                      ),
                    ]),
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                controller: _defasioController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                  helperText:
                      "É o que o seu amigo vai te cobrar se você não atingir \n sua propria meta.",
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.black12)),
                ),
                validator: (text) {
                  if (text.isEmpty) return "Comentário Inválido!";
                },
              ),
              Divider(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  "Início",
                  style: thema.TextStyles.textoLabelForms,
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 30,
                padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Dia',
                        style: thema.TextStyles.textoLegendaFormsPreto,
                      ),
                      Text(
                        'Hoje',
                        style: thema.TextStyles.textoLegendaFormsPreto,
                      ),
                    ]),
              ),
              Container(
                height: 30,
                padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Hora',
                        style: thema.TextStyles.textoLegendaFormsPreto,
                      ),
                      Text(
                        '22:00',
                        style: thema.TextStyles.textoLegendaFormsPreto,
                      ),
                    ]),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                width: 250,
                child: RaisedButton(
                  color: thema.Cores.corBotoes,
                  child: Text(
                    "Salvar",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/