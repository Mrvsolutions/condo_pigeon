import 'dart:convert';

import 'package:condo_pigeon/Comman/SimpleDialogPage.dart';
import 'package:condo_pigeon/Comman/Util.dart';
import 'package:condo_pigeon/Comman/string.dart';
import 'package:condo_pigeon/api/api.dart';
import 'package:condo_pigeon/model/UserProfile.dart';
import 'package:condo_pigeon/pages/ChangeEmailPage.dart';
import 'package:condo_pigeon/pages/HomePages.dart';
import 'package:condo_pigeon/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VerifyEmailPage extends StatefulWidget {
  final String Username;
 // final String Password;

  VerifyEmailPage(@required this.Username);//, @required this.Password);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _onEditing = true;
  bool _isLoading = false;
  String _code;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   leading:
        // ),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 22.0, 5.0, 20.0),
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: false,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Colors.grey,
                        ),
                       // onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                      child: Text(
                        "Verify Your Email",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18.0, 0, 0, 0),
                      child: Text(
                        "We sent OTP code to your email",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Text(
                      "Enter your code",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 30),
                  VerificationCode(
                    textStyle: TextStyle(fontSize: 20.0, color: Colors.black),
                    keyboardType: TextInputType.number,
                    // in case underline color is null it will use primaryColor: Colors.red from Theme
                    underlineColor: Colors.amber,
                    length: 6,
                    onCompleted: (String value) {
                      setState(() {
                        _code = value;
                      });

                      EasyLoadingToastMessage(context, _code);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => HomePages()),
                      // );
                      if (_code.isNotEmpty) {
                        VerifyEmail(
                            widget.Username, _code, context);
                      } else {
                        EasyLoadingToastMessage(context, StrverificationCode);
                      }
                    },
                    onEditing: (bool value) {
                      //   setState(() {
                      //     _onEditing = value;
                      //   });
                      //   if (!_onEditing) FocusScope.of(context).unfocus();
                    },
                  ),
                  SizedBox(height: 15),
                  Center(
                    // child: RichText(
                    //   text: new TextSpan(
                    //     style: new TextStyle(
                    //       fontSize: 14.0,
                    //       color: Colors.black,
                    //     ),
                    //     children: <TextSpan>[
                    //       new TextSpan(
                    //           text: 'mrv@solutions.com',
                    //           style: new TextStyle(
                    //               fontSize: 16, fontWeight: FontWeight.w500)),
                    //       new TextSpan(
                    //           text: ' is not your email?',
                    //           style: TextStyle(fontSize: 16)),
                    //     ],
                    //   ),
                    // ),
                    child: Text(
                        "Not recieved verification code?",
                        textAlign: TextAlign.left,
                        style:
                        TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: FlatButton(
                      onPressed: () {
                        //TODO FORGOT PASSWORD SCREEN GOES HERE
                        ResendVerificationCode( widget.Username,context);

                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Resend Code",
                          textAlign: TextAlign.left,
                          style:
                          TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      builder: EasyLoading.init(),
    );
  }

  VerifyEmail(String email, String VerificationCode,
      BuildContext context) async {
    EasyLoading.show(status: 'Please wait for verification...');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'resident_email': email,
      'signup_verificationcode': VerificationCode
    };
    var jsonResponse = null;
    var url = Uri.parse(VerifyEmailCodeAPI);
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        EasyLoading.dismiss();
        setState(() {
          _isLoading = false;
        });
        if (jsonResponse['success'] == 1) {
          sharedPreferences.setString("message", VERIFICATION_COMPLETE);
          showDialog(context: context,
              builder: (BuildContext context) {
                return SimpleDialogPage(StrSignupVerificaionMessage);
              });
        } else {
          EasyLoadingToastMessage(context, jsonResponse['message']);
        }
      }
    } else {
      EasyLoading.dismiss();
      print(response.body);
    }
  }
  ResendVerificationCode(String email,
      BuildContext context) async {
    EasyLoading.show(status: 'Please wait...');
    Map data = {
      'resident_email': email,
    };
    var jsonResponse = null;
    var url = Uri.parse(ResendVerificationCodeAPI);
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        EasyLoading.dismiss();
        setState(() {
          _isLoading = false;
        });
        if (jsonResponse['success'] == 1) {
          EasyLoadingToastMessage(context, jsonResponse['message']);
        } else {
          EasyLoadingToastMessage(context, jsonResponse['message']);
        }
      }
    } else {
      EasyLoading.dismiss();
      print(response.body);
    }
  }
}
