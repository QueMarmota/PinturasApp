import 'dart:convert';

Product ProductFromJson(String str) {
  final jsonData = json.decode(str);
  return Product.fromMap(jsonData);
}

String ProductToJson(Product data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Product {
  int id;
  String description;
  String name;
  String price;
  String category;
  String image;
  String state;

  Product(
      {this.id,
      this.description = "",
      this.name = "",
      this.price = "0.0",
      this.category = "0",
      this.image = "assets/images/Waterproofing/IMPER-CRIL-3D.png",
      this.state = "0"});

  factory Product.fromMap(Map<String, dynamic> json) => new Product(
      id: json["id"],
      description: json["description"],
      name: json["name"],
      price: json["price"],
      category: json["category"],
      image: json["image"],
      state: json["state"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
        "name": name,
        "price": price,
        "category": category,
        "image": image,
        "state": state
      };
}
