import 'dart:convert';

CreditCard CreditCardFromJson(String str) {
  final jsonData = json.decode(str);
  return CreditCard.fromMap(jsonData);
}

String CreditCardToJson(CreditCard data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class CreditCard {
  int idCreditCard;
  String number;
  String token;
  int idUser;

  CreditCard({
    this.idCreditCard,
    this.number,
    this.token,
    this.idUser,
  });

  factory CreditCard.fromMap(Map<String, dynamic> json) => new CreditCard(
        idCreditCard: json["idCreditCard"],
        number: json["number"],
        token: json["token"],
        idUser: json["idUser"],
      );

  Map<String, dynamic> toMap() => {
        "idCreditCard": idCreditCard,
        "number": number,
        "token":token,
        "idUser":idUser,
      };
}
