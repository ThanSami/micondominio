import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'constantes.dart';
import 'package:sprintf/sprintf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ListaVisitasPage extends StatefulWidget {
  @override
  State createState() => ListaVisitasState();

}

class ListaVisitasState extends State<ListaVisitasPage> {


  List data;
  String _idUsuario = "";

  var _keyScaffold = new GlobalKey<ScaffoldState>();

  Future<String> getData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUsuario = (prefs.getString('correoUsuario') ?? '');
    });

    final response =
    await http.get( sprintf(Constantes.urlGetVisitas, [_idUsuario]));

    if (response.statusCode == 200 ) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON

      var parsedJson = json.decode(response.body);

      if (parsedJson["success"] == 1) {
        this.setState(() {
          data = parsedJson["visitante"];
        });

      } else {
        _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(parsedJson["message"], style: TextStyle( color: Colors.white),), backgroundColor: Constantes.colorPrimario));
      }
    }
    else
    {
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(
        'Failed to load post', style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white));
    }


    return "Success!";
  }


  @override
  void initState(){
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _keyScaffold,
      appBar: new AppBar(title: new Text("Lista Visitas"), backgroundColor: Constantes.colorPrimario ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return new GestureDetector(
            child: new Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start ,
                            children: <Widget>[
                              new Text('${data[index]["Nombre"]} - ${data[index]["identificacion"]}'),
                              new Text(data[index]["fechainicio"]),
                            ],
                          )
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start ,
                            children: <Widget>[
                              new Text(data[index]["placa"]),
                              new Text('Cantidad: ${data[index]["cantidad"].toString()}'),
                            ],
                          )
                      )
                    ],
                  )
              ),
              elevation: 5,
            ),
            onTap:  ()=>{

            },
          );
        },
      ),
    );
  }

}