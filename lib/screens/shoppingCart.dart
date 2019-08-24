import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinturasapp/database.dart';
import 'package:pinturasapp/models/cart.dart';
import 'package:pinturasapp/screens/home.dart';
import 'payment.dart';

class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key key}) : super(key: key);

  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Cart> listShoppingCar = new List<Cart>();

  int _fontSize;

  int heightButtons;

  EdgeInsets paddingTextField;

  @override
  void initState() {
    getProductsInCart();
    super.initState();
  }

  void getProductsInCart() {
    DBProvider db = new DBProvider();
    db.getCarts(0).then((onValue) {
      for (var item in onValue) {
        listShoppingCar.add(item);
      }
      if (listShoppingCar.length == 0) {
        _isButtonTapped = true;
      }
      setState(() {});
    }).catchError((onError) {});
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

  Widget cardShoppingCart(BuildContext context, int idCart, String image,
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
                              _onRemoveProduct(idCart);
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
  _onRemoveProduct(int idCart) {
    setState(() => _isButtonTapped =
        !_isButtonTapped); //tapping the button once, disables the button from being tapped again
    removeProduct(idCart);
  }

  changestate() {
    setState(() {
      carListWidget();
    });
    setState(() => _isButtonTapped = !_isButtonTapped);
  }

  removeProduct(int idCart) async {
    DBProvider db = new DBProvider();
    db.deleteCartById(0, idCart);
//Remove from current list
    int indexToDelete = 0;
    for (final item in listShoppingCar) {
      if (item.idCart == idCart) {
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
      listCart.add(cardShoppingCart(context, item.idCart, item.image, item.name,
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
