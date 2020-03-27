import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:xocorona/uteis/uteis.dart';


class ApiControler{

   String apiKeyGoogle = "AIzaSyDgvIlx8ENYfovApKMY4PpUkELpSaB8Uxc";

   Future<dynamic> getGoogleAddress(String endereco) async{
    String _host = "https://maps.googleapis.com/maps/api/geocode/json?address="+endereco;
  //  var encoded = Uri.encodeComponent(address);
    final uri = Uri.parse('$_host&key=$apiKeyGoogle');
    Map<String, String> headers = {
      "Accept": "application/json"
    };
    print(uri);
    http.Response response = await http.get(uri, headers: headers);
    dynamic responseJson = json.decode(response.body);
    String status = responseJson["status"];
    if(status != "OK"){
      print("Ocorreu um Erro");
      return null;
    }

    var resultado = responseJson['results'][0]['geometry']['location'];
    return resultado;
  }




   Future<dynamic> getDataCharts(String email) async{
     //  var encoded = Uri.encodeComponent(address);
     final uri = Uri.parse("https://us-central1-olhosdeaguiamanchas.cloudfunctions.net/refresh_weektime?email="+email);
     Map<String, String> headers = {
       "Accept": "application/json"
     };
     http.Response response = await http.get(uri, headers: headers);
     dynamic responseJson = json.decode(response.body);
     return responseJson;
   }

   Future<DocumentSnapshot> getDataChartNeighbourchart() async{
     DocumentSnapshot dados = await  Firestore.instance.collection("neighbourchart").document(await Uteis().getEmailUserLocal()).get();
     return dados;
   }

   Future<DocumentSnapshot> getfriendschart() async{
     DocumentSnapshot dados = await  Firestore.instance.collection("friendschart").document(await Uteis().getEmailUserLocal()).get();
     return dados;
   }

}