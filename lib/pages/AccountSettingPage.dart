import 'dart:convert';

import 'package:condo_pigeon/Comman/Util.dart';
import 'package:condo_pigeon/Comman/string.dart';
import 'package:condo_pigeon/api/api.dart';
import 'package:condo_pigeon/pages/ChangePasswordPage.dart';
import 'package:condo_pigeon/pages/LoginPage.dart';
import 'package:condo_pigeon/pages/MyProfilePages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingPage extends StatefulWidget {
  @override
  _AccountSettingPageState createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  var _titleheading = "Setings";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                // GestureDetector(
                //   child: Container(
                //     color: Colors.white,
                //     child: Padding(
                //       padding: const EdgeInsets.all(18.0),
                //       child: Row(
                //        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: <Widget>[
                //           Expanded(
                //             child: Container(
                //               child: Text(
                //                 "Notifications",
                //                 style: TextStyle(
                //                     color: Colors.black,
                //                     fontFamily: "Montserrat",
                //                     fontWeight: FontWeight.w500,
                //                     fontSize: 18),
                //               ),
                //             ),
                //           ),
                //           Image.asset(
                //             "assets/ic_next_right.png",
                //             width: 20,
                //             height: 20,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                //   onTap: (){
                //
                //   },
                // ),
                // SizedBox(height: 5,),
                GestureDetector(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                "Profile Settings",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          Image.asset(
                            "assets/ic_next_right.png",
                            width: 20,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyProfilePages()),
                    );
                  },
                ),
                SizedBox(height: 5,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordPage()),
                    );
                  },
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                "Change Password",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          Image.asset(
                            "assets/ic_next_right.png",
                            width: 20,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Text(
                              "Delete Account",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    SigoutProfileAPI(context);
                  },
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                "Sign Out",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      builder: EasyLoading.init(),
    );
  }
 SigoutProfileAPI(BuildContext context) async {

    // setState(() {
    //   // _isLoading = true;
      EasyLoading.show(status: 'Please Wait...');
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var _UserID = sharedPreferences.getString(Register_UserID);
    // });
    Map data = {'residence_user_id': _UserID};
    var jsonResponse = null;
    var url = Uri.parse(SignoutAPI);
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
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.clear();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);
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
