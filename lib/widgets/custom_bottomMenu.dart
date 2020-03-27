import 'package:flutter/material.dart';
import 'package:xocorona/controller/acesso_controller.dart';
import 'package:xocorona/screens/challenge.dart';
import 'package:xocorona/screens/home_out.dart';
import 'package:xocorona/screens/home_screen.dart';
import 'package:xocorona/screens/profile.dart';
import 'package:xocorona/screens/signup.dart';
import 'package:xocorona/themes/theme.dart' as thema;

class CustomBottomMenu extends StatefulWidget {
  @override
  _CustomBottomMenuState createState() => _CustomBottomMenuState();
}

class _CustomBottomMenuState extends State<CustomBottomMenu> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 10,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              thema.Cores.corBarraMenu,
              thema.Cores.corBarraMenu_escuro,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScreen(1)));
              },
              icon: Image.asset(
                "assets/icons/home.png",
                width: 30,
                fit: BoxFit.cover,
              ),
            ),

            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>HomeScreen(2)));
              },
              icon: Image.asset(
                "assets/icons/feed.png",
                width: 30,
                fit: BoxFit.cover,
              ),
            ),
            IconButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>HomeScreen(3)));
            },
              icon: Image.asset(
                "assets/icons/trofeu.png",
                width: 30,
                fit: BoxFit.cover,
              ),),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScreen(4)));
              },
              icon: Image.asset(
                "assets/icons/friends.png",
                width: 30,
                fit: BoxFit.cover,
              ),
            ),
            IconButton(
                onPressed: () {

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomeScreen(5)));

                   /*
                  UserModel.of(context).signOut();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUp())); */
                },
                icon:Image.asset(
                  "assets/icons/me.png",
                  width: 30,
                  fit: BoxFit.cover,
                ),),


          ],
        ),
      ),
    );
  }
}
