import 'package:condo_pigeon/pages/LoginPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ForgotDialogPage extends StatelessWidget {
  final title;

  ForgotDialogPage(this.title);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Please check your email.',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black),),
      content: RichText(
        text: new TextSpan(
          style: new TextStyle(
            fontSize: 14.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            new TextSpan(
                text: 'If an account with ',
                style: new TextStyle(fontSize: 16)),
            new TextSpan(
                text: title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
               ),
            new TextSpan(
              text: ' exists you should  receive a link to reset your password.\n\n\nIf you don\'t see an email within 5 minutes, please check your spam folder.',
              style: TextStyle(
                  fontSize: 16),
            ),
          ],
        ),
      ),
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