import 'dart:convert';

BillingDelivery BillingDeliveryFromJson(String str) {
  final jsonData = json.decode(str);
  return BillingDelivery.fromMap(jsonData);
}

String BillingDeliveryToJson(BillingDelivery data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class BillingDelivery {
  int idBillingDelivery;
  String billingAddress;
  String deliveryAddress;
  int idUser;

  BillingDelivery({
    this.idBillingDelivery,
    this.billingAddress,
    this.deliveryAddress,
    this.idUser,
  });

  factory BillingDelivery.fromMap(Map<String, dynamic> json) => new BillingDelivery(
        idBillingDelivery: json["idBillingDelivery"],
        billingAddress: json["billingAddress"],
        deliveryAddress: json["deliveryAddress"],
        idUser: json["idUser"],
      );

  Map<String, dynamic> toMap() => {
        "idBillingDelivery": idBillingDelivery,
        "billingAddress": billingAddress,
        "deliveryAddress":deliveryAddress,
        "idUser":idUser,
      };
}
