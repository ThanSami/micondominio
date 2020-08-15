import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sprintf/sprintf.dart';
import 'constantes.dart';

class CensoPage extends StatefulWidget {
  final _idUsuario;
  CensoPage(this._idUsuario);
  @override
  createState() => _CensoPageState( sprintf( Constantes.urlCenso, [this._idUsuario]));
}
class _CensoPageState extends State<CensoPage> {
  var _url;
  final _key = UniqueKey();
  _CensoPageState( this._url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Censo'),
          backgroundColor: Constantes.colorPrimario,
        ),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _url))
          ],
        ));
  }
}