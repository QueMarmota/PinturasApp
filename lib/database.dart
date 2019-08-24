import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pinturasapp/models/User.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:pinturasapp/models/CreditCard.dart';
import 'package:pinturasapp/models/BillingDelivery.dart';
import 'package:pinturasapp/models/cart.dart';

String apiToken;

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  DBProvider() {
    apiToken = null;
  }

  //Function to read from  local storage
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/PinturasLocalData.txt');
  }

  Future<String> readContent() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      // Returning the contents of the file
      apiToken = contents;
      return contents;
    } catch (e) {
      // If encountering an error, return
      return 'Error';
    }
  }

  //fUNCTION THAT writes in localStorage
  Future<File> writeContent(String _apiToken, String email) async {
    apiToken = _apiToken;
    final file = await _localFile;
    // Write the file
    //we save the api_token and the email in local storage
    return file.writeAsString(apiToken + "\n" + email);
  }

  //function to remove from local storage
  Future<File> removeContent() async {
    final file = await _localFile;
    print('Token deleted..');
    return file.writeAsString('');
  }

//DATABASE FUNCTIONS
  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TrackerDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("""
      CREATE TABLE Users(
          idUser INTEGER PRIMARY KEY,
          email TEXT,
          name Text
          )
          """);
      await db.execute("""
      CREATE TABLE BillingDeliverys(
          idBillingDelivery INTEGER PRIMARY KEY,
          billingAddress TEXT,
          deliveryAddress TEXT,
          idUser INTEGER,
          FOREIGN KEY (idUser) REFERENCES Users (idUser) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
          )
          """);
      await db.execute("""
      CREATE TABLE CreditCards(
          number TEXT,
          token TEXT,
          idUser INTEGER,
          FOREIGN KEY (idUser) REFERENCES Users (idUser) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
          )
          """);
      await db.execute("""
      CREATE TABLE Carts(
          idCart INTEGER PRIMARY KEY,
          description TEXT,
          image TEXT,
          price TEXT,
          name TEXT,
          idUser INTEGER,
          FOREIGN KEY (idUser) REFERENCES Users (idUser) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
          )
          """);
    });
  }

  //Functions for USER DML
  newUser(User newUser) async {
    final db = await database;
    //get the biggest idUser in the table
    var table = await db.rawQuery("SELECT MAX(idUser)+1 as idUser FROM Users");
    int idUser = table.first["idUser"];
    var raw = await db.rawInsert(
        "INSERT Into Users (idUser,email,name)"
        " VALUES (?,?,?)",
        [idUser, newUser.email, newUser.name]);
    return raw;
  }

  Future<User> getUserByEmail(String _email) async {
    final db = await database;
    var res = await db.query("Users", where: "email = ?", whereArgs: [_email]);
    return res.isNotEmpty
        ? User.fromMap(res.first)
        : new User(idUser: null, email: null);
  }

  //Functions for creditCard
  newCreditCard(CreditCard newCreditCard) async {
    final db = await database;
    //get the biggest id in the table

    int idCreditCard = DateTime.now().millisecondsSinceEpoch;
    var raw = await db.rawInsert(
        "INSERT Into CreditCards (idCreditCard,number,token,idUser)"
        " VALUES (?,?,?,?)",
        [
          idCreditCard,
          newCreditCard.number,
          newCreditCard.token,
          newCreditCard.idUser
        ]);
    return raw;
  }

  deleteCreditCardById(int idUser, int idCreditCard) async {
    final db = await database;
    return db.delete("CreditCards",
        where: "idUser = ? AND idCreditCard = ?",
        whereArgs: [idUser, idCreditCard]);
  }

  Future<List<CreditCard>> getCreditCards(int idUser) async {
    final db = await database;
    var res =
        await db.query("CreditCards", where: "idUser = ?", whereArgs: [idUser]);
    List<CreditCard> list =
        res.isNotEmpty ? res.map((c) => CreditCard.fromMap(c)).toList() : [];
    return list;
  }

//FunctionS for Billing and Delivery DML
  newBillingDelivery(BillingDelivery newBillingDelivery) async {
    final db = await database;
    //get the biggest idBillingDelivery in the table
    int idBillingDelivery = newBillingDelivery.idBillingDelivery;
    //insert to the table using the new idBillingDelivery
    var raw = await db.rawInsert(
        "INSERT Into BillingDeliverys (idBillingDelivery,billingAddress,deliveryAddress,idUser)"
        " VALUES (?,?,?,?)",
        [
          idBillingDelivery,
          newBillingDelivery.billingAddress,
          newBillingDelivery.deliveryAddress,
          newBillingDelivery.idUser
        ]);
    return raw;
  }

  updateBillingDelivery(BillingDelivery newBillingDelivery) async {
    final db = await database;
    var res = await db.update("BillingDeliverys", newBillingDelivery.toMap(),
        where: "idBillingDelivery = ?",
        whereArgs: [newBillingDelivery.idBillingDelivery]);
    return res;
  }

  deleteBillingDelivery(int idBillingDelivery) async {
    final db = await database;
    return db.delete("BillingDeliverys",
        where: "idBillingDelivery = ?", whereArgs: [idBillingDelivery]);
  }

  //get all the cars from the current user logged
  Future<List<BillingDelivery>> getAllBillingDeliverysForUser(
      int idUser) async {
    final db = await database;
    var res = await db
        .query("BillingDeliverys", where: "idUser = ?", whereArgs: [idUser]);
    List<BillingDelivery> list = res.isNotEmpty
        ? res.map((c) => BillingDelivery.fromMap(c)).toList()
        : [];
    return list;
  }

  //Functions for Cart
  newCart(Cart newCart) async {
    final db = await database;
    //get the biggest idBillingDelivery in the table
    int idCart = DateTime.now().millisecondsSinceEpoch;
    //get the biggest id in the table
    var raw = await db.rawInsert(
        "INSERT Into Carts (idCart,image,name,description,price,idUser)"
        " VALUES (?,?,?,?,?,?)",
        [
          idCart,
          newCart.image,
          newCart.name,
          newCart.description,
          newCart.price,
          newCart.idUser
        ]).catchError((onError) {
      print('error');
      return 0;
    });
    return raw;
  }

  deleteCartById(int idUser, int idCart) async {
    final db = await database;
    db.delete("Carts",
        where: "idUser = ? AND idCart = ?", whereArgs: [idUser, idCart]);
  }

  Future<List<Cart>> getCarts(int idUser) async {
    final db = await database;
    var res = await db.query("Carts", where: "idUser = ?", whereArgs: [idUser]);
    List<Cart> list =
        res.isNotEmpty ? res.map((c) => Cart.fromMap(c)).toList() : [];
    return list;
  }
}
