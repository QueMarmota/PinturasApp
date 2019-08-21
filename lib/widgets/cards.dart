import 'package:flutter/material.dart';

class Cards {
  String image = 'assets/images/bg1.png';
  String nameProduct;
  String price;

  Cards(String _image, String _nameProduct, String _price) {
    this.image = image;
    this.nameProduct = _nameProduct;
    this.price = _price;
  }

  Widget cardEvent(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Colors.white54,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //headder image
            Container(
                color: Colors.white54,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 7,
                child: FittedBox(
                  child: Image.asset(
                    this.image,
                  ),
                  fit: BoxFit.fill,
                )),

            //name Product
            Align(
                alignment: Alignment.center,
                child: Text(this.nameProduct,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold))),

            //Price
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text(this.price),
            ),

            Container(
              child: Row(
                children: <Widget>[
                  Icon(Icons.shopping_cart),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {},
                      child: Icon(Icons.add),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
