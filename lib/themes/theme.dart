import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//https://www.w3schools.com/colors/colors_picker.asp

class ThemaCovid {
  ThemeData getThema() {
    return new ThemeData(
      primarySwatch: Colors.blueAccent[800],
      primaryColor: Colors.blueAccent[600],
      backgroundColor: Colors.white,
    );
  }
}

//rgb(0, 122, 204)

class Cores {
  const Cores();

  static const Color corBotoes = const Color.fromARGB(250, 15, 145, 207); // azul

  static const Color corBarraMenu_claro = const Color.fromARGB(250, 75, 208, 254);
  static const Color corBarraMenu = const Color.fromARGB(250, 12, 164, 224);
  static const Color corBarraMenu_escuro = const Color.fromARGB(250, 15, 145, 207);

  static const Color corTextoTitulo = const Color.fromARGB(250, 89, 89, 89); // azul
  static const Color corBarraSuperior = const Color.fromARGB(250, 198, 217, 235);
  static const Color corTextoDestaque= const Color.fromARGB(250, 0, 89, 179);
}

class TextStyles {


  static const TextStyle textoClaro = const TextStyle(
      color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w600);

  static const TextStyle textoBotoes = const TextStyle(
  fontSize: 16.0,
  color: Colors.white,
  );

  static const TextStyle textoLabelForms = const TextStyle(
    fontSize: 16.0,
    color: Color.fromARGB(250, 3, 53, 118),
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  );

  static const TextStyle textoTitulo = const TextStyle(

    fontSize: 17.0,
    color: Cores.corBotoes,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  );

  static const TextStyle textoSubTitulo = const TextStyle(
    fontSize: 15.0,
    color: Cores.corTextoTitulo,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  );

  static const TextStyle textoDestaqueGrande = const TextStyle(
    fontStyle: FontStyle.normal,
    fontSize: 28.0,
    color: Cores.corTextoDestaque,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );
  static const TextStyle textoDestaqueLogo = const TextStyle(
    fontStyle: FontStyle.normal,
    letterSpacing: 3.0,
    fontSize: 44.0,
    color: Cores.corBotoes,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );


  static const TextStyle textoDestaqueLogoSub = const TextStyle(
    fontSize: 17.0,
    letterSpacing: 3.0,
    color: Cores.corTextoTitulo,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );

  static const TextStyle textoDestaqueMedio = const TextStyle(
    fontSize: 20.0,
    letterSpacing: 1.0,
    color: Cores.corTextoTitulo,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );
  static const TextStyle textoDestaquePequeno = const TextStyle(
    height: 1.1,
    fontSize: 18.0,
    color: Cores.corTextoTitulo,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );

  static const TextStyle textoNoticiaFeed = const TextStyle(
    fontSize: 14.0,
    color: Cores.corTextoTitulo,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
  );

  static const TextStyle textoDestaquePequeno2 = const TextStyle(
    fontSize: 12.0,
    color: Cores.corTextoTitulo,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  );

  static const TextStyle textoSubTiuloTop10 = const TextStyle(
    fontSize: 13.0,
    letterSpacing: 1.0,
    color: Cores.corTextoTitulo,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );

  static const TextStyle textoHintForms = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
  );

  static const TextStyle textoLegendaForms = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: Colors.black45,
    fontFamily: 'Poppins',
  );

  static const TextStyle textoLegendaFormsPreto = const TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
    fontFamily: 'Poppins',
  );

}

