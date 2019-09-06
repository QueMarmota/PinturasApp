import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:pinturasapp/models/Categorie.dart';
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
import 'package:http/http.dart' as http;
import 'package:pinturasapp/models/Product.dart' as ModelProduct;

double _fontSize = 18;
bool buildFinished = false;
Color _inputColor;
Color _buttonPressed = Colors.transparent;
Color _fontColor = Colors.black;
double _buttonSize;
EdgeInsets _paddingInput;
//variable for product add cart
bool _isButtonTapped = false;
int currentIdUser;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //variable for store the current product selected to the shopping cart
  ModelProduct.Product selectedProduct;
  final ExactAssetImage bgImage = new ExactAssetImage('assets/images/bg2.png');
  List<int> listShoppingCar = new List<int>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //variables for dropdownlist
  List _idCategory = [
    Categorie(name: "Todo") //added by default
  ];
  List<DropdownMenuItem<String>> _dropDownMenuItemscategory;
  Categorie _currentcategory = new Categorie();
  //Refresh de dropdown list category

  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownMenuItemscategory() {
    List<DropdownMenuItem<String>> items = new List();
    for (Categorie category in _idCategory) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: category.name, child: new Text(category.name)));
    }
    return items;
  }
  //end of variables need it

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
    getProductsInCartByUser(data["idUser"]);
    super.initState();
    buildFinished = true;
    //get the values of the list
    getCategoryList();
  }

  void getCategoryList() async {
    var url = globals.apiUrl + 'categories';
    var response = await http.get(url);
    //Decode json
    List<dynamic> data = jsonDecode(' ${response.body}');
    //If everything went good
    if (data.length > 0) {
      //read the json array and storage to a dynamic list so we can iterate items
      // List<dynamic> jsonCategorieType = data[1];
      // _cars.clear();
      for (var i = 0; i < data.length; i++) {
        Categorie tempCategorie = new Categorie();
        // _cars.add(data[i]['name']);
        tempCategorie.id = data[i]['_id'];
        tempCategorie.name = data[i]['name'];
        tempCategorie.description = data[i]['description'];
        _idCategory.add(tempCategorie);
      }
      //Initialize lists and update
      _dropDownMenuItemscategory = getDropDownMenuItemscategory();
      //change the current category from the reloaded list
      _currentcategory.name = _dropDownMenuItemscategory[0].value;
      //update state of the list to refresh widget listbox
      setState(() {});
    }
  }

  void getProductsInCartByUser(int idUser) async {
    //get products from cart server
    // DBProvider db = new DBProvider();

    // db.getCarts(0).then((onValue) {
    //   for (var item in onValue) {
    //     //add a number to the shopping cart
    //     listShoppingCar.add(0);
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
        listShoppingCar.add(0);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    //check if exists any product sloted
    bool checkProductsInCart() {
      if (listShoppingCar.length == 0) return true;
      return false;
    }

    void addProductToCart(int idProduct, int idUser) async {
      //ADD A PRODUCT TO THE CART local database
      // DBProvider db = new DBProvider();
      // if (db.newCart(new Cart(
      //         name: "Nombre",
      //         price: "Precio",
      //         image: "Imagen",
      //         description: "Descripcion",
      //         idUser: 0)) !=
      //     0)
      var url = globals.apiUrl + 'shopping_cart';
      var response = await http.post(url, body: {
        "idProduct": idProduct.toString(),
        "idUser": idUser.toString(),
      });

      //Decode json
      Map<String, dynamic> data = jsonDecode(' ${response.body}');
      if ('${data['status']}' == "success") {
        //add number to the cart list
        listShoppingCar.add(10);
      }
      await Future.delayed(Duration(milliseconds: 1000));
      setState(() {
        _isButtonTapped = !_isButtonTapped;
      });
    }

    //function called when add product to cart button its hit
    void _onTappedAddProductCart() {
      setState(() => _isButtonTapped =
          !_isButtonTapped); //tapping the button once, disables the button from being tapped again
      //do the add product action
      addProductToCart(selectedProduct.id, currentIdUser);
    }

    //Return a widget of the product paint
    Widget createCardProductPaint(
        BuildContext context,
        int _id,
        String _image,
        String _nameProduct,
        String _price,
        String _description,
        String _idCategory) {
      //create a temp product model variable
      selectedProduct = new ModelProduct.Product(
          id: _id,
          name: _nameProduct,
          price: _price,
          description: _description,
          category: _idCategory);
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
                                double.parse(_price),
                                int.parse(_idCategory))));
                      },
                      child: Image.asset(
                        _image,
                      ),
                    ),
                    fit: BoxFit.fill,
                  )),

              //name Product
              Align(
                  alignment: Alignment.center,
                  child: Text(_nameProduct,
                      style: TextStyle(
                          fontSize: 16,
                          color: _fontColor,
                          fontWeight: FontWeight.bold))),

              //Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.attach_money),
                  Text(_price.toString())
                ],
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
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.black),
                        ),
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

    // //return a horizontal list of products Vinyl Category
    // Widget horizontalListProductVinyl(BuildContext context) {
    //   double widthCard = 170;
    //   return new Container(
    //       margin: EdgeInsets.symmetric(vertical: 20.0),
    //       height: MediaQuery.of(context).size.height / 2.5,
    //       child: new ListView(
    //         physics: BouncingScrollPhysics(),
    //         scrollDirection: Axis.horizontal,
    //         children: <Widget>[
    //           Container(
    //             margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //             width: widthCard,
    //             child: createCardProductPaint(
    //                 context,
    //                 'assets/images/Vinyl/vintek-1.png',
    //                 'Vintek',
    //                 '50.00',
    //                 "Descripcion",
    //                 "Vinil"),
    //           ),
    //           Container(
    //             margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //             width: widthCard,
    //             child: createCardProductPaint(
    //                 context,
    //                 'assets/images/Vinyl/realtek.png',
    //                 'Realtek',
    //                 '50.00',
    //                 "Descripcion",
    //                 "Vinil"),
    //           ),
    //           Container(
    //             margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //             width: widthCard,
    //             child: createCardProductPaint(
    //                 context,
    //                 'assets/images/Vinyl/vini.png',
    //                 'Vinipesa',
    //                 '50.00',
    //                 "Descripcion",
    //                 "Vinil"),
    //           ),
    //           Container(
    //             margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //             width: widthCard,
    //             child: createCardProductPaint(
    //                 context,
    //                 'assets/images/Vinyl/vinipesa.png',
    //                 'Vini+',
    //                 '50.00',
    //                 "Descripcion",
    //                 "Vinil"),
    //           ),
    //         ],
    //       ));
    // }

    // //return a horizontal list of products Vinyl Category
    // Widget horizontalListProductEnamels(BuildContext context) {
    //   double widthCard = 170;
    //   return new Container(
    //       margin: EdgeInsets.symmetric(vertical: 20.0),
    //       height: MediaQuery.of(context).size.height / 2.5,
    //       child: new ListView(
    //         physics: BouncingScrollPhysics(),
    //         scrollDirection: Axis.horizontal,
    //         children: <Widget>[
    //           Container(
    //             margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //             width: widthCard,
    //             child: createCardProductPaint(
    //                 context,
    //                 'assets/images/Adhesivos/acribond.png',
    //                 'Brigadier',
    //                 '50.00',
    //                 "Description",
    //                 "Vinyl"),
    //           ),
    //           Container(
    //             margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //             width: widthCard,
    //             child: createCardProductPaint(
    //                 context,
    //                 'assets/images/Adhesivos/pegaso-bond.png',
    //                 'Clasico',
    //                 '50.00',
    //                 "Description",
    //                 "Vinyl"),
    //           ),
    //           Container(
    //             margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //             width: widthCard,
    //             child: createCardProductPaint(
    //                 context,
    //                 'assets/images/Adhesivos/pegaso-tirol.png',
    //                 'Tropimar',
    //                 '50.00',
    //                 "Description",
    //                 "Vinyl"),
    //           ),
    //           Container(
    //             margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //             width: widthCard,
    //             child: createCardProductPaint(
    //                 context,
    //                 'assets/images/Adhesivos/pegaso-yeso.png',
    //                 'Tropimar SUR',
    //                 '50.00',
    //                 "Description",
    //                 "Vinyl"),
    //           ),
    //         ],
    //       ));
    // }

    // //return a horizontal list of products Vinyl Category
    // Widget horizontalListProductWaterproofing(BuildContext context) {
    //   double widthCard = 170;
    //   return new Container(
    //       margin: EdgeInsets.symmetric(vertical: 20.0),
    //       height: MediaQuery.of(context).size.height / 2.5,
    //       child: new ListView(
    //         physics: BouncingScrollPhysics(),
    //         scrollDirection: Axis.horizontal,
    //         children: <Widget>[
    //           Container(
    //             margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //             width: widthCard,
    //             child: createCardProductPaint(
    //                 context,
    //                 'assets/images/Waterproofing/IMPER-CRIL-3D.png',
    //                 'Imper Crill',
    //                 '50.00',
    //                 "Description",
    //                 "Vinyl"),
    //           ),
    //           Container(
    //             margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //             width: widthCard,
    //             child: createCardProductPaint(
    //                 context,
    //                 'assets/images/Waterproofing/IMPER-LUX-3D.png',
    //                 'Imper Lux',
    //                 '50.00',
    //                 "Description",
    //                 "Vinyl"),
    //           ),
    //           Container(
    //             margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //             width: widthCard,
    //             child: createCardProductPaint(
    //                 context,
    //                 'assets/images/Waterproofing/IMPER-MICRO-3D.png',
    //                 'Imper Ruf',
    //                 '50.00',
    //                 "Description",
    //                 "Vinyl"),
    //           ),
    //           Container(
    //             margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //             width: widthCard,
    //             child: createCardProductPaint(
    //                 context,
    //                 'assets/images/Waterproofing/IMPER-RUF-3D.png',
    //                 'Imper Primer',
    //                 '50.00',
    //                 "Description",
    //                 "Vinyl"),
    //           ),
    //         ],
    //       ));
    // }

    //functio that retrieves the data from the api , products by idCategory
    getProductsByIdCategory(String idCategory) async {
      List<dynamic> productsByCategory = new List<dynamic>();

      //if todo retrieves all products order by idCategory
      // if (_currentcategory.name == "Todo") {
      //   for (var category in _idCategory) {
      //     // print(category.name);
      //     if (category.name == "Todo") //avoid the default option
      //       continue;
      //     var url =
      //         globals.apiUrl + 'products/idCategory/' + category.id.toString();
      //     var response = await http.get(url);
      //     //get all the products by category
      //     Map<String, dynamic> data = jsonDecode(' ${response.body}');
      //     //divide products
      //     List<dynamic> jsonProducts = data['data'];
      //     for (var product in jsonProducts) {
      //       productsByCategory.add(product);
      //     }
      //     // print(productsByCategory);
      //     // return productsByCategory;
      //   }
      // } else {
      //retrieve only the given category from parameter
      var url = globals.apiUrl + 'products/idCategory/' + idCategory;
      var response = await http.get(url);
      //Decode json
      //get all the products by category
      Map<String, dynamic> data = jsonDecode(' ${response.body}');
      if (data["status"] == "success") {
        //get products from data
        List<dynamic> jsonProducts = data['data'];
        if (jsonProducts != null)
          for (var product in jsonProducts) {
            productsByCategory.add(product);
          }
      }
      // print(productsByCategory);
      return productsByCategory;
      // }
      // return productsByCategory;
    }

    List<Widget> getProductList(BuildContext context) {
      List<Widget> tempList = new List<Widget>();
      Widget tempWidget;
      //bring all the categories
      if (_currentcategory.name == "Todo") {
        tempWidget = Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.5,
          child:
              //VERTICAL category list loaded from http since initstate
              new ListView.builder(
                  //this list iterate the categoryList that retrieves all the categories from server,
                  //then we search the products related to that category and create a horizontal product list
                  itemCount: _idCategory.length - 1, //to avoid TODO OPTIOM
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Column(
                      children: <Widget>[
                        //Label categorie
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            _idCategory[index + 1].name,
                            style: TextStyle(fontSize: 22, color: _fontColor),
                          ),
                        ),
                        //HORIZONTAL LIST products WITH HTTP FETCH
                        FutureBuilder<List<dynamic>>(
                            future: getProductsByIdCategory(
                                _idCategory[index + 1].id.toString()),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<dynamic>> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return new Text('Input a URL to start');
                                case ConnectionState.waiting:
                                  return new Center(
                                      child: new CircularProgressIndicator());
                                case ConnectionState.active:
                                  return new Text('');
                                case ConnectionState.done:
                                  if (snapshot.hasError) {
                                    return new Text(
                                      '${snapshot.error}',
                                      style: TextStyle(color: Colors.red),
                                    );
                                  } else {
                                    if (snapshot.data != null &&
                                        snapshot.data.length > 0) {
                                      return new Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.5,
                                        child:
                                            //Simula la lista horizontal
                                            ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            //snapshot.data retrieves de Map with the information of the category and product
                                            // print(snapshot.data.length);
                                            // print('Snapshot' +
                                            //     snapshot.data[index]
                                            //         .toString() +
                                            //     "\n");
                                            return Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 0, 10, 0),
                                              width: 170,
                                              child: createCardProductPaint(
                                                  context,
                                                  snapshot.data[index]["_id"],
                                                  'assets/images/Vinyl/vintek-1.png',
                                                  snapshot.data[index]["name"],
                                                  snapshot.data[index]["price"]
                                                      .toString(),
                                                  snapshot.data[index]
                                                      ["description"],
                                                  snapshot.data[index]
                                                      ["idCateogry"]),
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      //if  the category dosent have products or the fetch dosent return data
                                      return new Container(
                                          margin: EdgeInsets.all(50),
                                          height: 100,
                                          child: Text(
                                            'Sin Productos',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ));
                                    }
                                  }
                              }
                            }),
                      ],
                    );
                  }),
        );
      } else {
        //search by specific categorie
        tempWidget = Column(
          children: <Widget>[
            //Label categorie
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                _currentcategory.name,
                style: TextStyle(fontSize: 22, color: _fontColor),
              ),
            ),
            //HORIZONTAL LIST products WITH HTTP FETCH
            FutureBuilder<List<dynamic>>(
                future: getProductsByIdCategory(_currentcategory.id.toString()),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return new Text('Input a URL to start');
                    case ConnectionState.waiting:
                      return new Center(child: new CircularProgressIndicator());
                    case ConnectionState.active:
                      return new Text('');
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return new Text(
                          '${snapshot.error}',
                          style: TextStyle(color: Colors.red),
                        );
                      } else {
                        if (snapshot.data != null && snapshot.data.length > 0) {
                          return new Container(
                            margin: EdgeInsets.symmetric(vertical: 20.0),
                            height: MediaQuery.of(context).size.height / 2.5,
                            child:
                                //Simula la lista horizontal
                                ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                //snapshot.data retrieves de Map with the information of the category and product
                                // print(snapshot.data.length);
                                // print('Snapshot' +
                                //     snapshot.data[index].toString() +
                                //     "\n");
                                return Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  width: 170,
                                  child: createCardProductPaint(
                                      context,
                                      snapshot.data[index]["_id"],
                                      'assets/images/Vinyl/vintek-1.png',
                                      snapshot.data[index]["name"],
                                      snapshot.data[index]["price"].toString(),
                                      snapshot.data[index]["description"],
                                      snapshot.data[index]["idCateogry"]),
                                );
                              },
                            ),
                          );
                        } else {
                          //if  the category dosent have products or the fetch dosent return data
                          return new Container(
                              margin: EdgeInsets.all(50),
                              height: 100,
                              child: Text(
                                'Sin Productos',
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ));
                        }
                      }
                  }
                }),
          ],
        );
      }

      tempList.add(tempWidget);
      return tempList;
    }

    List<Widget> listPaintProducts = getProductList(context);
    void cambiar() {
      setState(() {
        listPaintProducts = getProductList(context);
      });
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
                      value: _currentcategory.name,
                      iconEnabledColor: Colors.black,
                      items: _dropDownMenuItemscategory,
                      onChanged: (Object value) {
                        //search in the _listCategory the currentCategorie changed to get the id
                        Categorie newCategorie = _idCategory
                            .where((categogy) => categogy.name == value)
                            .toList()[0];
                        setState(() {
                          _currentcategory.name = value;
                          _currentcategory.id = newCategorie.id;
                        });
                        listPaintProducts = getProductList(context);
                        setState(() {
                          listPaintProducts = getProductList(context);
                        });
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
                                            size: 20.0,
                                            color: Colors.green[800]),
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
                    //if user its logged
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
