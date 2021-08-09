import 'dart:convert';

import 'package:condo_pigeon/Comman/CustomeCalendarpickerDialog.dart';
import 'package:condo_pigeon/Comman/Util.dart';
import 'package:condo_pigeon/Comman/string.dart';
import 'package:condo_pigeon/api/api.dart';
import 'package:condo_pigeon/model/ServiceElevetorItem.dart';
import 'package:condo_pigeon/pages/AppToolbar.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddServiceElevetor extends StatefulWidget {
  @override
  _AddServiceElevetorState createState() => _AddServiceElevetorState();
}

class _AddServiceElevetorState extends State<AddServiceElevetor> {
  var _titleheading = "Add Service Elevetor";
  var _listserviceElevetor = new List<ServiceElevetorItem>();
  List<DateTime> _specialDates;
  String _StartTime = null, _EndTime = null;
  Color cardBackgroundColor = Colors.white;
  bool pressAttention1 = false;
  bool pressAttention2 = false;
  bool pressAttention3 = false;
  bool pressAttention4 = false;
  bool pressAttention5 = false;
  bool pressAttention6 = false;
  TextEditingController _SelectDateController = new TextEditingController();
  DateTime currentDate = DateTime.now();

  Future displayDateRangePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: new DateTime(DateTime.now().year - 50),
        lastDate: new DateTime(DateTime.now().year + 50));
    if (picked != null && (picked.compareTo(currentDate) > 0)) {
      setState(() {
        _SelectDateController.text =
            formatDate(picked, [dd, '/', mm, '/', yyyy]);
      });
    } else {
      EasyLoadingToastMessage(
          context, "Please select current date or future date");
    }
  }

  List<DateTime> _getSpecialDates() {
    final List<DateTime> dates = <DateTime>[];
    for (int i = 0; i < 3; i++) {
      DateTime date =
          DateFormat('dd/MM/yyyy').parse(_listserviceElevetor[i].se_date);
      dates.add(date);
    }
    return dates;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    () async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final String Lserviceelevetorliststr =
          await sharedPreferences.getString(ServiceEltrList);
      _listserviceElevetor =
          ServiceElevetorItem.decode(Lserviceelevetorliststr);
      print("_listserviceElevetor:-" + _listserviceElevetor[0].se_date);
      _specialDates = _getSpecialDates();
      print("_specialDates:-" + _specialDates.toString());
      setState(() {
        // _StartDateController.text = selectedStartDate;
      });
    }();
    // _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppToolbar(context, _titleheading, true),
        body: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 5),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: TextFormField(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      // await displayDateRangePicker(context);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomeCalendarpickerDialog(
                                _specialDates, _SelectDateController, true,null);
                          });
                    },
                    controller: _SelectDateController,
                    decoration: InputDecoration(
                        hintText: "Please Select Date",
                        labelText: "Select Date"),
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value.isEmpty) {
                        return StrSelectDate;
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Morning",
                      style: TextStyle(
                          color: Colors.black26,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 22),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 5, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          var Isavalilblecount = _listserviceElevetor
                              .where((x) =>
                                  x.se_starttime.contains("08:30 AM") &&
                                  x.se_date
                                      .contains(_SelectDateController.text))
                              .toList()
                              .length;
                          if (_SelectDateController.text.isEmpty) {
                            EasyLoadingToastMessage(context, strSelectDate);
                          } else if (Isavalilblecount == 0) {
                            _StartTime = "08:30 AM";
                            _EndTime = "09:00 AM";
                            pressAttention1 = true;
                            pressAttention2 = false;
                            pressAttention3 = false;
                            pressAttention4 = false;
                            pressAttention5 = false;
                            pressAttention6 = false;
                            changeColor(Colors.blue);
                          } else {
                            EasyLoadingToastMessage(
                                context, strSelectothertime);
                          }
                        },
                        child: Card(
                          color: pressAttention1 ? Colors.blue : Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 10, 5, 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/ic_clock_white.png",
                                  width: 22,
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "08:30 AM",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          var Isavalilblecount = _listserviceElevetor
                              .where((x) =>
                                  x.se_starttime.contains("09:00 AM") &&
                                  x.se_date
                                      .contains(_SelectDateController.text))
                              .toList()
                              .length;
                          if (_SelectDateController.text.isEmpty) {
                            EasyLoadingToastMessage(context, strSelectDate);
                          } else if (Isavalilblecount == 0) {
                            _StartTime = "09:00 AM";
                            _EndTime = "09:30 AM";
                            pressAttention1 = false;
                            pressAttention2 = true;
                            pressAttention3 = false;
                            pressAttention4 = false;
                            pressAttention5 = false;
                            pressAttention6 = false;
                            changeColor(Colors.blue);
                          } else {
                            EasyLoadingToastMessage(
                                context, strSelectothertime);
                          }
                        },
                        child: Card(
                          color: pressAttention2 ? Colors.blue : Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/ic_clock_white.png",
                                  width: 22,
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "09:00 AM",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          var Isavalilblecount = _listserviceElevetor
                              .where((x) =>
                                  x.se_starttime.contains("09:30") &&
                                  x.se_date
                                      .contains(_SelectDateController.text))
                              .toList()
                              .length;
                          if (_SelectDateController.text.isEmpty) {
                            EasyLoadingToastMessage(context, strSelectDate);
                          } else if (Isavalilblecount == 0) {
                            _StartTime = "09:30 AM";
                            _EndTime = "10:00 AM";
                            pressAttention1 = false;
                            pressAttention2 = false;
                            pressAttention3 = true;
                            pressAttention4 = false;
                            pressAttention5 = false;
                            pressAttention6 = false;
                            changeColor(Colors.blue);
                          } else {
                            EasyLoadingToastMessage(
                                context, strSelectothertime);
                          }
                        },
                        child: Card(
                          color: pressAttention3 ? Colors.blue : Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 10, 5, 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/ic_clock_white.png",
                                  width: 22,
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "09:30 AM",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          var Isavalilblecount = _listserviceElevetor
                              .where((x) =>
                                  x.se_starttime.contains("10:00 AM") &&
                                  x.se_date
                                      .contains(_SelectDateController.text))
                              .toList()
                              .length;
                          if (_SelectDateController.text.isEmpty) {
                            EasyLoadingToastMessage(context, strSelectDate);
                          } else if (Isavalilblecount == 0) {
                            _StartTime = "10:00 AM";
                            _EndTime = "10:30 AM";
                            pressAttention1 = false;
                            pressAttention2 = false;
                            pressAttention3 = false;
                            pressAttention4 = true;
                            pressAttention5 = false;
                            pressAttention6 = false;
                            changeColor(Colors.blue);
                          } else {
                            EasyLoadingToastMessage(
                                context, strSelectothertime);
                          }
                        },
                        child: Card(
                          color: pressAttention4 ? Colors.blue : Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/ic_clock_white.png",
                                  width: 22,
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "10:00 AM",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          var Isavalilblecount = _listserviceElevetor
                              .where((x) =>
                                  x.se_starttime.contains("10:30 AM") &&
                                  x.se_date
                                      .contains(_SelectDateController.text))
                              .toList()
                              .length;
                          if (_SelectDateController.text.isEmpty) {
                            EasyLoadingToastMessage(context, strSelectDate);
                          } else if (Isavalilblecount == 0) {
                            _StartTime = "10:30 AM";
                            _EndTime = "11:00 AM";
                            pressAttention1 = false;
                            pressAttention2 = false;
                            pressAttention3 = false;
                            pressAttention4 = false;
                            pressAttention5 = true;
                            pressAttention6 = false;
                            changeColor(Colors.blue);
                          } else {
                            EasyLoadingToastMessage(context, strSelectDate);
                          }
                        },
                        child: Card(
                          color: pressAttention5 ? Colors.blue : Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/ic_clock_white.png",
                                  width: 22,
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "10:30 AM",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          var Isavalilblecount = _listserviceElevetor
                              .where((x) =>
                                  x.se_starttime.contains("11:00 AM") &&
                                  x.se_date
                                      .contains(_SelectDateController.text))
                              .toList()
                              .length;
                          if (_SelectDateController.text.isEmpty) {
                            EasyLoadingToastMessage(context, strSelectDate);
                          } else if (Isavalilblecount == 0) {
                            _StartTime = "11:00 AM";
                            _EndTime = "11:30 AM";
                            pressAttention1 = false;
                            pressAttention2 = false;
                            pressAttention3 = false;
                            pressAttention4 = false;
                            pressAttention5 = false;
                            pressAttention6 = true;
                            changeColor(Colors.blue);
                          } else {
                            EasyLoadingToastMessage(
                                context, strSelectothertime);
                          }
                        },
                        child: Card(
                          color: pressAttention6 ? Colors.blue : Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/ic_clock_white.png",
                                  width: 22,
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "11:00 AM",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: RaisedButton(
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus &&
                            currentFocus.focusedChild != null) {
                          currentFocus.focusedChild.unfocus();
                        }
                        if (_SelectDateController.text.isEmpty) {
                          EasyLoadingToastMessage(context, StrSelectDate);
                        } else {
                          if (_StartTime == null && _EndTime == null) {
                            EasyLoadingToastMessage(context, StrSelectTime);
                          } else {
                            SendServiceElevetorRequest(
                                _SelectDateController.text,
                                _StartTime,
                                _EndTime);
                          }
                        }
                      },
                      child: Text("REQUEST"),
                      color: Colors.blue,
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
      builder: EasyLoading.init(),
    );
  }

  void changeColor(Color changeToColor) {
    setState(() {
      cardBackgroundColor = changeToColor;
    });
  }

  void SendServiceElevetorRequest(
      String StrdSelectDate, String StrStartTime, String StrEndTime) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var _UserID = preferences.getString(Register_UserID);
    var _CondoID = preferences.getString(StrCondo_ID);
    // setState(() {
    //   _isLoading = true;
    // });
    EasyLoading.show(status: 'Please Wait...');
    Map data = {
      'condo_id': _CondoID,
      'residence_user_id': _UserID,
      'se_date': StrdSelectDate,
      'se_starttime': StrStartTime,
      'se_endtime': StrEndTime,
    };
    print(data.toString());
    var url = Uri.parse(SendServiceElevetorRequestAPI);
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
        if (jsonResponse['success'] == 1) {
          EasyLoadingToastMessage(context, jsonResponse['message']);
          _SelectDateController.clear();
          pressAttention1 = false;
          pressAttention2 = false;
          pressAttention3 = false;
          pressAttention4 = false;
          pressAttention5 = false;
          pressAttention6 = false;
          changeColor(Colors.grey);
          _StartTime = null;
          _EndTime = null;
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
