import 'dart:convert';

import 'package:condo_pigeon/Comman/Util.dart';
import 'package:condo_pigeon/Comman/string.dart';
import 'package:condo_pigeon/api/api.dart';
import 'package:condo_pigeon/pages/AppToolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  var _titleheading = "Change Password";
  TextEditingController _OldPassController = new TextEditingController();
  TextEditingController _NewPAssController = new TextEditingController();
  TextEditingController _ConfPassController = new TextEditingController();
  RegExp regepassword =RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      home: Scaffold(
        appBar: AppToolbar(context, _titleheading,true,false),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                    child: Text(
                      "Please insert your new Password.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                  child: Center(
                    child: TextFormField(
                      autovalidateMode:
                      AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value.isEmpty) {
                          return StrEnterOldPassword;
                        } else if (value.length < 6) {
                          return StrValidPass;
                        }
                        return null;
                      },
                      controller: _OldPassController,
                      decoration: InputDecoration(
                          hintText: "Enter old password", labelText: "Old Password"),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                      obscureText: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                  child: Center(
                    child: TextFormField(
                      autovalidateMode:
                      AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value.isEmpty) {
                          return StrEnterNewPassword;
                        } else if (!regepassword.hasMatch(value)) {
                          return StrValidPass;
                        }
                        return null;
                      },
                      controller: _NewPAssController,
                      decoration: InputDecoration(
                          hintText: "Enter new password", labelText: "new Password", errorMaxLines: 2),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                      obscureText: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                  child: Center(
                    child: TextFormField(
                      autovalidateMode:
                      AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value.isEmpty) {
                          return StrEnterConfmpass;
                        } else if (value.length < 6) {
                          return StrValidPass;
                        } else if (_NewPAssController.text !=
                            _ConfPassController.text) {
                          return StrnotmatchPassword;
                        }
                        return null;
                      },
                      controller: _ConfPassController,
                      decoration: InputDecoration(
                          hintText: "Enter confirm password", labelText: "Confirm Password"),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                      obscureText: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: RaisedButton(
                      onPressed: () {
                        FocusScopeNode currentFocus =
                        FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus &&
                            currentFocus.focusedChild != null) {
                          currentFocus.focusedChild.unfocus();
                        }
                        if(ChangePassValidation())
                        {
                          ChangePasswordRequest(_OldPassController.text,_NewPAssController.text);
                        }
                      },
                      child: Text(
                        "CHANGE PASSWORD",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w800,
                            fontSize: 18),
                      ),
                      color: Colors.lightBlue,
                      textColor: Colors.white,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void ChangePasswordRequest( String oldPass, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _UserID = sharedPreferences.getString(Register_UserID);
    EasyLoading.show(status: 'Please Wait...');
    Map data = {
      'residence_user_id': _UserID,
      'old_password': oldPass,
      'new_password': password,
    };
    print(data.toString());
    var url = Uri.parse(ChangePasswordAPI);
    http.Response response = await http.post(
      url,
      body: data,
      headers: {
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        EasyLoading.dismiss();
        sharedPreferences.setString("message", jsonResponse['message']);
        if (jsonResponse['success'] == 1) {
          EasyLoadingToastMessage(context, jsonResponse['message']);
          _OldPassController.clear();
          _NewPAssController.clear();
          _ConfPassController.clear();
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => HomePages()),
          //         (Route<dynamic> route) => false);
        } else {
          EasyLoadingToastMessage(context, jsonResponse['message']);
        }
        Navigator.of(context).pop();
      }
    } else {
      EasyLoading.dismiss();
      print(response.body);
    }
  }
  bool ChangePassValidation() {
    try {
      if (_OldPassController.text.isEmpty) {
        EasyLoadingToastMessage(context, StrEnterOldPassword);
        return false;
      }
      if (_NewPAssController.text.isEmpty) {
        EasyLoadingToastMessage(context, StrEnterNewPassword);
        return false;
      }
      if (_NewPAssController.text.length < 6) {
        EasyLoadingToastMessage(context, StrValidPass);
        return false;
      }
      if (_ConfPassController.text.isEmpty) {
        EasyLoadingToastMessage(context, StrEnterConfmpass);
        return false;
      }
      if (_NewPAssController.text != _ConfPassController.text) {
        EasyLoadingToastMessage(context, StrnotmatchPassword);
      }
    } on Exception catch (e) {
      // TODO
      return false;
    }
    return true;
  }
}
