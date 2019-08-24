import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinturasapp/screens/signin.dart';
import 'package:pinturasapp/screens/home.dart';
import 'package:pinturasapp/database.dart';
import 'package:pinturasapp/globals.dart' as globals;
import 'package:pinturasapp/models/User.dart';

String apiToken;

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email = TextEditingController();
  var password = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //variable for the form
  final _formKey = GlobalKey<FormState>();
  //variables for responsive
  double _fontSize = 10;
  EdgeInsets paddingTextField = EdgeInsets.fromLTRB(10, 10, 10, 10);
  double heightButtons = 30;

  //Functions size screen responsive
  Widget sizeScreen480x640(BuildContext context) {
    return Stack(
      children: <Widget>[
        // backgroundImage(context),
        SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4.5,
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'images/bucket_logo.png',
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      formTextBoxEmail(context),
                      formTextBoxPassword(context),
                    ],
                  ),
                ),
              ),

              //Buttons
              Container(
                height: MediaQuery.of(context).size.height / 3,
                margin: EdgeInsets.only(top: 0),
                alignment: Alignment.center,
                child: buttons(context),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget sizeScreen720x1280(BuildContext context) {
    return Stack(
      children: <Widget>[
        // backgroundImage(context),
        SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4.5,
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'images/bucket_logo.png',
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      formTextBoxEmail(context),
                      formTextBoxPassword(context),
                    ],
                  ),
                ),
              ),

              //Buttons
              Container(
                height: MediaQuery.of(context).size.height / 4,
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: buttons(context),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget sizeScreen1200x1920(BuildContext context) {
    return Stack(
      children: <Widget>[
        // backgroundImage(context),
        SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'images/bucket_logo.png',
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height / 3.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      formTextBoxEmail(context),
                      formTextBoxPassword(context),
                    ],
                  ),
                ),
              ),

              //Buttons
              Container(
                height: MediaQuery.of(context).size.height / 4,
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.bottomCenter,
                child: buttons(context),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //disable screen rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Iniciar sesión'),
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
    );
  }

  //Widgets

  Widget backgroundImage(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.grey.withOpacity(0.5), BlendMode.dstOut),
          image: ExactAssetImage('assets/images/bg3.png'),
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget formTextBoxEmail(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Correo',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: _fontSize,
                  fontFamily: 'Roboto'),
            ),
          ),
          TextFormField(
              style: TextStyle(
                  color: Colors.black,
                  fontSize: _fontSize,
                  fontFamily: 'Roboto'),
              controller: email,
              validator: (email) {
                if (email == "") {
                  return 'Falta llenar campo';
                } else if (checkEmail(email)) {
                  return 'Error en el correo';
                }
              },
              decoration: InputDecoration(
                  errorStyle:
                      TextStyle(fontSize: _fontSize - 5, fontFamily: 'Roboto'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: paddingTextField,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan)),
                  alignLabelWithHint: true,
                  hintText: 'Escribe tu correo',
                  hintStyle:
                      TextStyle(color: Colors.grey, fontFamily: 'Roboto'))),
        ],
      ),
    );
  }

  Widget formTextBoxPassword(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Contraseña',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: _fontSize,
                  fontFamily: 'Roboto'),
            ),
          ),
          TextFormField(
              obscureText: true,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: _fontSize,
                  fontFamily: 'Roboto'),
              controller: password,
              validator: (password) {
                if (password == "") {
                  return 'Falta llenar campo';
                }
              },
              decoration: InputDecoration(
                  errorStyle:
                      TextStyle(fontSize: _fontSize - 5, fontFamily: 'Roboto'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: paddingTextField,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan)),
                  alignLabelWithHint: true,
                  hintText: '**********',
                  hintStyle:
                      TextStyle(color: Colors.grey, fontFamily: 'Roboto'))),
        ],
      ),
    );
  }

  //action login button function
  void loginButtonPressed() async {
    // Dialogs dialog = new Dialogs();
    if (_formKey.currentState.validate()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Verificando',
          style: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
        ),
        duration: Duration(seconds: 1),
      ));
      //Codigo provisional antes de esto hay que checar en el servidor si el usuario existe
      DBProvider db = new DBProvider();
      db.writeContent("_apiToken", "email");
      globals.setApiToken("_apiToken");
      //   //chech if user exist in local DB
      Future<User> checkUser = DBProvider.db.getUserByEmail(email.text);
      //if user dosent exists
      checkUser.then((result) async {
        //if user dosent  exist then create
        if (result.email == null && result.idUser == null) {
          // create in table Users the new user
          User newUser = User(email: email.text, name: 'Nombre');
          await DBProvider.db.newUser(newUser);
        }
        //Send to index screen
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
      }).catchError((onError) {});

      // var url = globals.apiUrl + 'login';
      // var response = await http.post(url,
      //     body: {'email': '${email.text}', 'password': '${password.text}'});
      // //Decode json
      // Map<String, dynamic> data = jsonDecode(' ${response.body}');
      // if ('${data['status']}' != 'error') {
      //   //if not errors from server
      //   apiToken = '${data['data']['api_token']}';
      //   //save in local storage the email and api_token
      //   writeContent();
      //   //chech if user exist in local DB
      //   Future<User> checkUser = DBProvider.db.getUserByEmail(email.text);
      //   //if user dosent exists
      //   checkUser.then((result) async {
      //     //if user dosent  exist then create
      //     if (result.email == null && result.idUser == null) {
      //       // create in table Users the new user
      //       User newUser =
      //           User(email: email.text, name: '${data['data']['name']}');
      //       await DBProvider.db.newUser(newUser);
      //     }
      //     //Send to index screen
      //     Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => Index(),
      //         ));
      //   }).catchError((onError) {});
      // } else if ('${data['message']}' ==
      //     "Favor de checar su email y validar su cuenta.") {
      //   //we send email and password cuz we can resend email or not
      //   dialog.emailConfirmation(
      //       context,
      //       'Cuenta Inactiva',
      //       'Activa tu cuenta desde el\nenlace que te enviamos\npor correo',
      //       email.text,
      //       password.text);
      // } else {
      //   //if errorfrom server
      //   dialog.error(
      //       context, 'Datos invalidos', 'Verifica tu usuario\no contraseña');
      //   await Future.delayed(Duration(milliseconds: 2500));
      //   Navigator.of(context, rootNavigator: true).pop('dialog');
      // }
    } else {
      //FORMULARIO NO VALIDO
    }
    setState(() => _isButtonTapped =
        !_isButtonTapped); //tapping the button once, disables the button from being tapped again
  }

  bool _isButtonTapped = false;
  //function called when login buttons its hit
  _onTappedLoggin() {
    if (_formKey.currentState.validate()) {
      setState(() => _isButtonTapped =
          !_isButtonTapped); //tapping the button once, disables the button from being tapped again
      //DO DE LOGIN FUNCTION
      loginButtonPressed();
    }
  }

  Widget buttons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 10),
            child: ButtonTheme(
              height: heightButtons,
              minWidth: MediaQuery.of(context).size.width / 2,
              child: RaisedButton(
                //ON PRESSED FUNCTION , THIS IS IMPLEMENTATION IS TO AVOID MULTI TAPPING ON THE BUTTON
                onPressed: _isButtonTapped ? null : _onTappedLoggin,
                color: Colors.blue,
                shape: new RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black),
                    borderRadius: new BorderRadius.circular(10.0)),
                child: new Text(
                  'Login',
                  style: new TextStyle(
                    fontFamily: "Roboto",
                    fontSize: _fontSize,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
        Container(
            child: ButtonTheme(
          height: heightButtons,
          minWidth: MediaQuery.of(context).size.width / 2,
          child: RaisedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingIn(),
                  ));
            },
            color: Colors.blue,
            shape: new RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
                borderRadius: new BorderRadius.circular(10.0)),
            child: new Text(
              'Registro',
              style: new TextStyle(
                fontFamily: "Roboto",
                fontSize: _fontSize,
                color: Colors.white,
              ),
            ),
          ),
        ))
      ],
    );
  }

  bool checkEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }
}
