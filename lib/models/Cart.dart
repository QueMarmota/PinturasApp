import 'dart:convert';

Cart CartFromJson(String str) {
  final jsonData = json.decode(str);
  return Cart.fromMap(jsonData);
}

String CartToJson(Cart data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Cart {
  int idCart;
  String image;
  String name;
  String description;
  String price;
  int idUser;

  Cart({
    this.idCart,
    this.image,
    this.name,
    this.description,
    this.price,
    this.idUser,
  });

  factory Cart.fromMap(Map<String, dynamic> json) => new Cart(
        idCart: json["idCart"],
        image: json["image"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        idUser: json["idUser"],
      );

  Map<String, dynamic> toMap() => {
        "idCart": idCart,
        "image": image,
        "name": name,
        "description": description,
        "price": price,
        "idUser": idUser,
      };
}
