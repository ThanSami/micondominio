import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class Constantes {

  static final Color colorPrimario = Colors.indigo[900];
  static final Color colorSecundario = Colors.indigo;
  static final Color colorBoton = Colors.indigo;
  static final Color colorBotonSecundario = Colors.blueAccent;
  static final Color colorTextoBoton = Colors.white;
  static final Color colorSplashBoton = Colors.blue;
  static final Color colorEtiquetaInput = Colors.blue;
  static final Color colorBorderInputLogin = Colors.white;

  static final String idApp = 'balterra';

  //Produccion
  /*static String host = "facturas.opuscr.com";
  static String ulrWebService = sprintf("https://%s/ssi/WSCRM/crm.asmx", [host]);*/

  //Pruebas
  static String ulrWebService = "https://galesa.net/webservice/%s";

  /* Region Login */
  static String loginMethod = "get_user.php?pEmail=%s&pPassword=%s";
  static String urlLogin = sprintf(ulrWebService, [loginMethod]);

  /* Region Login */
  static String getCondominiosMethod = "get_condominios.php";
  static String urlGetCondominios = sprintf(ulrWebService, [getCondominiosMethod]);

  /* Region Registro usuario */
  static String registroMethod = "agregar_usuario.php";
  static String urlRegistro = sprintf(ulrWebService, [registroMethod]);

  /* Region Registro usuario */
  static String cambioContrasenaMethod = "changepass.php?pPassword=%s&sid=%s";
  static String urlCambioContrasena = sprintf(ulrWebService, [cambioContrasenaMethod]);

  /* Region Censo */
  static String urlCenso = "https://galesa.net/censo.php?id=%s";

  /* Region Panico */
  static String panicoMethod = "send_mensajepanico.php?usuario=%s&pMensaje=%s";
  static String urlPanico = sprintf(ulrWebService, [panicoMethod]);

  /* Region Favoritos */
  static String getFavoritosMethod = "get_Favoritos.php?pid=%s";
  static String urlGetFavoritos = sprintf(ulrWebService, [getFavoritosMethod]);

  /* Region Visita */
  static String setVisitaMethod = "agregar_visita.php";
  static String urlSetVisita = sprintf(ulrWebService, [setVisitaMethod]);

  /* Region Get Visitas */
  static String getVisitasMethod = "get_visitor_details.php?pid=%s";
  static String urlGetVisitas = sprintf(ulrWebService, [getVisitasMethod]);

}