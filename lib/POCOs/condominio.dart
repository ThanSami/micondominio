class Condominio {
  int id;
  String nombre;

  Condominio(
      {this.id,
        this.nombre });

  Condominio.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nombre'] = this.nombre;
    return data;
  }
}