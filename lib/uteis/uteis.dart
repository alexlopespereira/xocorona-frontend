import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Uteis{
  static const String urlConvite = "http://xocorona.amazondev.com.br/convite";


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/compartilhamento.jpg');
  }

  Future<String> writeFile(Uint8List filePng) async {
    final file = await _localFile;
    await file.writeAsBytes(filePng);
    return file.path;
    // return  //writeAsString('Hello Folk');
  }

  Future<bool> userLocalLogger() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if( prefs.getBool("logged") != null){
      return prefs.getBool("logged");
    } else {
      return false;
    }
  }

  Future<String> getUidLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("uid");
  }

  Future<String> getEmailUserLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  Future<String> getMyNickLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("nickName");
  }

}

