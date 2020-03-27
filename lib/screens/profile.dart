import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:xocorona/controller/acesso_controller.dart';
import 'package:xocorona/controller/api_controller.dart';
import 'package:xocorona/screens/signup.dart';
import 'package:xocorona/themes/theme.dart' as thema;

class ProfileUser extends StatefulWidget {
  @override
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  int _radioSexo1 = 0;
  int _radioSexo2 = 0;
  bool _userEdited = false;
  bool _mudouEndereco = false;
  bool _loading;
  final _nameFocus = FocusNode();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _idadeController = TextEditingController();
  final _enderecoDigitadoController = TextEditingController();
  String urlFoto = null;
  bool receberNotificacao = true;

  @override
  void initState() {
    super.initState();
    _getDadosUsuario();
  }

  void _getDadosUsuario() {
    UserModel().geDatatUser().then((userDoc) {
      setState(() {
        _nomeController.text = userDoc["displayName"];
        _emailController.text = userDoc["email"];
        _idadeController.text = userDoc["idade"];
        _enderecoDigitadoController.text = userDoc["endereco"];
        urlFoto = userDoc["foto"];
        receberNotificacao = userDoc["notificacao"];
        if (userDoc["sexo"] != null) {
          _alterasexo(userDoc["sexo"]);
        }
      });
    });
  }

  void _alterasexo(String sexo) {
    setState(() {
      if (sexo == "M") {
        setState(() {
          _radioSexo1 = 1;
          _radioSexo2 = 0;
        });
      } else {
        setState(() {
          _radioSexo1 = 0;
          _radioSexo2 = 1;
        });
      }
    });
  }

  String sexoSelecionado() {
    if (_radioSexo1 == 1) return "M";
    if (_radioSexo2 == 1) return "F";
  }

  void switchChanged(bool value) {
    setState(() {
      if (receberNotificacao == null) {
        receberNotificacao == true;
      } else {
        receberNotificacao = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLoading)
          return Center(
            child: CircularProgressIndicator(),
          );

        return SingleChildScrollView(
          padding:
              EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Informações Pessoais",
                      style: thema.TextStyles.textoTitulo,
                      textAlign: TextAlign.left,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        size: 35.0,
                        color: Colors.blue,
                      ),
                      tooltip: "Menu",
                      onPressed: () {
                        UserModel.of(context).signOut();
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                    )
                  ],
                ),
              ),
              (urlFoto != null)
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(
                        urlFoto,
                      ),
                      radius: 50,
                      backgroundColor: Colors.transparent,
                    )
                  : Container(),
              TextField(
                focusNode: _nameFocus,
                controller: _nomeController,
                decoration: InputDecoration(
                    labelText: "Nome",
                    hintText: "Informe seu nome",
                    icon: Icon(
                      Icons.person,
                      color: Colors.lightBlueAccent,
                    ),
                    labelStyle:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    hintStyle:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800)),
                onChanged: (text) {
                  _userEdited = true;
                },
              ),
              TextField(
                controller: _idadeController,
                decoration: InputDecoration(
                    labelText: "Idade",
                    hintText: "Informe Sua Idade",
                    icon: Icon(
                      Icons.person,
                      color: Colors.lightBlueAccent,
                    ),
                    labelStyle:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    hintStyle:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800)),
                onChanged: (text) {
                  _userEdited = true;
                },
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                height: 30,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  "Sexo",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                        'Masculino',
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Radio(
                        value: 1,
                        groupValue: _radioSexo1,
                        onChanged: (value) {
                          _alterasexo("M");
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
                        'Feminino',
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Radio(
                        value: 1,
                        groupValue: _radioSexo2,
                        onChanged: (value) {
                          _alterasexo("F");
                        },
                      ),
                    ]),
              ),
              Container(
                height: 20,
              ),
              TextField(
                controller: _enderecoDigitadoController,
                decoration: InputDecoration(
                    labelText: "Endereço",
                    hintText: "Entre com Seu Endereço",
                    icon: Icon(
                      Icons.person,
                      color: Colors.lightBlueAccent,
                    ),
                    labelStyle:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    hintStyle:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800)),
                onChanged: (text) {
                  _mudouEndereco = true;
                  _userEdited = true;
                },
              ),
              Divider(),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                height: 30,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  "Notificações",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                height: 30,
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Deseja receber notificações"),
                    Switch(
                      value: receberNotificacao,
                      onChanged: (bool newValue) {
                        setState(() {
                          receberNotificacao = newValue;
                        });
                      },
                    ),
                  ],
                ),
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
                  onPressed: () {
                    Map<String, dynamic> userDate =
                        UserModel.of(context).userData;
                    userDate["nickName"] = _nomeController.text;
                    userDate["idade"] = _idadeController.text;
                    userDate["endereco"] = _enderecoDigitadoController.text.toUpperCase();
                    userDate["sexo"] = sexoSelecionado();
                    userDate["notificacao"] = receberNotificacao;
                    UserModel.of(context).updateUser(
                        dados: userDate,
                        onSuccess: _onSuccess,
                        onFail: _onFail,
                        mudouEndereco: _mudouEndereco,
                        context: context);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void saveUsuario() {}

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

  Future<bool> _resquetPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
