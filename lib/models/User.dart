import 'dart:convert';

User UserFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromMap(jsonData);
}

String UserToJson(User data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class User {
  int idUser;
  String email;
  String name;

  User({
    this.idUser,
    this.email,
    this.name,
  });

  factory User.fromMap(Map<String, dynamic> json) => new User(
        idUser: json["idUser"],
        email: json["email"],
        name:json["name"],
      );

  Map<String, dynamic> toMap() => {
        "idUser": idUser,
        "email": email,
        "name":name,
      };
}
