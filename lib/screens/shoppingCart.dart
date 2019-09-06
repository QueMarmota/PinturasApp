import 'dart:convert';
import 'package:pinturasapp/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:pinturasapp/database.dart';
import 'package:pinturasapp/models/product.dart';
import 'package:pinturasapp/screens/home.dart';
import 'payment.dart';
import 'package:http/http.dart' as http;

class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key key}) : super(key: key);

  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Product> listShoppingCar = new List<Product>();

  int _fontSize;

  int heightButtons;

  EdgeInsets paddingTextField;

  @override
  void initState() {
    //DECODE JWT
    //get the token from local db
    final parts = globals.getApiToken().split('.');
    final payload = parts[1];
    final String decoded = B64urlEncRfc7515.decodeUtf8(payload);
    Map<String, dynamic> data = jsonDecode(decoded);
    currentIdUser = data["idUser"];
    //Search if the user have products in the shopping cart
    getProductsInCart(data["idUser"]);
    super.initState();
  }

  void getProductsInCart(int idUser) async {
    // DBProvider db = new DBProvider();
    // db.getCarts(0).then((onValue) {
    //   for (var item in onValue) {
    //     listShoppingCar.add(item);
    //   }
    //   if (listShoppingCar.length == 0) {
    //     _isButtonTapped = true;
    //   }
    //   setState(() {});
    // }).catchError((onError) {});

    var url = globals.apiUrl + 'shopping_cart/idUser/' + idUser.toString();
    var response = await http.get(url);
    //Decode json
    Map<String, dynamic> data = jsonDecode(' ${response.body}');
    //If everything went good
    if (data.length > 0) {
      for (var item in data["data"]) {
        //add a number to the shopping cart
         url = globals.apiUrl + 'products/' + item["idProduct"].toString();
         response = await http.get(url);
        //Decode json
        Map<String, dynamic> dataProd = jsonDecode(' ${response.body}');
        dataProd["price"] = dataProd["price"].toString();
        dataProd["idCategory"] = dataProd["idCategory"].toString();

        // dataProd["price"] = double.parse(dataProd["price"]);
        print(dataProd);
        Product tempcar = Product.fromMap(dataProd);
        listShoppingCar.add(tempcar);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    //disable screen rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Future<bool> _onWillPop() {
      return Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (BuildContext context) => new Home()));
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Carrito de compras'),
          backgroundColor: Colors.red,
        ),
        body: Theme(
          data: ThemeData(accentColor: Colors.blue, fontFamily: 'Roboto'),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (MediaQuery.of(context).size.height < 379) {
                //480x640
                _fontSize = 13;
                heightButtons = 30;
                paddingTextField = EdgeInsets.fromLTRB(10, 5, 10, 10);
                return sizeScreen480x640(context);
              } else if (MediaQuery.of(context).size.height < 650) {
                //720x1280
                _fontSize = 16;
                heightButtons = 35;
                paddingTextField = EdgeInsets.fromLTRB(10, 10, 10, 10);
                return sizeScreen720x1280(context);
              } else {
                _fontSize = 20;
                heightButtons = 40;
                paddingTextField = EdgeInsets.fromLTRB(10, 15, 10, 10);
                return sizeScreen1200x1920(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget cardShoppingCart(BuildContext context, int idProduct, String image,
      String name, String description, String price) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.black),
        ),
        color: Colors.blue[50],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              child: Image.asset(
                'assets/images/Vinyl/vinipesa.png',
              ),
            ),
            Column(
              children: <Widget>[
                //Price
                Text('Nombre pintura'),
                Text('Descripcion'),
              ],
            ),
            Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Precio'),
                    IconButton(
                      color: Colors.red,
                      iconSize: 40,
                      icon: Icon(Icons.remove_shopping_cart),
                      tooltip: 'Quitar producto',
                      onPressed: _isButtonTapped
                          ? null
                          : () {
                              setState(() => _isButtonTapped =
                                  !_isButtonTapped); //tapping the button once, disables the button from being tapped again
                              _onRemoveProduct(idProduct);
                            },
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  bool _isButtonTapped = false;
  //function called when sign in button its hited
  _onTapped() {
    setState(() => _isButtonTapped =
        !_isButtonTapped); //tapping the button once, disables the button from being tapped again
    confirmService();
  }

  //function called when sign in button its hited
  _onRemoveProduct(int idProduct) {
    setState(() => _isButtonTapped =
        !_isButtonTapped); //tapping the button once, disables the button from being tapped again
    removeProduct(idProduct);
  }

  changestate() {
    setState(() {
      carListWidget();
    });
    setState(() => _isButtonTapped = !_isButtonTapped);
  }

  removeProduct(int idProduct) async {
    DBProvider db = new DBProvider();
    db.deleteCartById(0, idProduct);
//Remove from current list
    int indexToDelete = 0;
    for (final item in listShoppingCar) {
      if (item.id == idProduct) {
        break;
      }
      indexToDelete++;
    }
    listShoppingCar.removeAt(indexToDelete);
    changestate();
    // await Future.delayed(Duration(milliseconds: 2500));
    if (listShoppingCar.length != 0)
      setState(() => _isButtonTapped = !_isButtonTapped);
  }

  confirmService() async {
    await Future.delayed(Duration(milliseconds: 200));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Payment(),
        ));
    _isButtonTapped = !_isButtonTapped;
    // Dialogs dialog = new Dialogs();
    // var url = globals.apiUrl + 'client/register';
    // var response = await http.post(url, body: {
    //   'email': '${email.text}',
    //   'name': '${name.text}',
    //   'phone': '${phone.text == "" ? '' : phone.text}',
    //   'password': '${password.text}'
    // });
    //Decode json
    // Map<String, dynamic> data = jsonDecode(' ${response.body}');
    // if ('${data['status']}' == "success") {
    //   //if everything works fine in server side
    //   dialog.success(context, 'Registro Correcto',
    //       '¡Te enviamos un\ncorreo para\nactivar la cuenta!');
    //   await Future.delayed(Duration(seconds: 3));
    //   Navigator.of(context, rootNavigator: true).pop('dialog');
    //   await Future.delayed(Duration(milliseconds: 500));
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => Login(),
    //       ));
    // } else {
    //   //if http petition goes wrong
    //   dialog.error(context, 'Algo salio mal', 'Intentalo mas tarde');
    //   await Future.delayed(Duration(seconds: 2));
    //   Navigator.of(context, rootNavigator: true).pop('dialog');
    // }
  }

  Widget buttonConfirmPay(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: <Widget>[
          ButtonTheme(
            height: 40,
            minWidth: MediaQuery.of(context).size.width / 2,
            child: RaisedButton(
              onPressed: _isButtonTapped ? null : _onTapped,
              color: Colors.blue,
              shape: new RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue),
                  borderRadius: new BorderRadius.circular(10.0)),
              child: new Text(
                'Confirmar',
                style: new TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> carListWidget() {
    List<Widget> listCart = new List<Widget>();

    for (var item in listShoppingCar) {
      listCart.add(cardShoppingCart(context, item.id, item.image, item.name,
          item.description, item.price));
    }
    return listCart;
  }

  Widget sizeScreen480x640(BuildContext context) {
    return Column(
      children: <Widget>[
        //List
        Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width,
            child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: carListWidget())),
        //Feedback and button
        //divider
        new SizedBox(
          height: 10.0,
          child: new Center(
            child: new Container(
              margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
              height: 2.0,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).size.height / 1.2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total a pagar',
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.attach_money),
                  Text(
                    '50.00',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              buttonConfirmPay(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget sizeScreen720x1280(BuildContext context) {
    return Column(
      children: <Widget>[
        //List
        Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width,
            child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: carListWidget())),
        //Feedback and button
        //divider
        new SizedBox(
          height: 10.0,
          child: new Center(
            child: new Container(
              margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
              height: 2.0,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).size.height / 1.2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total a pagar',
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.attach_money),
                  Text(
                    '50.00',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              buttonConfirmPay(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget sizeScreen1200x1920(BuildContext context) {
    return Column(
      children: <Widget>[
        //List
        Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width,
            child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: carListWidget())),
        //Feedback and button
        //divider
        new SizedBox(
          height: 10.0,
          child: new Center(
            child: new Container(
              margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
              height: 2.0,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).size.height / 1.2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total a pagar',
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.attach_money),
                  Text(
                    '50.00',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              buttonConfirmPay(context),
            ],
          ),
        ),
      ],
    );
  }
}
