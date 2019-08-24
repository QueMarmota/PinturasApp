import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinturasapp/database.dart';
import 'package:pinturasapp/models/BillingDelivery.dart';

List<BillingDelivery> storedInfo;

class DeliveryBilling extends StatefulWidget {
  DeliveryBilling({Key key}) : super(key: key);

  _DeliveryBillingState createState() => _DeliveryBillingState();
}

class _DeliveryBillingState extends State<DeliveryBilling> {
  Color _fontColor = Colors.black;
  double _fontSize;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var billingAddress = TextEditingController();
  var indoorBilling = TextEditingController();
  var outdoorBilling = TextEditingController();
  var deliveryAddress = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  EdgeInsets paddingTextField;
  double heightButtons;
  var outdoorDeliver = TextEditingController();
  var indoorDeliver = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    DBProvider db = new DBProvider();
    db.getAllBillingDeliverysForUser(0).then((onValue) {
      storedInfo = onValue;
      billingAddress.text = onValue.elementAt(0).billingAddress.split("_")[0];
      indoorBilling.text = onValue.elementAt(0).billingAddress.split("_")[1];
      outdoorBilling.text = onValue.elementAt(0).billingAddress.split("_")[2];

      deliveryAddress.text = onValue.elementAt(0).deliveryAddress.split("_")[0];
      indoorDeliver.text = onValue.elementAt(0).deliveryAddress.split("_")[1];
      outdoorDeliver.text = onValue.elementAt(0).deliveryAddress.split("_")[2];
    }).catchError((onError) {
      print(onError);
    });
    super.initState();
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
        title: Text('Facturación y Entrega'),
        backgroundColor: Colors.red,
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
          // image: DecorationImage(
          //   colorFilter: new ColorFilter.mode(
          //       Colors.grey.withOpacity(0.5), BlendMode.dstOut),
          //   image: ExactAssetImage('assets/images/bg3.png'),
          //   fit: BoxFit.fill,
          //   alignment: Alignment.topCenter,
          // ),
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
              'Dirección de Entrega',
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
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  fillColor: Colors.white,
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
            onPressed: _isButtonTapped ? null : _onTappedFunction,
            color: Colors.blue,
            shape: new RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
                borderRadius: new BorderRadius.circular(10.0)),
            child: new Text(
              'Actualizar',
              style: new TextStyle(
                fontFamily: "Roboto",
                fontSize: _fontSize,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }

  bool _isButtonTapped = false;
  //function called when pay buttons its hit
  _onTappedFunction() {
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
        'Actualizado',
        style: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
      ),
      duration: Duration(seconds: 1),
    ));
    //ADD A PRODUCT TO THE CART local database
    DBProvider db = new DBProvider();
    //format the stored string as Address _ outdoor number _ indoor number
    String deliver = deliveryAddress.text +
        "_" +
        indoorDeliver.text +
        "_" +
        outdoorDeliver.text;
    //format the stored string as Address _ outdoor number _ indoor number
    String billing = billingAddress.text +
        "_" +
        indoorBilling.text +
        "_" +
        outdoorBilling.text;
    if (storedInfo.length < 0) {
      db.newBillingDelivery(new BillingDelivery(
          idBillingDelivery: 0,
          billingAddress: billing,
          deliveryAddress: deliver,
          idUser: 0));
    } else {
      //update by removing and adding
      db.deleteBillingDelivery(0);
      db.newBillingDelivery(new BillingDelivery(
          idBillingDelivery: 0,
          billingAddress: billing,
          deliveryAddress: deliver,
          idUser: 0));
    }

    //Codigo provisional

    // } else {
    //FORMULARIO NO VALIDO
    // }

    await Future.delayed(Duration(milliseconds: 1000));

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
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  fillColor: Colors.white,
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

  Widget indoorBillingTextFormWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Numero interior',
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
              controller: indoorBilling,
              validator: (indoorBilling) {
                if (indoorBilling == "") {
                  return 'Falta llenar campo';
                }
              },
              decoration: InputDecoration(
                  errorStyle: TextStyle(fontSize: 10, fontFamily: 'Roboto'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: paddingTextField,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan)),
                  alignLabelWithHint: true,
                  hintText: 'Escribe numero',
                  hintStyle:
                      TextStyle(color: Colors.grey, fontFamily: 'Roboto'))),
        ],
      ),
    );
  }

  Widget outdoorBillingTextFormWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Numero exterior',
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
              controller: outdoorBilling,
              validator: (outdoorBilling) {
                if (outdoorBilling == "") {
                  return 'Falta llenar campo';
                }
              },
              decoration: InputDecoration(
                  errorStyle:
                      TextStyle(fontSize: _fontSize, fontFamily: 'Roboto'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: paddingTextField,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan)),
                  alignLabelWithHint: true,
                  hintText: 'Escribe numero',
                  hintStyle:
                      TextStyle(color: Colors.grey, fontFamily: 'Roboto'))),
        ],
      ),
    );
  }

  Widget indoorDeliverTextFormWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Numero interior',
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
              controller: indoorDeliver,
              validator: (indoorDeliver) {
                if (indoorDeliver == "") {
                  return 'Falta llenar campo';
                }
              },
              decoration: InputDecoration(
                  errorStyle: TextStyle(fontSize: 10, fontFamily: 'Roboto'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: paddingTextField,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan)),
                  alignLabelWithHint: true,
                  hintText: 'Escribe numero',
                  hintStyle:
                      TextStyle(color: Colors.grey, fontFamily: 'Roboto'))),
        ],
      ),
    );
  }

  Widget outdoorDeliverTextFormWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Numero exterior',
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
              controller: outdoorDeliver,
              validator: (outdoorDeliver) {
                if (outdoorDeliver == "") {
                  return 'Falta llenar campo';
                }
              },
              decoration: InputDecoration(
                  errorStyle:
                      TextStyle(fontSize: _fontSize, fontFamily: 'Roboto'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: paddingTextField,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan)),
                  alignLabelWithHint: true,
                  hintText: 'Escribe numero',
                  hintStyle:
                      TextStyle(color: Colors.grey, fontFamily: 'Roboto'))),
        ],
      ),
    );
  }

  Widget sizeScreen480x640(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          billingAddressTextFormWidget(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              indoorBillingTextFormWidget(context),
              outdoorBillingTextFormWidget(context)
            ],
          ),
          deliveryAddressTextFormWidget(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              indoorDeliverTextFormWidget(context),
              outdoorDeliverTextFormWidget(context)
            ],
          ),
          updateButton(context),
        ],
      ),
    );
  }

  Widget sizeScreen720x1280(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          billingAddressTextFormWidget(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              indoorBillingTextFormWidget(context),
              outdoorBillingTextFormWidget(context)
            ],
          ),
          deliveryAddressTextFormWidget(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              indoorDeliverTextFormWidget(context),
              outdoorDeliverTextFormWidget(context)
            ],
          ),
          updateButton(context),
        ],
      ),
    );
  }

  Widget sizeScreen1200x1920(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          billingAddressTextFormWidget(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              indoorBillingTextFormWidget(context),
              outdoorBillingTextFormWidget(context)
            ],
          ),
          deliveryAddressTextFormWidget(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              indoorDeliverTextFormWidget(context),
              outdoorDeliverTextFormWidget(context)
            ],
          ),
          updateButton(context),
        ],
      ),
    );
  }
}
