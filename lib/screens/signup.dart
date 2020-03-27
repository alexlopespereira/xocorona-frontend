import 'package:flutter/material.dart';
import 'package:xocorona/main.dart';
import 'package:xocorona/screens/home_screen.dart';
import 'package:xocorona/controller/acesso_controller.dart';
import 'package:xocorona/screens/home_out.dart';
import 'package:xocorona/screens/profile.dart';
import 'package:xocorona/themes/theme.dart' as thema;
import 'package:xocorona/uteis/uteis.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  Uteis uteis = new Uteis();
  bool logged = null;


  @override
  void initState() {
    super.initState();
    uteis.userLocalLogger().then((onValue) {
      print("print loggerd");
      setState(() {
        logged = onValue;
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
           child: Container(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Container(
                   padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                   child: Image.asset(
                     "assets/icons/main_icon.png",
                     width: MediaQuery.of(context).size.width * 0.6,
                     fit: BoxFit.cover,
                   ),
                 ),

                 Container(
                   height: 30,
                 ),

                 Container(
                   child: Text(
                     "Vencendo juntos  \n  com isolamento social",
                     textAlign: TextAlign.center,
                     style: thema.TextStyles.textoDestaqueLogoSub,
                   ),
                   width: MediaQuery.of(context).size.width * 0.9,
                 ),

                 Container(
                   height: 50,
                 ),

                 Container(
                   child: FlatButton(
                     onPressed: () {
                       UserModel().signInWithGoogle().then((retorno) {
                         Navigator.of(context).push(
                           MaterialPageRoute(builder: (context) => HomeScreen(retorno)),
                         );
                       });
                     },
                     child: Image.asset(
                       "assets/icons/google.png",
                       width: MediaQuery.of(context).size.width * 0.7,
                     ),
                   ),
                 ),
              /*   Container(
                   child: Text("texto do logged: " + logged.toString()),
                   height: 15.0,
                 ),

                 Container(
                   child: Image.asset(
                     "assets/icons/facebook.png",
                     width: MediaQuery.of(context).size.width * 0.7,
                     fit: BoxFit.cover,
                   ),
                 ),
                 */

               ],
             ),
           )
          ),

    );
  }


}
