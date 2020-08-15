class Usuario {
  int id;
  String nombre;
  String email;
  String casa;
  int censo;
  String password;

  Usuario({this.id, this.nombre, this.email, this.casa, this.censo, this.password});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      casa: json['casa'],
      censo: json['censo'],
    );
  }


}