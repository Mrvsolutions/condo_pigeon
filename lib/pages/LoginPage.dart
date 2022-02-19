import 'dart:convert';

import 'package:condo_pigeon/BgImage.dart';
import 'package:condo_pigeon/Comman/Util.dart';
import 'package:condo_pigeon/Comman/string.dart';
import 'package:condo_pigeon/api/api.dart';
import 'package:condo_pigeon/model/UserProfile.dart';
import 'package:condo_pigeon/pages/ChangePasswordPage.dart';
import 'package:condo_pigeon/pages/ForgotPasswordPage.dart';
import 'package:condo_pigeon/pages/HomePages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'SignupPages.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var reg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  TextEditingController UsernameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  String _Auth_Token = "";
  Future<void> saveTokenToDatabase(String tkn) async {
    // Assume user is logged in for this example
    _Auth_Token = await FirebaseMessaging.instance.getToken();
    print('token - Login page: - ' + _Auth_Token);
    // String userId = FirebaseAuth.instance.currentUser.uid;
    //
    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId)
    //     .update({
    //   'tokens': FieldValue.arrayUnion([token]),
    // });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  WidgetsFlutterBinding.ensureInitialized();
   // await Firebase.initializeApp();
    saveTokenToDatabase(null);

   FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    PasswordController.clear();
    UsernameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.blue.withOpacity(0.9),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              BgImage(),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      "assets/sigin_logo.png",
                      height: 130,
                      width: 130,
                      // fit: BoxFit.fitWidth,
                    ),
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Card(
                      margin: const EdgeInsets.all(0.0),
                      elevation: 2,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(35), bottom: Radius.zero),
                      ),
                      child: Column(
                        children: <Widget>[
                          Form(
                              child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: UsernameController,
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
                                    hintText: "Enter E-Mail",
                                    labelText:
                                        "E-Mail", //errorText:  isValidateEmail ? EmailErrorMsg : null
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return StrEnterPassword;
                                    }
                                    return null;
                                  },
                                  controller: PasswordController,
                                  decoration: InputDecoration(
                                    hintText: "Enter Password",
                                    labelText: "Password",
                                  ),
                                  obscureText: true,
                                ),
                              ],
                            ),
                          )),
                          FlatButton(
                            onPressed: () {
                              //TODO FORGOT PASSWORD SCREEN GOES HERE
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage()),
                              );
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot Password?",
                                textAlign: TextAlign.left,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: RaisedButton(
                                onPressed: () {
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                                    currentFocus.focusedChild.unfocus();
                                  }
                                  if (SignInValidation()) {
                                    signIn(UsernameController.text,
                                        PasswordController.text, context);
                                  }
                                },
                                child: Text("LOGIN"),
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
                              padding: const EdgeInsets.all(5.0),
                              child: RichText(
                                text: new TextSpan(
                                  style: new TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text: 'Don\'t have an account?',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                    new TextSpan(
                                        text: ' Sign up',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // Single tapped.
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignupPages()),
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
              )
            ],
          )),
      builder: EasyLoading.init(),
    );
  }

  bool SignInValidation() {
    try {
      if (UsernameController.text.isEmpty) {
        EasyLoadingToastMessage(context, StrEnterEmailId);
        return false;
      }
      if (PasswordController.text.isEmpty) {
        EasyLoadingToastMessage(context, StrEnterPassword);
        return false;
      }
    } on Exception catch (e) {
      // TODO
      return false;
    }
    return true;
  }

  signIn(String email, String pass, BuildContext context) async {

    setState(() {
      // _isLoading = true;
      EasyLoading.show(status: 'Please Wait...');
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'resident_email': email, 'ru_pswd': pass};
    var jsonResponse = null;
    var url = Uri.parse(LoginAPI);
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        // setState(() {
        //   // _isLoading = false;
           EasyLoading.dismiss();
        // });
        if (jsonResponse['success'] == 1) {
          var _userProfile = new List<UserProfile>();
          sharedPreferences.setString("message", LOGIN_COMPLETE);
          sharedPreferences.setString(Auth_Token, _Auth_Token);
          EasyLoadingToastMessage(context, jsonResponse['message']);
          List userdata = jsonResponse['userdata'];
          _userProfile = userdata
                 .map((model) => UserProfile.fromJson(model))
                 .toList();
          print(_userProfile.toString());
          sharedPreferences.setString(Register_UserID, _userProfile[0].residence_user_id);
          sharedPreferences.setString(StrCondo_ID, _userProfile[0].condo_id);
          sharedPreferences.setString(StrUserName,_userProfile[0].resident_name);
          sharedPreferences.setString(StrUserEmail, _userProfile[0].resident_email);
          sharedPreferences.setString(StrContactNumber, _userProfile[0].resident_contactno);
          sharedPreferences.setString(Strapt_no, _userProfile[0].apt_no);
          sharedPreferences.setString(Strru_profile_pic, _userProfile[0].ru_profile_pic);
          String msg = jsonResponse['message']+", CondoID:"+_userProfile[0].condo_id+", Name: "+_userProfile[0].resident_name+","
              " USERID: "+_userProfile[0].residence_user_id+", USER_Contanct: "+_userProfile[0].resident_contactno;
        //  EasyLoadingToastMessage(context, msg);
          print('Message: - ' + msg);
          EasyLoading.show(status: 'Please Wait...');
          SetTokenAPI(_userProfile[0].residence_user_id,_Auth_Token,_userProfile[0].chng_pswd_rqst,context);
          // _userProfile = userdata
          //     .map((model) => UserProfile.fromJson(model))
          //     .toList();
        } else {
          EasyLoadingToastMessage(context, jsonResponse['message']);
        }
      }
    } else {
      setState(() {
        // _isLoading = false;
        EasyLoading.dismiss();
      });
      print(response.body);
    }
  }
  SetTokenAPI(String strUser_Id, String strToken, String strChangepass,BuildContext context) async {

    // setState(() {
    //   // _isLoading = true;
    //   EasyLoading.show(status: 'Please Wait...');
    // });
    Map data = {'residence_user_id': strUser_Id, 'token': strToken};
    var jsonResponse = null;
    var url = Uri.parse(TokenRegistrationAPI);
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          // _isLoading = false;
          EasyLoading.dismiss();
        });
        if (jsonResponse['success'] == 1) {
          EasyLoadingToastMessage(context, jsonResponse['message']);
          if(strChangepass == "NO") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => HomePages(0)),
                    (Route<dynamic> route) => false);
          }
          else{
            UsernameController.clear();
            PasswordController.clear();
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => ChangePasswordPage()));
          }
        } else {
          EasyLoadingToastMessage(context, jsonResponse['message']);
        }
      }
    } else {
      setState(() {
        // _isLoading = false;
        EasyLoading.dismiss();
      });
      print(response.body);
    }
  }
}
