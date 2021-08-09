import 'package:condo_pigeon/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SimpleDialogPage extends StatelessWidget {
  final title;

  SimpleDialogPage(this.title);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //title: Text('Alert'),
      content: Text(title,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text("OK",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
          onPressed: () {

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                    (Route<dynamic> route) => false);
          },
        ),
      ],
    );
  }
}