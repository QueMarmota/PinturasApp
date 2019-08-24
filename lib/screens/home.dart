import 'package:flutter/material.dart';
import 'package:pinturasapp/widgets/Cards.dart';
import 'package:pinturasapp/screens/login.dart';
import 'package:pinturasapp/screens/signin.dart';
import 'package:pinturasapp/globals.dart' as globals;
import 'package:pinturasapp/database.dart';
import 'package:pinturasapp/screens/shoppingCart.dart';
import 'package:pinturasapp/screens/product.dart';
import 'deliveryAndBilling.dart';
import 'package:pinturasapp/database.dart';
import 'package:pinturasapp/models/cart.dart';

double _fontSize = 18;
bool buildFinished = false;
Color _inputColor;
Color _buttonPressed = Colors.transparent;
Color _fontColor = Colors.black;
double _buttonSize;
EdgeInsets _paddingInput;
//variable for product add cart
bool _isButtonTapped = false;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ExactAssetImage bgImage = new ExactAssetImage('assets/images/bg2.png');
  List<int> listShoppingCar = new List<int>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//variables for dropdownlist
  List _category = [
    'Todo',
    'Pinturas Vinílicas',
    'Esmaltes',
    'Impermeabilizantes'
  ];
  List<DropdownMenuItem<String>> _dropDownMenuItemscategory;
  String _currentcategory;
  //Refresh de dropdown list category

  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownMenuItemscategory() {
    List<DropdownMenuItem<String>> items = new List();
    for (String category in _category) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(
          new DropdownMenuItem(value: category, child: new Text(category)));
    }
    return items;
  }
  //end of variables need it

  @override
  void initState() {
    getProductsInCart();
    super.initState();
    buildFinished = true;
    //get the values of the list
    _dropDownMenuItemscategory = getDropDownMenuItemscategory();
    //change the current category from the reloaded list
    _currentcategory = _dropDownMenuItemscategory[0].value;
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

  @override
  Widget build(BuildContext context) {
    bool checkProductsInCart() {
      if (listShoppingCar.length == 0) return true;

      return false;
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
      await Future.delayed(Duration(milliseconds: 1000));

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
        width: MediaQuery.of(context).size.width,
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
                  height: MediaQuery.of(context).size.height / 4,
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
                // margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                         shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),
                           side: BorderSide(color: Colors.black),),
                        onPressed:
                            _isButtonTapped ? null : _onTappedAddProductCart,
                        color: Colors.white,
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

    //return a horizontal list of products Vinyl Category
    Widget horizontalListProductVinyl(BuildContext context) {
      double widthCard = 170;
      return new Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: MediaQuery.of(context).size.height / 2.5,
          child: new ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: widthCard,
                child: createCardProductPaint(
                    context,
                    'assets/images/Vinyl/vintek-1.png',
                    'Vintek',
                    '50.00',
                    "Descripcion",
                    "Vinil"),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: widthCard,
                child: createCardProductPaint(
                    context,
                    'assets/images/Vinyl/realtek.png',
                    'Realtek',
                    '50.00',
                    "Descripcion",
                    "Vinil"),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: widthCard,
                child: createCardProductPaint(
                    context,
                    'assets/images/Vinyl/vini.png',
                    'Vinipesa',
                    '50.00',
                    "Descripcion",
                    "Vinil"),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: widthCard,
                child: createCardProductPaint(
                    context,
                    'assets/images/Vinyl/vinipesa.png',
                    'Vini+',
                    '50.00',
                    "Descripcion",
                    "Vinil"),
              ),
            ],
          ));
    }

    //return a horizontal list of products Vinyl Category
    Widget horizontalListProductEnamels(BuildContext context) {
      double widthCard = 170;
      return new Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: MediaQuery.of(context).size.height / 2.5,
          child: new ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: widthCard,
                child: createCardProductPaint(
                    context,
                    'assets/images/Adhesivos/acribond.png',
                    'Brigadier',
                    '50.00',
                    "Description",
                    "Vinyl"),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: widthCard,
                child: createCardProductPaint(
                    context,
                    'assets/images/Adhesivos/pegaso-bond.png',
                    'Clasico',
                    '50.00',
                    "Description",
                    "Vinyl"),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: widthCard,
                child: createCardProductPaint(
                    context,
                    'assets/images/Adhesivos/pegaso-tirol.png',
                    'Tropimar',
                    '50.00',
                    "Description",
                    "Vinyl"),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: widthCard,
                child: createCardProductPaint(
                    context,
                    'assets/images/Adhesivos/pegaso-yeso.png',
                    'Tropimar SUR',
                    '50.00',
                    "Description",
                    "Vinyl"),
              ),
            ],
          ));
    }

    //return a horizontal list of products Vinyl Category
    Widget horizontalListProductWaterproofing(BuildContext context) {
      double widthCard = 170;
      return new Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: MediaQuery.of(context).size.height / 2.5,
          child: new ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: widthCard,
                child: createCardProductPaint(
                    context,
                    'assets/images/Waterproofing/IMPER-CRIL-3D.png',
                    'Imper Crill',
                    '50.00',
                    "Description",
                    "Vinyl"),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: widthCard,
                child: createCardProductPaint(
                    context,
                    'assets/images/Waterproofing/IMPER-LUX-3D.png',
                    'Imper Lux',
                    '50.00',
                    "Description",
                    "Vinyl"),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: widthCard,
                child: createCardProductPaint(
                    context,
                    'assets/images/Waterproofing/IMPER-MICRO-3D.png',
                    'Imper Ruf',
                    '50.00',
                    "Description",
                    "Vinyl"),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: widthCard,
                child: createCardProductPaint(
                    context,
                    'assets/images/Waterproofing/IMPER-RUF-3D.png',
                    'Imper Primer',
                    '50.00',
                    "Description",
                    "Vinyl"),
              ),
            ],
          ));
    }

    List<Widget> getProductList(BuildContext context) {
      List<Widget> tempList = new List<Widget>();
      Widget tempWidget;
      switch (_currentcategory) {
        case 'Todo':
          tempWidget = Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Pinturas Vinílicas',
                  style: TextStyle(fontSize: 20, color: _fontColor),
                ),
              ),
              horizontalListProductVinyl(context),
              //divider
              new SizedBox(
                height: 60.0,
                child: new Center(
                  child: new Container(
                    margin:
                        new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                    height: 2.0,
                    color: Colors.black,
                  ),
                ),
              ),
              //Category and product horizontal list
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Esmaltes',
                  style: TextStyle(fontSize: 20, color: _fontColor),
                ),
              ),
              horizontalListProductEnamels(context),
              //divider
              new SizedBox(
                height: 60.0,
                child: new Center(
                  child: new Container(
                    margin:
                        new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                    height: 2.0,
                    color: Colors.black,
                  ),
                ),
              ),
              //Category and product horizontal list
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Impermeabilizantes',
                  style: TextStyle(fontSize: 20, color: _fontColor),
                ),
              ),
              horizontalListProductWaterproofing(context),
            ],
          );

          break;
        case 'Pinturas Vinílicas':
          tempWidget = Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Pinturas Vinílicas',
                  style: TextStyle(fontSize: 20, color: _fontColor),
                ),
              ),
              horizontalListProductVinyl(context),
            ],
          );

          break;
          case 'Esmaltes':
          tempWidget = Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Esmaltes',
                  style: TextStyle(fontSize: 20, color: _fontColor),
                ),
              ),
              horizontalListProductEnamels(context),
            ],
          );

          break;
          case 'Impermeabilizantes':
          tempWidget = Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Impermeabilizantes',
                  style: TextStyle(fontSize: 20, color: _fontColor),
                ),
              ),
              horizontalListProductWaterproofing(context),
            ],
          );

          break;
        default:
      }

      tempList.add(tempWidget);
      return tempList;
    }

    List<Widget> listPaintProducts = getProductList(context);
    void cambiar(){
      setState(() { listPaintProducts = getProductList(context);});
    }
    Widget categorieDropDownList(BuildContext context) {
      return new Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black26,
          ),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Categoria',
                  style: TextStyle(color: _fontColor, fontSize: 18),
                ),
              ),
              StatefulBuilder(builder: (BuildContext context, setState) {
                return Container(
                    color: Colors.black26,
                    padding: EdgeInsets.all(10),
                    child: new DropdownButton(
                      icon: Icon(Icons.arrow_drop_down),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      iconSize: 35,
                      isExpanded: true,
                      isDense: true,
                      value: _currentcategory,
                      iconEnabledColor: Colors.black,
                      items: _dropDownMenuItemscategory,
                      onChanged: (String value) {
                        setState(() {
                          _currentcategory = value;
                        });
                        listPaintProducts = getProductList(context);
                        setState(() { listPaintProducts = getProductList(context);});
                        setState(() {
                          cambiar();
                        });
                          cambiar();
                      }, //ERROR AQUI CON EL CAMBIO DE ESTADO
                    ));
              })
            ],
          ));
    }



    //View
    return Builder(
        builder: (context) => Scaffold(
              key: _scaffoldKey,
              appBar: new AppBar(
                backgroundColor: Colors.red,
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
                                            size: 20.0, color: Colors.green[800]),
                                        new Positioned(
                                            top: 3.0,
                                            right: 6.0,
                                            child: new Center(
                                              child: new Text(
                                                listShoppingCar.length
                                                    .toString(),
                                                style: new TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11.0,
                                                    fontWeight:
                                                        FontWeight.w500),
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
                  //Background Image
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: new ColorFilter.mode(
                            Color.fromARGB(0, 255, 255, 255).withOpacity(1),
                            BlendMode.srcATop),
                        image: bgImage,
                        fit: BoxFit.fill,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  SafeArea(
                      left: true,
                      top: true,
                      right: true,
                      bottom: false,
                      minimum: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                // formTextBoxNameEvent(context),
                                categorieDropDownList(context),
                              ],
                            ),
                          ),
                        ],
                      )),
                  //Position always bottom of the category list
                  Positioned(
                      bottom: 0.0,
                      child: Column(
                        children: <Widget>[
                          //List
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: ListView.builder(
                              itemCount: listPaintProducts.length,
                                padding: EdgeInsets.all(20),
                                scrollDirection: Axis.vertical,
                                // physics: BouncingScrollPhysics(),
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return listPaintProducts[index];
                                }),
                          ),
                        ],
                      )),
                ],
              ),
              //DRAWER CODE
              drawer: Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      child: Text(
                        'PinturasApp',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                        //   image:  DecorationImage(
                        //   colorFilter: new ColorFilter.mode(
                        //       Color.fromARGB(0, 255, 255, 255).withOpacategory(0.5),
                        //       BlendMode.srcATop),
                        //   image:  new ExactAssetImage('assets/images/logo_demo.jpg'),
                        //   fit: BoxFit.fill,
                        //   alignment: Alignment.topCenter,
                        // ),

                        // Box decoration takes a gradient
                        gradient: LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          stops: [0.1, 0.5, 0.7, 0.9],
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            //simulate gradient
                            Colors.red[800],
                            Colors.red[700],
                            Colors.red[600],
                            Colors.red[400],
                          ],
                        ),
                      ),
                    ),
                    if (globals.getApiToken() != '')
                      ListTile(
                        title: Text('Facturación y Entrega'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    (DeliveryBilling()),
                              ));
                        },
                      ),
                    if (globals.getApiToken() == '')
                      ListTile(
                        title: Text('Iniciar sesión'),
                        onTap: () {
                          // Update the state of the app
                          // ...
                          // Then close the drawer
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => (Login()),
                              ));
                        },
                      ),
                    if (globals.getApiToken() == '')
                      ListTile(
                        title: Text('Registrarse'),
                        onTap: () {
                          // Update the state of the app
                          // ...
                          // Then close the drawer
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => (SingIn()),
                              ));
                        },
                      ),
                    if (globals.getApiToken() != '')
                      ListTile(
                        title: Text('Cerrar Sesión'),
                        onTap: () {
                          DBProvider db = new DBProvider();
                          //this function remove the local storage
                          db.removeContent();
                          globals.setApiToken('');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => (Home()),
                              ));
                        },
                      ),
                  ],
                ),
              ),
            ));
  }
}
