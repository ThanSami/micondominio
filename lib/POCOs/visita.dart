class Visita {
  String fechainicio;
  String fechafin;
  String nombre;
  String cedula;
  String celular;
  String placa;
  int cantidadpersonas;
  bool favorito;
  bool permanente;
  String propietario;

  Visita({this.fechainicio,
          this.fechafin,
          this.nombre,
          this.cedula,
          this.celular,
          this.placa,
          this.cantidadpersonas,
          this.favorito,
          this.permanente,
          this.propietario});

  factory Visita.fromJson(Map<String, dynamic> json) {
    return Visita(
        fechainicio: json['fechainicio'],
        fechafin: json['fechafin'],
        nombre: json['Nombre'],
        cedula: json['identificacion'],
        celular: json['telefono'],
        placa: json['placa'],
        cantidadpersonas: json['cantidad'],
        favorito: json['esFavorito'],
        permanente: json['esPermanente'],
        propietario: json['propietario']
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["fechainicio"] = fechainicio;
    map["fechafin"] = fechafin;
    map["nombre"] = nombre;
    map["identificacion"] = cedula;
    map["telefono"] = celular;
    map["placa"] = placa;
    map["cantidad"] = cantidadpersonas.toString();
    map["esFavorito"] = ( favorito ? "1" : "0" );
    map["esPermanente"] = ( permanente ? "1" : "0" );
    map["propietario"] = propietario;
    return map;
  }
}