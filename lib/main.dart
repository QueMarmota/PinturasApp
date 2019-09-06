import 'dart:io';
import 'package:pinturasapp/screens/home.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:pinturasapp/database.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:pinturasapp/globals.dart' as globals;
import 'package:pinturasapp/screens/shoppingCart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Roboto'),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //function to override back button android function
  @override
  void dispose() {
    super.dispose();
  }

  bool checkIfIsLogged() {
    DBProvider db = new DBProvider();
    db.readContent().then((onValue) {
      print(onValue);
      globals.setApiToken(onValue); 
      return true;
    });
    return false;
  }

  navigateToHome() async {
    //give a sec while flutter render the current view(the current view its a black container)
    await Future.delayed(Duration(seconds: 1));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ShoppingCart(),
        ));
  }

  @override
  void initState() {
    super.initState();
    //read from localstorage email and password if exists auto login
    checkIfIsLogged();
    //Navigate to Home
    navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }
}
