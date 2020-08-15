import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:micondominio/POCOs/usuario.dart';
import 'package:micondominio/cambiarContrasenaPage.dart';
import 'package:micondominio/censoPage.dart';
import 'package:micondominio/registroPage.dart';
import 'package:sprintf/sprintf.dart';
import 'constantes.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:convert';
import 'principalPage.dart';
//import 'recuperar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{

  @override
  State createState() => LoginPageState();


}

class LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{

  AnimationController _iconAnimationControler;
  Animation<double> _iconAnimation;
  final _formKey = GlobalKey<FormState>();

  var _keyScaffold = new GlobalKey<ScaffoldState>();

  String _idUsuario = "";
  String _nombreUsuario = "";

  var _testValue = "";
  bool _add = true;
  List<dynamic> itemsList = List();
  TextEditingController _usuario = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  void initState(){
    super.initState();
    _iconAnimationControler = new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 500)
    );
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationControler,
        curve: Curves.bounceOut
    );
    _iconAnimation.addListener(()=> this.setState(() { }));
    _iconAnimationControler.forward();

    _loadUser();
    /*if (_loadUser())
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Principal()),
      );*/

  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUsuario = (prefs.getString('idUsuario') ?? '');
      _usuario.text = (prefs.getString('correoUsuario') ?? '');
      _nombreUsuario = (prefs.getString('nombreUsuario') ?? '');
    });

    //return (_idUsuario=="");
  }

  int _mostrarIndicador = 0;

  Widget ShowWaitIndicator()
  {
    switch (_mostrarIndicador)
    {
      case 0:
        return Text("");
        break;
      case 1:
        return CircularProgressIndicator();
        break;
      case 2:
        return AnimatedIcon(icon: AnimatedIcons.menu_home, progress: _iconAnimationControler, color: Colors.indigo, size: 50 );
        break;
    }

  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      key: _keyScaffold,
      backgroundColor: Colors.black,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image(
                image: new AssetImage("images/logo.png"),
                width: _iconAnimation.value * 500,
                height: 150.0,
              ),
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
                          contentPadding: const EdgeInsets.only(left: 14.0, bottom: 4.0, top: 8.0),
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
                    padding: const EdgeInsets.all(30.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            controller: _usuario,
                            decoration: new InputDecoration(
                                labelText: "Usuario"
                            ),
                            keyboardType: TextInputType.text,
                            maxLength: 100,
                            validator: (value) {
                              if  (value.isEmpty){
                                return 'Debe digitar el usuario';
                              }
                              return null;
                            }
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                        ),
                        new TextFormField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          controller: _password,
                          decoration: new InputDecoration(
                              labelText: "Contraseña"
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          maxLength: 20,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Debe digitar la contraseña';
                            }
                            return null;
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: new MaterialButton(
                            color: Constantes.colorBoton,
                            textColor: Constantes.colorTextoBoton,
                            height: 50.0,
                            minWidth: 100.0,
                            child: new Text(
                              "Ingresar",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: ()=>{
                              if (_formKey.currentState.validate()) {
                                setState((){
                                  _mostrarIndicador = 1;
                                }),
                                _getUser()
                              }
                            },
                            splashColor: Constantes.colorSplashBoton,
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: new MaterialButton(
                            color: Constantes.colorBotonSecundario,
                            textColor: Constantes.colorTextoBoton,
                            height: 50.0,
                            minWidth: 100.0,
                            child: new Text(
                              "Registrarse",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: ()=>{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RegistroPage()),
                              )
                            },
                            splashColor: Constantes.colorSplashBoton,
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                        ),
                        ShowWaitIndicator()
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

  Future<Usuario> _getUser() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response =
        await http.get(sprintf(Constantes.urlLogin, [_usuario.text, _password.text]));

    if (response.statusCode == 200 ) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON

      var parsedJson = json.decode(response.body);

      if (parsedJson["success"] == 1) {

        setState(() {
          _mostrarIndicador = 2;

          prefs.setString('idUsuario', parsedJson["usuario"][0]["id"]);
          prefs.setString('nombreUsuario', parsedJson["usuario"][0]["nombre"]);
          prefs.setString('correoUsuario', parsedJson["usuario"][0]["email"]);
          prefs.setString('casaUsuario', parsedJson["usuario"][0]["casa"]);
          prefs.setString('censoUsuario', parsedJson["usuario"][0]["censo"]);
          prefs.setString('contrasenaActual', _password.text);
        });

        if (parsedJson["usuario"][0]["censo"]=="1") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Principal()),
          );
        }
        else
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CensoPage(parsedJson["usuario"][0]["id"])),
            );
          }
        return Usuario.fromJson(json.decode(response.body));
      }
      else {
        if (parsedJson["success"] == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CambiarContrasenaPage()),
          );
        }
        else
        {
          setState((){
            _mostrarIndicador = 0;
          });

          _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(parsedJson["message"], style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));

        }
      }

    } else {
      setState((){
        _mostrarIndicador = 0;
      });

      //_keyScaffold.currentState.showSnackBar(SnackBar(content: Text(parsedJson["Mensaje"], style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text('Failed to load post', style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));

    }

  }


}