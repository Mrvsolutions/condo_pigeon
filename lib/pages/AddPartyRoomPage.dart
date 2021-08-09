import 'dart:convert';
import 'package:condo_pigeon/Comman/CustomeCalendarpickerDialog.dart';
import 'package:condo_pigeon/Comman/Util.dart';
import 'package:condo_pigeon/Comman/string.dart';
import 'package:condo_pigeon/api/api.dart';
import 'package:condo_pigeon/model/PartyRoomItem.dart';
import 'package:condo_pigeon/pages/AppToolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddPartyRoomPage extends StatefulWidget {
  @override
  _AddPartyRoomPageState createState() => _AddPartyRoomPageState();
}

class _AddPartyRoomPageState extends State<AddPartyRoomPage> {
  var _titleheading = "Add Party Room";
  String _text = "";
  List<DateTime> _specialDates;
  List<PartyRoomItem> partyroomlist;
  TextEditingController _EventNameController = new TextEditingController();
  TextEditingController _StartDateController = new TextEditingController();
  TextEditingController _EndDateController = new TextEditingController();
  TextEditingController _EventDescriptionController =
      new TextEditingController();

  Future displayDateRangePicker(
      BuildContext context, bool IsFromStartdate) async {
    DateTime currentDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: new DateTime(DateTime.now().year - 50),
        lastDate: new DateTime(DateTime.now().year + 50));
    if (picked != null && (picked.compareTo(currentDate) > 0)) {
      setState(() {
        if (IsFromStartdate) {
          _StartDateController.text =
              formatDate(picked, [dd, '/', mm, '/', yyyy]); //datestring;

        } else {
          _EndDateController.text =
              formatDate(picked, [dd, '/', mm, '/', yyyy]);
        }
      });
    } else {
      EasyLoadingToastMessage(
          context, "Please select current date or future date");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    () async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final String PartRoomListstr =
          await sharedPreferences.getString(PartRoomList);
      partyroomlist = PartyRoomItem.decode(PartRoomListstr);
      print("partyroomlist:-" + partyroomlist[0].pr_startdate);
      _specialDates = _getSpecialDates();
      print("_specialDates:-" + _specialDates.toString());
      setState(() {
        // _StartDateController.text = selectedStartDate;
      });
    }();
    // _controller = CalendarController();
  }

  List<DateTime> _getSpecialDates() {
    final List<DateTime> dates = <DateTime>[];
    for (int i = 0; i < 3; i++) {
      DateTime date =
          DateFormat('dd/MM/yyyy').parse(partyroomlist[i].pr_startdate);
      dates.add(date);
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppToolbar(context, _titleheading, true),
        body: Container(
          margin: EdgeInsets.only(top: 5),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: TextFormField(
                    controller: _EventNameController,
                    decoration: InputDecoration(
                        hintText: "Event Name", labelText: "Event Name"),
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value.isEmpty) {
                        return StrEventNameEnter;
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: TextFormField(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());

                      // await displayDateRangePicker(context, true);
                      print("_rangeCount:-" + _specialDates.toString());
                      //autofocus = true;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomeCalendarpickerDialog(_specialDates,
                                _StartDateController, false, null);
                          });
                    },
                    controller: _StartDateController,
                    decoration: InputDecoration(
                        hintText: "Start Date", labelText: "Start Date"),
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value.isEmpty) {
                        return StrEventStartDateEnter;
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: TextFormField(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      // await displayDateRangePicker(context, false);
                    //  autofocus = true;
                      print("_rangeCount:-" + _specialDates.toString());
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomeCalendarpickerDialog(
                                _specialDates,
                                _EndDateController,
                                false,
                                _StartDateController.text);
                          });
                    },
                    controller: _EndDateController,
                    decoration: InputDecoration(
                        hintText: "End Date", labelText: "End Date"),
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value.isEmpty) {
                        return StrEventEndDateEnter;
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: TextFormField(
                    controller: _EventDescriptionController,
                    decoration: InputDecoration(
                        hintText: "Event Description",
                        labelText: "Event Description"),
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value.isEmpty) {
                        return StrEventDescriptionEnter;
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 60,
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

                        if (_EventNameController.text.isNotEmpty &&
                            _StartDateController.text.isNotEmpty &&
                            _EndDateController.text.isNotEmpty &&
                            _EventDescriptionController.text.isNotEmpty) {
                          SendPartyRoomRequest(
                              _EventNameController.text,
                              _StartDateController.text,
                              _EndDateController.text,
                              _EventDescriptionController.text);
                        } else {
                          EasyLoadingToastMessage(context, strenterallValue);
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

  void SendPartyRoomRequest(String strEventName, String StrStartDate,
      String StrEndDate, String StrDescription) async {
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
      'pr_eventname': strEventName,
      'pr_evnt_desc': StrDescription,
      'pr_startdate': StrStartDate,
      'pr_enddate': StrEndDate
    };
    print(data.toString());
    var url = Uri.parse(SendPartyRoomRequestAPI);
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
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => VerifyEmailPage(emailId)),
          //         (Route<dynamic> route) => false);
          _EventNameController.clear();
          _EventDescriptionController.clear();
          _EndDateController.clear();
          _StartDateController.clear();
          FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus.unfocus();
          }
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
