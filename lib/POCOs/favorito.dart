class Favorito {
  int id;
  String nombre;
  String placa;
  String cedula;

  Favorito({this.id, this.nombre, this.placa, this.cedula});

  factory Favorito.fromJson(Map<String, dynamic> json) {
    return Favorito(
        id: json['id'],
        nombre: json['Nombre'],
        placa: json['placa'],
        cedula: json['identificacion']
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["Nombre"] = nombre;
    map["placa"] = placa;
    map["identificacion"] = cedula;

    return map;
  }
}