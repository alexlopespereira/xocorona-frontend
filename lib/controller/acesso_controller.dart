import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:xocorona/controller/api_controller.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xocorona/uteis/uteis.dart';

class UserModel extends Model {
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void _atualizaToken() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    String strToken;
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) {
      print("token encontrado ->" + token);
      userData["token"] = token;
      Firestore.instance
          .collection("users")
          .document(userData["email"])
          .updateData(userData);
    }).catchError((e) {
      print("Ocorreu um erro ão salvar o token");
    });
  }

  Future<String> _carregaToken() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      return token;
    }).catchError((e) {
      return "erro";
    });
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Map> getUserDataByUID(uid) async {
    Map allUserData = {};

    QuerySnapshot queryResult = await Firestore.instance
        .collection("users")
        .where('uid', isEqualTo: uid)
        .limit(1)
        .snapshots()
        .first;
    var user = queryResult.documents.first;
    if (user != null) {
      allUserData = user.data;
    }
    return allUserData;
  }

  Future<bool> haveAnInviter() async {
    await _loadCurrentUser();
    return this.userData["inviter"] != null;
  }

//  bool haveAnInviter() {
//    if (isLoggedIn()) {
//      return (this.userData["inviter"] != null);
//    }
//    else {
//      return false;
//    }
//  }

  void setInviter(inviterEmail) {
    if (isLoggedIn()) {
      print("Setting inviterEmail: $inviterEmail");
      Firestore.instance
          .collection("users")
          .document(userData["email"])
          .updateData({"inviter": inviterEmail});
    }
  }

  Future<String> getName() async {
    if (firebaseUser != null) {
      return this.userData["name"];
    } else {
      return "";
    }
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    await _removeDateLocal();
    await googleSignIn.signOut();

    print("Usuário Desconectado com Sucesso");

    notifyListeners();
  }

  Future<int> signInWithGoogle() async {
    isLoading = true;
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    firebaseUser = authResult.user;

    String nick = " ";

    if (firebaseUser.displayName.toString().contains(" ")) {
      nick = firebaseUser.displayName
          .substring(0, firebaseUser.displayName.toString().indexOf(" "));
    } else {
      nick = firebaseUser.displayName;
    }

    userData = {
      "uid": firebaseUser.uid,
      "displayName": firebaseUser.displayName,
      "email": firebaseUser.email,
      "foto": firebaseUser.photoUrl,
      "nickName": nick,
      "goal": 24,
      "telefone": firebaseUser.phoneNumber,
      "notificacao": true,
      "inviter": null,
      "token": " ",
      "endereco": null,
      "start": DateTime.now(),
    };

    DocumentSnapshot user = await Firestore.instance
        .collection("users")
        .document(userData["email"])
        .get();

    if (user.data == null) {
      await _saveUserData(userData);
    }
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(firebaseUser.uid == currentUser.uid);
    isLoading = false;

    Future.delayed(const Duration(seconds: 1));

    if (user.data == null || user["endereco"] == null || user["endereco"] == "") {
      return 5;
    } else {
      return 1;
    }
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      if (userData["email"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.email)
            .get();
        userData = docUser.data;
        notifyListeners();
        _saveUserDateLocal(userData);
        if (userData["token"] == " " || userData["token"] == null) {
          _atualizaToken();
        }
      }
    }
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    await Firestore.instance
        .collection("users")
        .document(userData["email"])
        .setData(userData);
    await _saveUserDateLocal(userData);
    print("usuário salvo com sucesso");
  }

  Future<Null> updateUser(
      {@required Map<String, dynamic> dados,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail,
      @required bool mudouEndereco,
      @required BuildContext context}) async {
    ApiControler api = new ApiControler();
    Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint geoFirePoint;
    var resultado;
    if (mudouEndereco) {
      resultado = await api.getGoogleAddress(dados["endereco"]);
      geoFirePoint =
          geo.point(latitude: resultado["lat"], longitude: resultado["lng"]);
      dados["geohome"] = geoFirePoint.data["geopoint"];
    } else {
      resultado = userData["geohome"];
    }

    if (resultado != null) {
      dados["token"] = await _carregaToken();
      Firestore.instance
          .collection("users")
          .document(dados["email"])
          .updateData(dados)
          .then((onValue) {
        print("informações salvar com sucesso");
        userData = dados;
        notifyListeners();
        return onSuccess();
      }).catchError((erro) {
        print("Ocorreu um Erro ao tentar salvar ->" + erro.toString());
        return onFail();
      });
    } else {
      print("Erro no Endereço..");
      return onFail();
    }
  }

  Future<Null> updateGoal(
      {@required int goalUser,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail,
      @required bool mudouEndereco,
      @required BuildContext context}) async {
    var dados = await geDatatUser();

    dados["goal"] = goalUser;

    Firestore.instance
        .collection("users")
        .document(dados["email"])
        .updateData(dados)
        .then((onValue) {
      print("Informações salvar com sucesso");
      userData = dados;
      notifyListeners();
      return onSuccess();
    }).catchError((erro) {
      print("Ocorreu um Erro ao tentar salvar ->" + erro.toString());
      return onFail();
    });
  }

  _saveUserDateLocal(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", userData["email"]);
    prefs.setString("uid", userData["uid"]);
    prefs.setString("foto", userData["foto"]);
    prefs.setString("nickName", userData["nickName"]);
    prefs.setString("nameDisplay", userData["nameDisplay"]);
    prefs.setString("start", userData["start"].toString());
    // prefs.setString("inviter", userData["inviter"]);
    // prefs.setString("geohome", userData["geohome"].toString());
    prefs.setBool("logged", true);
  }

  Future<Null> _removeDateLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("logged", false);
    print("logged setado falso");
  }

  Future<Map> getUserLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userData = Map();
    return userData = {
      "uid": prefs.getString("uid"),
      "displayName": prefs.getString("displayName"),
      "email": prefs.getString("email"),
      "foto": prefs.getString("foto"),
      "nickName": prefs.getString("nickName"),
      "inviter": prefs.getString("inviter"),
      "start": prefs.getString("start"),
      "geohome": prefs.getString("geohome"),
      "logged": prefs.getBool("logged"),
    };
  }

  Future<Map> geDatatUser() async {
    DocumentSnapshot user = await Firestore.instance
        .collection("users")
        .document(await Uteis().getEmailUserLocal())
        .get();
    return user.data;
  }
}
