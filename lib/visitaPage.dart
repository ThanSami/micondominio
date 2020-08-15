import 'dart:core';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
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
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:micondominio/POCOs/visita.dart';
import 'package:micondominio/POCOs/favorito.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VisitaPage extends StatefulWidget{

  @override
  State createState() => VisitaPageState();


}

class VisitaPageState extends State<VisitaPage> {

  GlobalKey globalKey = GlobalKey();
  double bodyHeight;

  final _formKey = GlobalKey<FormState>();
  var _keyScaffold = new GlobalKey<ScaffoldState>();
  final List<DropdownMenuItem> _favoritos = [];
  String _idUsuario = "";
  String _QRData = "";

  TextEditingController fechaInicioController;
  DateTime _fechaInicio;
  TextEditingController fechaFinController;
  DateTime _fechaFin;
  List<Favorito> _listafavoritos = [];
  int _idFavoritoSeleccionado;
  List<dynamic> itemsList = List();

  Visita _visita = new Visita(
    fechainicio: "",
    fechafin: "",
    nombre: "",
    cedula: "",
    celular: "",
    cantidadpersonas: 0,
    placa: "",
    permanente: false,
    favorito: false,
    propietario: ""
  );

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _idUsuario = (prefs.getString('correoUsuario') ?? '');
    _visita.propietario = _idUsuario;
  }

  @override
  void initState(){
    _loadUser();
    getFavoritos();
  }

  bool _mostrarIndicador = false;


  @override
  Widget build(BuildContext context) {

    bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return new Scaffold(
      key: _keyScaffold,
      appBar: AppBar(
        title: Text('Registro Visita'),
        backgroundColor: Constantes.colorPrimario,
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            image:  new DecorationImage(
              image: new AssetImage("images/borderbackground.png"),
              fit: BoxFit.fill,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
            )
        ),
        child: SingleChildScrollView(
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
                    padding: const EdgeInsets.all(30.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(top:5.0),
                        ),
                        new Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  print("onTap fecha inicio");
                                  _showDatePickerInicio();
                                },
                                child: Icon(Icons.date_range),
                              ),
                            ),
                            Container(
                              child: new Flexible(
                                  child: new TextField(
                                      decoration: InputDecoration(
                                          labelText: "Desde",
                                          hintText: "Fecha Inicio",
                                          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                                      maxLines: 1,
                                      readOnly: true,
                                      controller: fechaInicioController)),
                            ),
                          ],
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        new Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  print("onTap fecha fin");
                                  _showDatePickerFin();
                                },
                                child: Icon(Icons.date_range),
                              ),
                            ),
                            Container(
                              child: new Flexible(
                                  child: new TextField(
                                      decoration: InputDecoration(
                                          labelText: "Hasta",
                                          hintText: "Fecha Fin",
                                          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                                      maxLines: 1,
                                      readOnly: true,
                                      controller: fechaFinController)),
                            ),
                          ],
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        SearchableDropdown.single(
                          isExpanded: true,
                          items: _favoritos,
                          value: _idFavoritoSeleccionado,
                          hint: "Favoritos",
                          searchHint: "Favoritos",
                          onChanged: (value) {
                            setState(() {
                              print(value);
                              _idFavoritoSeleccionado = value;
                            });
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
                              labelText: "Nombre",
                              hintText: "Nombre",
                              icon: const Icon(Icons.person)
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
                            _visita.nombre = value;
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
                              hintText: "Cédula",
                              icon: const Icon(Icons.credit_card)
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 12,
                          onSaved: (String value) {
                            _visita.cedula = value;
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
                              labelText: "Celular (Mensaje Whatsapp)",
                              hintText: "Celular (Mensaje Whatsapp)",
                              icon: const Icon(Icons.settings_cell)
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          onSaved: (String value) {
                            _visita.celular = value;
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
                              labelText: "# Placa",
                              hintText: "# Placa",
                              icon: const Icon(Icons.aspect_ratio)
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 100,
                          onSaved: (String value) {
                            _visita.placa = value;
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
                              labelText: "Cantidad Personas",
                              hintText: "Cantidad Personas",
                              icon: const Icon(Icons.people)
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          validator: (value) {
                            if  (value.isEmpty){
                              return 'Debe digitar cantidad de personas';
                            }

                            return null;
                          },
                          onSaved: (String value) {
                            _visita.cantidadpersonas = int.parse(value);
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        Row(
                          children: <Widget>[
                            CupertinoSwitch(
                              value: _visita.favorito,
                              onChanged: (value){
                                setState(() {
                                  _visita.favorito = value;
                                });
                              },
                            ),
                            Text('Favorito')
                          ],
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        Row(
                          children: <Widget>[
                            CupertinoSwitch(
                              value: _visita.permanente,
                              onChanged: (value){
                                setState(() {
                                  _visita.permanente = value;
                                });
                              },
                            ),
                            Text('Permanente')
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

                                createPost(Constantes.urlSetVisita, body: _visita.toMap() )
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
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            height: 300,
                            width: 280,
                            child: RepaintBoundary(
                              key: globalKey,
                              child: QrImage(data: _QRData, size: 0.5 * bodyHeight),
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

        setState(() {
          _QRData = 'Nombre: ' + _visita.nombre + '\n' + '' +
              'Placa: ' + _visita.placa + '\n' +
              'Cantidad: ' + _visita.cantidadpersonas.toString();
        });

        var imagen = QrImage(data: _QRData, size: 0.5 * bodyHeight);
        _captureAndSharePng(imagen);

        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Nueva Visita"),
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
                              Principal()),
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


  Future<String> getFavoritos() async {

    final response =
    await http.get( sprintf(Constantes.urlGetFavoritos, []));

    if (response.statusCode == 200 ) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON

      var parsedJson = json.decode(response.body);

      if (parsedJson["status"] == "true") {

        this.setState(() {
          var _lista = parsedJson["favoritos"] as List;

          _lista.map((i) => Favorito.fromJson(i)).toList().forEach((favorito) =>
          {
            _listafavoritos.add(favorito),
            _favoritos.add(DropdownMenuItem(
              child: Text(favorito.nombre),
              value: favorito.id,
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

  Future<Null> _showDatePickerInicio() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now()
            .year - 1, 1),
        lastDate: DateTime(DateTime
            .now()
            .year, 12));

    if (picked != null) {
      setState(() {
        _fechaInicio = picked;
        fechaInicioController =
        new TextEditingController(text:
        "${picked.day}/${picked.month}/${picked.year}");
        _visita.fechainicio = "${picked.year}-${picked.month}-${picked.day}";
        //datosRegistro.fechaMuestra = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<Null> _showDatePickerFin() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now()
            .year - 1, 1),
        lastDate: DateTime(DateTime
            .now()
            .year, 12));

    if (picked != null) {
      setState(() {
        _fechaFin = picked;
        fechaFinController =
        new TextEditingController(text:
        "${picked.day}/${picked.month}/${picked.year}");
        _visita.fechafin = "${picked.year}-${picked.month}-${picked.day}";
        //datosRegistro.fechaMuestra = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _captureAndSharePng(image) async {
    try {
      /*RenderRepaintBoundary boundary = globalKey.currentContext
          .findRenderObject();
      var image = await boundary.toImage();*/
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();


      await WcFlutterShare.share(
          sharePopupTitle: 'Enviar',
          subject: 'Visita',
          text: 'Favor Presentar este código al oficial',
          fileName: 'visita.png',
          mimeType: 'image/png',
          bytesOfFile: pngBytes);

    } catch(e) {
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(e.toString(), style: TextStyle( color: Colors.white),), backgroundColor: Constantes.colorPrimario));
    }
  }

}