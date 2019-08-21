import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool privateEvent = false;

double _fontSize = 18;

class Payment extends StatefulWidget {
  Payment({Key key}) : super(key: key);

  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  var cardNumber = TextEditingController();
  var month = TextEditingController();
  var year = TextEditingController();
  var cvv = TextEditingController();
  double heightButtons;
  var postalCode = TextEditingController();
  var street = TextEditingController();
  var subUrb = TextEditingController();
  //variable for the form
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  EdgeInsets paddingTextField;

  Color _inputColor;

  Color _fontColor;
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
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
        title: Text('Pago'),
        backgroundColor: Colors.black,
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

  Widget payButton(BuildContext context) {
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
              'Pagar',
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
    if (_formKey.currentState.validate()) {
      setState(() => _isButtonTapped =
          !_isButtonTapped); //tapping the button once, disables the button from being tapped again
      //DO DE pay FUNCTION
      payButtonPressed();
    }
  }

  //action pay button function
  void payButtonPressed() async {
    if (_formKey.currentState.validate()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Verificando',
          style: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
        ),
        duration: Duration(seconds: 1),
      ));
      //Codigo provisional

    } else {
      //FORMULARIO NO VALIDO
    }
    setState(() => _isButtonTapped =
        !_isButtonTapped); //tapping the button once, disables the button from being tapped again
  }

  Widget streetTextFormWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Calle y número',
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
              controller: street,
              validator: (street) {
                if (street == "") {
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

  Widget subUrbTextFormWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Colonía',
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
              controller: subUrb,
              validator: (subUrb) {
                if (subUrb == "") {
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
                  hintText: 'Escribe colonía',
                  hintStyle:
                      TextStyle(color: Colors.grey, fontFamily: 'Roboto'))),
        ],
      ),
    );
  }

  Widget postalCodeTextFormWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Codigo Postal',
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
              controller: postalCode,
              validator: (postalCode) {
                if (postalCode == "") {
                  return 'Falta llenar campo';
                } else if (checkPostalCode(postalCode)) {
                  return 'Error en el codigo postal';
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
                  hintText: 'Escribe codigo postal',
                  hintStyle:
                      TextStyle(color: Colors.grey, fontFamily: 'Roboto'))),
        ],
      ),
    );
  }

  Widget checkBoxBillingDelivery(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          activeColor: _inputColor,
          checkColor: _inputColor,
          value: privateEvent,
          onChanged: (bool value) {
            setState(() {
              privateEvent = value;
            });
          },
        ),
        Text(
          'Utilizar datos de\nFacturaciòn y entrega',
          style: TextStyle(fontSize: _fontSize, color: _fontColor),
        )
      ],
    );
  }

  Widget textFormFieldAddCard(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 5, top: 5),
        width: MediaQuery.of(context).size.width,
        child: Column(children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Agregar tarjeta*',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: _fontSize,
                  fontFamily: 'Gotham_book'),
            ),
          ),
          TextField(
            focusNode: f1,
            onChanged: (String newVal) {
              if (newVal.length == 19) {
                f1.unfocus();
                FocusScope.of(context).requestFocus(f2);
              }
            },
            controller: cardNumber,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white, fontSize: _fontSize),
            decoration: InputDecoration(
                counterText: "",
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                fillColor: Colors.blue,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0)),
                alignLabelWithHint: false,
                hintText: 'xxxx-xxxx-xxxx-4242',
                hintStyle: TextStyle(
                    color: Colors.grey[700],
                    fontFamily: 'Gotham_book',
                    fontSize: _fontSize)),
            inputFormatters: [
              MaskedTextInputFormatter(
                mask: 'xxxx-xxxx-xxxx-xxxx',
                separator: '-',
              ),
            ],
          ),
        ]));
  }

  Widget textFieldMonth(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      child: Column(children: <Widget>[
        Text(
          'Mes',
          style: TextStyle(
              color: Colors.blue,
              fontSize: _fontSize,
              fontFamily: 'Gotham_book'),
        ),
        TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            focusNode: f2,
            maxLength: 1,
            onChanged: (String newVal) {
              if (newVal.length == 1) {
                f2.unfocus();
                FocusScope.of(context).requestFocus(f3);
              }
            },
            keyboardType: TextInputType.number,
            controller: month,
            style: TextStyle(color: Colors.white, fontSize: _fontSize),
            decoration: InputDecoration(
                counterText: "",
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                fillColor: Colors.blue,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0)),
                alignLabelWithHint: false,
                hintText: '6',
                hintStyle: TextStyle(
                    color: Colors.grey[700],
                    fontFamily: 'Gotham_book',
                    fontSize: _fontSize))),
      ]),
    );
  }

  Widget textFieldYear(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width / 4,
        child: Column(children: <Widget>[
          Text(
            'Año',
            style: TextStyle(
                color: Colors.blue,
                fontSize: _fontSize,
                fontFamily: 'Gotham_book'),
          ),
          TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              focusNode: f3,
              onChanged: (String newVal) {
                if (newVal.length == 2) {
                  f3.unfocus();
                  FocusScope.of(context).requestFocus(f4);
                }
              },
              maxLength: 2,
              keyboardType: TextInputType.number,
              controller: year,
              style: TextStyle(color: Colors.white, fontSize: _fontSize),
              decoration: InputDecoration(
                  counterText: "",
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  fillColor: Colors.blue,
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0)),
                  alignLabelWithHint: false,
                  hintText: '22',
                  hintStyle: TextStyle(
                      color: Colors.grey[700],
                      fontFamily: 'Gotham_book',
                      fontSize: _fontSize)))
        ]));
  }

  Widget textFieldCVV(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: MediaQuery.of(context).size.width / 4,
      child: Column(children: <Widget>[
        Text(
          'CVV',
          style: TextStyle(
              color: Colors.blue,
              fontSize: _fontSize,
              fontFamily: 'Gotham_book'),
        ),
        TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            maxLength: 4,
            focusNode: f4,
            keyboardType: TextInputType.number,
            controller: cvv,
            style: TextStyle(color: Colors.white, fontSize: _fontSize),
            decoration: InputDecoration(
               counterText: "",
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                fillColor: Colors.blue,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0)),
                alignLabelWithHint: false,
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Gotham_book',
                    fontSize: _fontSize))),
      ]),
    );
  }

  bool checkPostalCode(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }

  Widget sizeScreen480x640(BuildContext context) {}

  Widget sizeScreen720x1280(BuildContext context) {}

  Widget sizeScreen1200x1920(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          postalCodeTextFormWidget(context),
          streetTextFormWidget(context),
          subUrbTextFormWidget(context),
          checkBoxBillingDelivery(context),
          textFormFieldAddCard(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              textFieldMonth(context),
              textFieldYear(context),
              textFieldCVV(context),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: payButton(context),
          )
        ],
      ),
    );
  }
}

//class for textform credit card format
class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    @required this.mask,
    @required this.separator,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
