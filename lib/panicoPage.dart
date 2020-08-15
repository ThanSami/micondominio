import 'package:micondominio/loginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sprintf/sprintf.dart';
import 'constantes.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:convert';
import 'principalPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PanicoPage extends StatefulWidget{

  @override
  State createState() => PanicoState();


}

class PanicoState extends State<PanicoPage> {

  final _formKey = GlobalKey<FormState>();

  var _keyScaffold = new GlobalKey<ScaffoldState>();

  TextEditingController _controladorMensaje = new TextEditingController();

  List<dynamic> itemsList = List();
  String _idUsuario = "";
  String _Mensaje = "";

  @override
  void initState(){
    super.initState();
    _loadUser();
  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _idUsuario = (prefs.getString('idUsuario') ?? '');
  }

  bool _mostrarIndicador = false;


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      key: _keyScaffold,
      appBar: AppBar(
        title: Text('Pánico'),
        backgroundColor: Constantes.colorPrimario,
      ),
      backgroundColor: Colors.white,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Form(
                key: _formKey,
                child: new Theme(
                  data: new ThemeData(
                      brightness: Brightness.light,
                      primarySwatch: Constantes.colorSecundario,
                      inputDecorationTheme: new InputDecorationTheme(
                          labelStyle: new TextStyle(
                            color: Constantes.colorEtiquetaInput,
                            fontSize: 20.0,
                          ),
                          filled: true,
                          fillColor: Colors.black12,
                          contentPadding: const EdgeInsets.only(left: 5.0, bottom: 5.0, top: 1.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Constantes.colorBorderInputLogin),
                            borderRadius: BorderRadius.circular(15.7),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Constantes.colorBorderInputLogin),
                            borderRadius: BorderRadius.circular(15.7),
                          )
                      )
                  ),
                  child: new Container(
                    padding: const EdgeInsets.only(left:5.0, top:3.0, right: 5.0, bottom: 3.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40.0,
                          ),
                          decoration: new InputDecoration(
                              labelText: "Mensaje de pánico"
                          ),
                          keyboardType: TextInputType.text,
                          initialValue: "Necesito Ayuda urgente en mi casa",
                          maxLines: 8,
                          maxLength: 20,
                          validator: (value) {
                            if  (value.isEmpty){
                              return 'Debe el mensaje';
                            }

                            return null;
                          },
                          onSaved: (String value) {
                            _Mensaje = value;
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:5.0),
                        ),
                        Visibility(
                          visible: _mostrarIndicador,
                          child: CircularProgressIndicator(),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            child: new MaterialButton(
                              color: Colors.red,
                              textColor: Constantes.colorTextoBoton,
                              height: 50.0,
                              minWidth: 100.0,
                              child: new Text(
                                "Reportar",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: ()=>{

                                if (_formKey.currentState.validate()) {
                                  setState((){
                                    _mostrarIndicador = true;
                                  }),
                                  _formKey.currentState.save(),
                                  _enviarMensaje()
                                }
                              },
                              splashColor: Constantes.colorSplashBoton,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );

  }

  Future _enviarMensaje() async {

    final response =
    await http.get(sprintf(Constantes.urlPanico, [_idUsuario , _Mensaje]));

    if (response.statusCode == 200 ) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON

      var parsedJson = json.decode(response.body);

      setState(() {
        _mostrarIndicador = false;
      });

      if (parsedJson["success"] == 1) {
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Mensaje Pánico"),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: new SingleChildScrollView(
                        child: new ListBody(
                          children: <Widget>[
                            new Icon(Icons.check_circle,
                                color: Colors.green),
                            new Text(parsedJson["message"]),
                          ],
                        ),
                      ),
                    ),
                  ]
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('OK'),
                  onPressed: () {

                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Principal()),
                      );

                  },
                ),
              ],
            ));
      }
      else {
        _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(
          parsedJson["message"], style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white));
      }
    }
      else {
      setState(() {
        _mostrarIndicador = false;
      });

      //_keyScaffold.currentState.showSnackBar(SnackBar(content: Text(parsedJson["Mensaje"], style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(
        'Failed to load post', style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white));
    }

  }


}