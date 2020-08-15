import 'package:micondominio/POCOs/usuario.dart';
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

class CambiarContrasenaPage extends StatefulWidget{

  @override
  State createState() => CambiarContrasenaState();


}

class CambiarContrasenaState extends State<CambiarContrasenaPage> {

  final _formKey = GlobalKey<FormState>();

  var _keyScaffold = new GlobalKey<ScaffoldState>();

  TextEditingController _controladorNueva = new TextEditingController();
  TextEditingController _controladorConfirmacion = new TextEditingController();

  List<dynamic> itemsList = List();
  String _contrasenaPreferencias = "";

  Usuario _usuario = new Usuario(id: -1, casa: "", censo: 0, nombre: "", email: "", password: "");

  @override
  void initState(){
    super.initState();
    _loadUser();
  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _usuario.email = (prefs.getString('correoUsuario') ?? '');
    _contrasenaPreferencias = (prefs.getString('contrasenaActual') ?? '');
  }

  bool _mostrarIndicador = false;


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      key: _keyScaffold,
      appBar: AppBar(
        title: Text('Cambio de contraseña'),
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
                          contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
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
                    padding: const EdgeInsets.all(40.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              labelText: "Contraseña Actual"
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          maxLength: 20,
                          validator: (value) {
                            if  (value.isEmpty){
                              return 'Debe digitar la contraseña';
                            }

                            if (value != _contrasenaPreferencias)
                            {
                              return 'Contraseña no coincide con la actual';
                            }
                            return null;
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:10.0),
                        ),
                        new TextFormField(
                          controller: _controladorNueva,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              labelText: "Contraseña Nueva"
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          maxLength: 20,
                          validator: (value) {
                            if  (value.isEmpty){
                              return 'Debe digitar la contraseña nueva';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _usuario.password = value;
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:10.0),
                        ),
                        new TextFormField(
                          controller: _controladorConfirmacion,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              labelText: "Confirmación Contraseña"
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          maxLength: 20,
                          validator: (value) {
                            if  (value.isEmpty){
                              return 'Debe digitar la confirmación de contraseña';
                            }

                            if (value != _controladorNueva.text){
                              return 'Contraseña y confirmación deben ser iguales';
                            }

                            return null;
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: new MaterialButton(
                            color: Constantes.colorBoton,
                            textColor: Constantes.colorTextoBoton,
                            height: 50.0,
                            minWidth: 100.0,
                            child: new Text(
                              "Cambiar",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: ()=>{

                              if (_formKey.currentState.validate()) {
                                setState((){
                                  _mostrarIndicador = true;
                                }),
                                _formKey.currentState.save(),
                                updatePassword()
                              }
                            },
                            splashColor: Constantes.colorSplashBoton,
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        Visibility(
                          visible: _mostrarIndicador,
                          child: CircularProgressIndicator(),
                        )
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

  Future updatePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response =
    await http.get(sprintf(
        Constantes.urlCambioContrasena, [ _usuario.password, _usuario.email]));

    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);

      if (parsedJson["success"] == 1) {
        _mostrarIndicador = false;

        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Cambio contraseña"),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: new SingleChildScrollView(
                        child: new ListBody(
                          children: <Widget>[
                            new Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20.0,),
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
                              LoginPage()),
                    );
                  },
                ),
              ],
            ));
      }
      else {
        setState(() {
          _mostrarIndicador = false;
        });

        _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(
          'Failed to load post', style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white));
      }
    } else {
      _mostrarIndicador = false;
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text('Failed to load post', style: TextStyle( color: Colors.white),), backgroundColor: Constantes.colorPrimario));
    }
  }

}