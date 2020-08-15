class Registro {
  String nombre;
  String cedula;
  bool esPropietario;
  String telefono;
  String correo;
  String casa;
  int idCondominio;
  bool autoriza;

  Registro({this.nombre, this.cedula, this.esPropietario, this.telefono, this.correo, this.casa, this.idCondominio, this.autoriza});

  factory Registro.fromJson(Map<String, dynamic> json) {
    return Registro(
        nombre: json['nombre'],
        cedula: json['cedula'],
        esPropietario: json['propietario'],
        telefono: json['telefono'],
        correo: json['email'],
        casa: json['casa'],
        idCondominio: json['condominio'],
        autoriza: json['autoriza']
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["nombre"] = nombre;
    map["cedula"] = cedula;
    map["propietario"] = ( esPropietario ? "1" : "0");
    map["telefono"] = telefono;
    map["email"] = correo;
    map["casa"] = casa;
    map["condominio"] = idCondominio.toString();
    map["autoriza"] = ( autoriza ? "1" : "0" ) ;

    return map;
  }
}