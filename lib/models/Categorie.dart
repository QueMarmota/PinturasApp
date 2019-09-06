import 'dart:convert';

Categorie CategorieFromJson(String str) {
  final jsonData = json.decode(str);
  return Categorie.fromMap(jsonData);
}

String CategorieToJson(Categorie data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Categorie {
  int id;
  String description;
  String name;

  Categorie({
    this.id,
    this.description="",
    this.name="",
  });

  factory Categorie.fromMap(Map<String, dynamic> json) => new Categorie(
        id: json["id"],
        description: json["description"],
        name:json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
        "name":name,
      };
}
