import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeliveryBilling extends StatefulWidget {
  DeliveryBilling({Key key}) : super(key: key);

  _DeliveryBillingState createState() => _DeliveryBillingState();
}

class _DeliveryBillingState extends State<DeliveryBilling> {
  Color _fontColor = Colors.black;
  double _fontSize;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var billingAddress = TextEditingController();
  var deliveryAddress = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  EdgeInsets paddingTextField;

  double heightButtons;

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
        title: Text('Facturación y Entrega'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: <Widget>[
          backgroundImage(context),
          Theme(
            data: ThemeData(accentColor: Colors.blue, fontFamily: 'Roboto'),
            child: SafeArea(
                minimum: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: ListView(
                  children: <Widget>[
                    LayoutBuilder(
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
                          paddingTextField =
                              EdgeInsets.fromLTRB(10, 10, 10, 10);
                          return sizeScreen720x1280(context);
                        } else {
                          _fontSize = 20;
                          heightButtons = 40;
                          paddingTextField =
                              EdgeInsets.fromLTRB(10, 15, 10, 10);
                          return sizeScreen1200x1920(context);
                        }
                      },
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  backgroundImage(BuildContext context) {
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

  Widget deliveryAddressTextFormWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Dirección de facturacion',
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
              controller: deliveryAddress,
              validator: (deliveryAddress) {
                if (deliveryAddress == "") {
                  return 'Falta llenar campo';
                }
              },
              decoration: InputDecoration(
                  errorStyle:
                      TextStyle(fontSize: _fontSize, fontFamily: 'Roboto'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.0),
                  ),
                  fillColor: Colors.blue,
                  filled: true,
                  contentPadding: paddingTextField,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan)),
                  alignLabelWithHint: true,
                  hintText: 'Escribe calle',
                  hintStyle:
                      TextStyle(color: Colors.grey, fontFamily: 'Roboto'))),
        ],
      ),
    );
  }

  Widget updateButton(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: ButtonTheme(
          height: heightButtons,
          minWidth: MediaQuery.of(context).size.width / 2,
          child: RaisedButton(
            //ON PRESSED FUNCTION , THIS IS IMPLEMENTATION IS TO AVOID MULTI TAPPING ON THE BUTTON
            onPressed: _isButtonTapped ? null : _onTappedLoggin,
            color: Colors.green,
            shape: new RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
                borderRadius: new BorderRadius.circular(10.0)),
            child: new Text(
              'Actualizar',
              style: new TextStyle(
                fontFamily: "Roboto",
                fontSize: _fontSize,
                color: Colors.blue,
              ),
            ),
          ),
        ));
  }

  bool _isButtonTapped = false;
  //function called when pay buttons its hit
  _onTappedLoggin() {
    // if (_formKey.currentState.validate()) {
    setState(() => _isButtonTapped =
        !_isButtonTapped); //tapping the button once, disables the button from being tapped again
    //DO DE pay FUNCTION
    updateButtonPressed();
    // }
  }

  //action pay button function
  void updateButtonPressed() async {
    // if (_formKey.currentState.validate()) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        'Verificando',
        style: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
      ),
      duration: Duration(seconds: 1),
    ));
    //Disabe button
    _isButtonTapped = !_isButtonTapped;
    //Codigo provisional

    // } else {
    //FORMULARIO NO VALIDO
    // }
    setState(() => _isButtonTapped =
        !_isButtonTapped); //tapping the button once, disables the button from being tapped again
  }

  Widget billingAddressTextFormWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Dirección de facturacion',
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
              controller: billingAddress,
              validator: (billingAddress) {
                if (billingAddress == "") {
                  return 'Falta llenar campo';
                }
              },
              decoration: InputDecoration(
                  errorStyle:
                      TextStyle(fontSize: _fontSize, fontFamily: 'Roboto'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.0),
                  ),
                  fillColor: Colors.blue,
                  filled: true,
                  contentPadding: paddingTextField,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan)),
                  alignLabelWithHint: true,
                  hintText: 'Escribe calle',
                  hintStyle:
                      TextStyle(color: Colors.grey, fontFamily: 'Roboto'))),
        ],
      ),
    );
  }

  Widget sizeScreen480x640(BuildContext context) {}

  Widget sizeScreen720x1280(BuildContext context) {}

  Widget sizeScreen1200x1920(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.3,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          billingAddressTextFormWidget(context),
          deliveryAddressTextFormWidget(context),
          updateButton(context),
        ],
      ),
    );
  }
}
