import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Dialogs {
  creditCard(BuildContext context) {
    var cardNumber = TextEditingController();
    var month = TextEditingController();
    var year = TextEditingController();
    var cvv = TextEditingController();
    double heightButtons;
    //variable for the form
    final _formKey = GlobalKey<FormState>();
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    double _fontSize;

    EdgeInsets paddingTextField;

    Color _inputColor;

    Color _fontColor;
    FocusNode f1 = FocusNode();
    FocusNode f2 = FocusNode();
    FocusNode f3 = FocusNode();
    FocusNode f4 = FocusNode();

    Widget textFormFieldAddCard(BuildContext context) {
      return Container(
          margin: EdgeInsets.only(bottom: 5, top: 5),
          width: MediaQuery.of(context).size.width,
          child: Column(children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Numero de tarjeta',
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
              style: TextStyle(color: Colors.blue, fontSize: _fontSize),
              decoration: InputDecoration(
                  counterText: "",
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 5)),
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
              style: TextStyle(color: Colors.blue, fontSize: _fontSize),
              decoration: InputDecoration(
                  counterText: "",
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  fillColor: Colors.white,
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
                  LengthLimitingTextInputFormatter(2),
                ],
                focusNode: f3,
                maxLength: 2,
                onChanged: (String newVal) {
                  if (newVal.length == 2) {
                    f3.unfocus();
                    FocusScope.of(context).requestFocus(f4);
                  }
                },
                keyboardType: TextInputType.number,
                controller: year,
                style: TextStyle(color: Colors.blue, fontSize: _fontSize),
                decoration: InputDecoration(
                    counterText: "",
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    fillColor: Colors.white,
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
                LengthLimitingTextInputFormatter(4),
              ],
              maxLength: 4,
              focusNode: f4,
              keyboardType: TextInputType.number,
              controller: cvv,
              style: TextStyle(color: Colors.blue, fontSize: _fontSize),
              decoration: InputDecoration(
                  counterText: "",
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  fillColor: Colors.white,
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

    Widget addCardButton(BuildContext context) {
      return Container(
          margin: EdgeInsets.only(top: 10),
          child: ButtonTheme(
            minWidth: MediaQuery.of(context).size.width / 2,
            child: RaisedButton(
              //ON PRESSED FUNCTION , THIS IS IMPLEMENTATION IS TO AVOID MULTI TAPPING ON THE BUTTON
              onPressed: () {},
              color: Colors.blue,
              shape: new RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black),
                  borderRadius: new BorderRadius.circular(10.0)),
              child: new Text(
                'Pagar',
                style: new TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ));
    }

    //Return the dialog
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                // use container to change width and height
                height: 270,
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 50,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/ae.jpg',
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 50,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/mastercard-logo.png',
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 50,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/visa.jpg',
                          ),
                        ),
                      ],
                    ),
                    textFormFieldAddCard(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        textFieldMonth(context),
                        textFieldYear(context),
                        textFieldCVV(context),
                      ],
                    ),
                    addCardButton(context),
                    // Text("Mensaje")
                  ],
                ),
              ),
            );
          },
        );
      },
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
