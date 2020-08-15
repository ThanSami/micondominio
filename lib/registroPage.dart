import 'package:micondominio/POCOs/registro.dart';
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
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'POCOs/condominio.dart';
import 'package:micondominio/POCOs/registro.dart';

class RegistroPage extends StatefulWidget{

  @override
  State createState() => RegistroState();


}

class RegistroState extends State<RegistroPage> {

  final _formKey = GlobalKey<FormState>();

  var _keyScaffold = new GlobalKey<ScaffoldState>();

  final List<DropdownMenuItem> _condominios = [];

  TextEditingController _controladorNueva = new TextEditingController();
  TextEditingController _controladorConfirmacion = new TextEditingController();

  List<dynamic> itemsList = List();

  Registro _registroUsuario = new Registro(
                nombre: "", cedula: "", esPropietario: false, telefono: "", correo: "", casa: "", idCondominio: -1, autoriza: false);

  @override
  void initState(){
    super.initState();
    getCondominios();
  }

  bool _mostrarIndicador = false;


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      key: _keyScaffold,
      appBar: AppBar(
        title: Text('Registro Usuario'),
        backgroundColor: Constantes.colorPrimario,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: new Column(
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
                              contentPadding: const EdgeInsets.only(left: 5.0, bottom: 8.0, top: 8.0),
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
                                labelText: "Nombre",
                                hintText: "Nombre"
                              ),
                              keyboardType: TextInputType.text,
                              maxLength: 100,
                              validator: (value) {
                                if  (value.isEmpty){
                                  return 'Debe digitar el nombre';
                                }

                                return null;
                              },
                              onSaved: (String value) {
                                _registroUsuario.nombre = value;
                              },
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(top:2.0),
                            ),
                            new TextFormField(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: new InputDecoration(
                                labelText: "Cédula",
                                hintText: "Cédula"
                              ),
                              keyboardType: TextInputType.text,
                              maxLength: 12,
                              validator: (value) {
                                if  (value.isEmpty){
                                  return 'Debe digitar la cédula';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                _registroUsuario.cedula = value;
                              },
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(top:2.0),
                            ),
                            Row(
                              children: <Widget>[
                                CupertinoSwitch(
                                  value: _registroUsuario.esPropietario,
                                  onChanged: (value){
                                    setState(() {
                                      _registroUsuario.esPropietario = value;
                                    });
                                  },
                                ),
                                Text('Es propietario')
                              ],
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(top:2.0),
                            ),
                            new TextFormField(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: new InputDecoration(
                                labelText: "Telefono",
                                hintText: "Telefono"
                              ),
                              keyboardType: TextInputType.text,
                              maxLength: 10,
                              validator: (value) {
                                if  (value.isEmpty){
                                  return 'Debe digitar el telefono';
                                }

                                return null;
                              },
                              onSaved: (String value) {
                                _registroUsuario.telefono = value;
                              },
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(top:2.0),
                            ),
                            new TextFormField(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: new InputDecoration(
                                  labelText: "Correo (Ej. info@galesa.net)",
                                  hintText: "Correo (Ej. info@galesa.net)"
                              ),
                              keyboardType: TextInputType.text,
                              maxLength: 100,
                              validator: (value) {
                                if  (value.isEmpty){
                                  return 'Debe digitar el correo';
                                }

                                return null;
                              },
                              onSaved: (String value) {
                                _registroUsuario.correo = value;
                              },
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(top:2.0),
                            ),
                            new TextFormField(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: new InputDecoration(
                                  labelText: "# Casa (Ej. 20B)",
                                  hintText: "# Casa (Ej. 20B)"
                              ),
                              keyboardType: TextInputType.text,
                              maxLength: 10,
                              validator: (value) {
                                if  (value.isEmpty){
                                  return 'Debe digitar el # de casa';
                                }

                                return null;
                              },
                              onSaved: (String value) {
                                _registroUsuario.casa = value;
                              },
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(top:2.0),
                            ),
                            SearchableDropdown.single(
                              isExpanded: true,
                              items: _condominios,
                              value: _registroUsuario.idCondominio,
                              hint: "Seleccione el condominio",
                              searchHint: "Seleccione el condominio",
                              onChanged: (value) {
                                setState(() {
                                  print(value);
                                  _registroUsuario.idCondominio = value;
                                });
                              },
                              validator: (value) {
                                if  (value == null){
                                  return 'Debe seleccionar el condominio';
                                }
                                return null;
                              },
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(top:2.0),
                            ),
                            Row(
                              children: <Widget>[
                                CupertinoSwitch(
                                  value: _registroUsuario.autoriza,
                                  onChanged: (value){
                                    setState(() {
                                      _registroUsuario.autoriza = value;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                      'Autorizo para que me notifiquen y utilicen mis datos para envíos de información por correo/whatsapp/SMS',
                                      style: TextStyle(color: Colors.red),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5),
                                )
                              ],
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: new MaterialButton(
                                color: Constantes.colorBoton,
                                textColor: Constantes.colorTextoBoton,
                                height: 50.0,
                                minWidth: 100.0,
                                child: new Text(
                                  "Registrarse",
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: ()=>{

                                  if (_formKey.currentState.validate()) {
                                    setState((){
                                      _mostrarIndicador = true;
                                    }),
                                    _formKey.currentState.save(),

                                    createPost(Constantes.urlRegistro, body: _registroUsuario.toMap() )
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
      ),
    );

  }

  Future createPost(String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {

      if (response.statusCode < 200 || response.statusCode > 400 || json == null) {
        _keyScaffold.currentState.showSnackBar(SnackBar(content: Text('Error while fetching data', style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
      }

      var parsedJson = json.decode(response.body);

      if (parsedJson["success"] == 1) {
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Registro Usuario"),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: new SingleChildScrollView(
                        child: new ListBody(
                          children: <Widget>[
                            new Icon(
                                Icons.check_circle,
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
                                LoginPage()),
                      );
                  },
                ),
              ],
            ));
        
      } else {
        _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(parsedJson["message"], style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
      }
    });
  }


  Future<String> getCondominios() async {

    final response =
    await http.get(Constantes.urlGetCondominios);

    if (response.statusCode == 200 ) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON

      var parsedJson = json.decode(response.body);

      if (parsedJson["status"] == "true") {

        this.setState(() {
          var _lista = parsedJson["condominios"] as List;

          _lista.map((i) => Condominio.fromJson(i)).toList().forEach((condominio) =>
          {
            _condominios.add(DropdownMenuItem(
              child: Text(condominio.nombre),
              value: condominio.id,
            ))
          });
        });
      } else {
        _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(parsedJson["message"], style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
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

}