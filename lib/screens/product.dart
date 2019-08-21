import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinturasapp/models/cart.dart';
import '../database.dart';
import 'shoppingCart.dart';
import 'home.dart';

String _image;
String _name;
String _description;
String _price;
String _category;
//variable for product add cart
bool _isButtonTapped = false;

class Product extends StatefulWidget {
  Product(Key key, String image, String name, String description, String price,
      String category) {
    _image = image;
    _name = name;
    _description = description;
    _price = price;
    _category = category;
  }

  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  Color _fontColor = Colors.black;
  int _fontSize;
  int heightButtons;

  EdgeInsets paddingTextField;

  List<int> listShoppingCar = new List<int>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getProductsInCart();
    super.initState();
  }

  void getProductsInCart() {
    DBProvider db = new DBProvider();
    db.getCarts(0).then((onValue) {
      for (var item in onValue) {
        listShoppingCar.add(0);
      }
      setState(() {});
    }).catchError((onError) {});
  }

  bool checkProductsInCart() {
    if (listShoppingCar.length == 0) return true;

    setState(() {});
    return false;
  }

  Widget sizeScreen480x640(BuildContext context) {}

  Widget sizeScreen720x1280(BuildContext context) {}

  Widget sizeScreen1200x1920(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.7,
          child: Image.asset(
            _image,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          child: Text('Nombre del producto'),
        ),
        Container(
          child: Text('Precio'),
        ),
        Container(
          child: Text('Descripcion'),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.5,
          child: RaisedButton(
            color: Colors.blue,
            onPressed: _isButtonTapped ? null : _onTappedAddProductCart,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                ),
                Text(
                  'Agregar al carrito',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
        Text(
          'Productos relacionados',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 3,
          child: ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              createCardProductPaint(context, 'assets/images/Vinyl/realtek.png',
                  "Nombre", "50.00", "Description", "Category"),
              createCardProductPaint(context, 'assets/images/Vinyl/vini.png',
                  "Nombre", "50.00", "Description", "Category"),
              createCardProductPaint(
                  context,
                  'assets/images/Vinyl/vinipesa.png',
                  "Nombre",
                  "50.00",
                  "Description",
                  "Category"),
            ],
          ),
        )
      ],
    );
  }

  void addProduct() async {
    //ADD A PRODUCT TO THE CART local database
    DBProvider db = new DBProvider();
    if (db.newCart(new Cart(
            name: "Nombre",
            price: "Precio",
            image: "Imagen",
            description: "Descripcion",
            idUser: 0)) !=
        0) listShoppingCar.add(10);
    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      _isButtonTapped = !_isButtonTapped;
    });
  }

  //function called when add producto to cart button its hit
  _onTappedAddProductCart() {
    setState(() => _isButtonTapped =
        !_isButtonTapped); //tapping the button once, disables the button from being tapped again
    //DO DE LOGIN FUNCTION
    addProduct();
  }

  //Return a widget of the product paint
  Widget createCardProductPaint(
      BuildContext context,
      String _image,
      String _nameProduct,
      String _price,
      String _description,
      String _category) {
    String image = _image;
    String nameProduct = _nameProduct;
    String price = _price;

    return Container(
      // color: Colors.transparent,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width / 2,
      child: Container(
        // color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //headder image
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                // color: Colors.white54,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5,
                child: FittedBox(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new Product(
                              UniqueKey(),
                              _image,
                              _nameProduct,
                              _description,
                              _price,
                              _category)));
                    },
                    child: Image.asset(
                      image,
                    ),
                  ),
                  fit: BoxFit.fill,
                )),

            //name Product
            Align(
                alignment: Alignment.center,
                child: Text(nameProduct,
                    style: TextStyle(
                        fontSize: 16,
                        color: _fontColor,
                        fontWeight: FontWeight.bold))),

            //Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Icon(Icons.attach_money), Text(price)],
            ),
            //More information
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   mainAxisSize: MainAxisSize.min,
            //   children: <Widget>[
            //     Icon(Icons.info),
            //     FlatButton(
            //       onPressed: () {
            //         Navigator.of(context).push(new MaterialPageRoute(
            //             builder: (BuildContext context) => new Product()));
            //       },
            //       child: Text(
            //         'Mas informacion',
            //         style: TextStyle(fontSize: 14),
            //       ),
            //     )
            //   ],
            // ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              // margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Colors.white60,
                      onPressed:
                          _isButtonTapped ? null : _onTappedAddProductCart,
                      child: Icon(
                        Icons.add_shopping_cart,
                        color: Colors.green[900],
                      ),
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

  Future<bool> _onWillPop() {
    return Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (BuildContext context) => new Home()));
  }

  Widget backgroundImage(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.grey.withOpacity(1), BlendMode.dstOut),
          image: ExactAssetImage('assets/images/bg3.png'),
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //disable screen rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            title: Text(_name),
            centerTitle: true,
            actions: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(15.0),
                child: new Container(
                    height: 150.0,
                    width: 30.0,
                    child: new GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new ShoppingCart()));
                      },
                      child: new Stack(
                        children: <Widget>[
                          new IconButton(
                            icon: new Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            onPressed: null,
                          ),
                          checkProductsInCart()
                              ? new Container()
                              : new Positioned(
                                  child: new Stack(
                                  children: <Widget>[
                                    new Icon(Icons.brightness_1,
                                        size: 20.0, color: Colors.red[800]),
                                    new Positioned(
                                        top: 3.0,
                                        right: 6.0,
                                        child: new Center(
                                          child: new Text(
                                            listShoppingCar.length.toString(),
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )),
                                  ],
                                )),
                        ],
                      ),
                    )),
              )
            ],
          ),
          body: Stack(
            children: <Widget>[
              backgroundImage(context),
              Theme(
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
            ],
          )),
    );
  }
}
