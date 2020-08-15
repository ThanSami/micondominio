import 'package:flutter/material.dart';
import 'package:micondominio/loginPage.dart';
void main() => runApp(new MiCondominioApp());

class MiCondominioApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new LoginPage(),
        theme: new ThemeData(
            primarySwatch: Colors.indigo
        )
    );
  }

}