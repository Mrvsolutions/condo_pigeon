import 'dart:convert';
import 'dart:ffi';

import 'package:condo_pigeon/model/UserProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void EasyLoadingToastMessage(BuildContext context, String strmsg) {
  // final scaffold = ScaffoldMessenger.of(context);
  // scaffold.showSnackBar(
  //     SnackBar(
  //       content: Text(strmsg),
  //     ));
  EasyLoading.showToast(strmsg,toastPosition: EasyLoadingToastPosition.bottom);
}
void CustomeSnackBarMessage(BuildContext context, String strmsg) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
      SnackBar(
        content: Text(strmsg),
      ));
}
void CustomeFlutterToast(String strmsg) {
  Fluttertoast.showToast(
      msg: strmsg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

// DateTime selectedStartDate;
// void UserPreference(String residence_user_id, String condo_id,  String resident_name,String resident_email,String resident_contactno,String chng_pswd_rqst,String apt_no) {
//    const UserProfile MyProfile = new UserProfile(residence_user_id, condo_id, resident_name, resident_email, resident_contactno, chng_pswd_rqst, apt_no);
// }


