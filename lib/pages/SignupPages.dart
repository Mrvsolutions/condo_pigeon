import 'dart:convert';

import 'package:condo_pigeon/Comman/Util.dart';
import 'package:condo_pigeon/Comman/string.dart';
import 'package:condo_pigeon/api/api.dart';
import 'package:condo_pigeon/pages/LoginPage.dart';
import 'package:condo_pigeon/pages/VerifyEmailPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignupPages extends StatefulWidget {
  @override
  _SignupPagesState createState() => _SignupPagesState();
}

class _SignupPagesState extends State<SignupPages> {
  // bool _onEditing = true;
  // String _code;
  String name, email, password;
  bool _isLoading = false;
  var reg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  TextEditingController _aptNoController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _contactController = new TextEditingController();
  TextEditingController _applicationCodeController =
      new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _cnfPassController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   leading:
        // ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 25.0, 5.0, 20.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                          child: Text(
                            "Sign up for a new account.",
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
                            "We just need some more information.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 10, 32, 32),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return StrEnterAptNo;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: "Enter apartment no",
                                  labelText: "Apartment No"),
                              controller: _aptNoController,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return StrEnterName;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: "Enter Name", labelText: "Name"),
                              controller: _nameController,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return StrEnterContactNo;
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: "Enter Mobile no",
                                  labelText: "Contact No"),
                              controller: _contactController,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return StrEnterApplicationCode;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _applicationCodeController.value =
                                    TextEditingValue(
                                        text: value.toUpperCase(),
                                        selection: _applicationCodeController
                                            .selection);
                              },
                              decoration: InputDecoration(
                                  hintText: "Enter Application Code",
                                  labelText: "Application Code"),
                              controller: _applicationCodeController,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return StrEnterEmailId;
                                } else if (value.isNotEmpty &&
                                    !reg.hasMatch(value)) {
                                  return StrEnterValidEmailId;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: "Enter Email-Id",
                                  labelText: "Email-Id"),
                              controller: _emailController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return StrEnterPassword;
                                } else if (value.length < 6) {
                                  return StrValidPass;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Enter Password",
                                labelText: "Password",
                              ),
                              controller: _passwordController,
                              obscureText: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return StrEnterConfmpass;
                                } else if (value.length < 6) {
                                  return StrValidPass;
                                } else if (_passwordController.text !=
                                    _cnfPassController.text) {
                                  return StrnotmatchPassword;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Enter Confirm Password",
                                labelText: "Confirm Password",
                              ),
                              controller: _cnfPassController,
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: RaisedButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => LoginPage()),
                              // );
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus &&
                                  currentFocus.focusedChild != null) {
                                currentFocus.focusedChild.unfocus();
                              }
                              if (SignupValidation()) {
                                Signup(
                                    _aptNoController.text,
                                    _nameController.text,
                                    _contactController.text,
                                    _applicationCodeController.text,
                                    _emailController.text,
                                    _passwordController.text);
                              }
                            },
                            child: Text("SIGN UP"),
                            color: Colors.lightBlue,
                            textColor: Colors.white,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: RichText(
                            text: new TextSpan(
                              style: new TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                    text: 'Already have an account?',
                                    style: new TextStyle(fontSize: 16)),
                                new TextSpan(
                                    text: ' Log in',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Single tapped.
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()),
                                        );
                                      }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      builder: EasyLoading.init(),
    );
  }

  bool SignupValidation() {
    try {
      if (_aptNoController.text.isEmpty) {
        EasyLoadingToastMessage(context, StrEnterAptNo);
        return false;
      }
      if (_nameController.text.isEmpty) {
        EasyLoadingToastMessage(context, StrEnterName);
        return false;
      }
      if (_contactController.text.isEmpty) {
        EasyLoadingToastMessage(context, StrEnterContactNo);
        return false;
      }
      if (_applicationCodeController.text.isEmpty) {
        EasyLoadingToastMessage(context, StrEnterApplicationCode);
        return false;
      }
      if (_emailController.text.isEmpty) {
        EasyLoadingToastMessage(context, StrEnterEmailId);
        return false;
      }
      if (!reg.hasMatch(_emailController.text)) {
        EasyLoadingToastMessage(context, StrEnterValidEmailId);
        return false;
      }
      if (_passwordController.text.isEmpty) {
        EasyLoadingToastMessage(context, StrEnterPassword);
        return false;
      }
      if (_passwordController.text.length < 6) {
        EasyLoadingToastMessage(context, StrValidPass);
        return false;
      }
      if (_cnfPassController.text.isEmpty) {
        EasyLoadingToastMessage(context, StrEnterConfmpass);
        return false;
      }
      if (_cnfPassController.text.length < 6) {
        EasyLoadingToastMessage(context, StrValidPass);
        return false;
      }
      if (_passwordController.text != _cnfPassController.text) {
        EasyLoadingToastMessage(context, StrnotmatchPassword);
      }
    } on Exception catch (e) {
      // TODO
      return false;
    }
    return true;
  }

  void Signup(String apartmentno, String name, String Contactno,
      String Applicationcode, String emailId, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // setState(() {
    //   _isLoading = true;
    // });
    EasyLoading.show(status: 'Please Wait...');
    Map data = {
      'apt_no': apartmentno,
      'resident_name': name,
      'resident_contactno': Contactno,
      'resident_email': emailId,
      'ru_pswd': password,
      'application_code': Applicationcode
    };
    print(data.toString());
    var jsonResponse = null;
    var url = Uri.parse(RegistrationsAPI);
    http.Response response = await http.post(
      url,
      body: data,
      headers: {
        // "Accept": "application/json",
        // "Content-Type": "application/x-www-form-urlencoded"
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // jsonResponse = json.decode(response.body);
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        // setState(() {
        //   _isLoading = false;
        // });
        EasyLoading.dismiss();
        sharedPreferences.setString("message", jsonResponse['message']);
        if (jsonResponse['success'] == 1) {
          sharedPreferences.setString("message", "Signup");
          EasyLoadingToastMessage(context, jsonResponse['message']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => VerifyEmailPage(emailId)),
              (Route<dynamic> route) => false);
        } else {
          EasyLoadingToastMessage(context, jsonResponse['message']);
        }
      }
    } else {
      // setState(() {
      //   _isLoading = false;
      // });
      EasyLoading.dismiss();
      print(response.body);
    }
  }
}


