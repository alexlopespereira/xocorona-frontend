import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xocorona/screens/signup.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<SplashScreen> {
  bool logado;

  @override
  void initState() {
    CarregaLocal();
    super.initState();
  }

  startTime() async {
    var duration = new Duration(milliseconds: 1500);
    return new Timer(duration, route);
  }

  void CarregaLocal() async {
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initScreen(context),
    );
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  initScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(
                "assets/icons/main_icon.png",
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 2,
            )
          ],
        ),
      ),
    );
  }
}
