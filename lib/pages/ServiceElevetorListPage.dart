import 'dart:convert';
import 'package:condo_pigeon/Comman/CustomeLoadingDialog.dart';
import 'package:condo_pigeon/Comman/Util.dart';
import 'package:condo_pigeon/Comman/string.dart';
import 'package:condo_pigeon/api/api.dart';
import 'package:condo_pigeon/model/PartyRoomItem.dart';
import 'package:condo_pigeon/model/ServiceElevetorItem.dart';
import 'package:condo_pigeon/pages/AnnouncementDetail.dart';
import 'package:condo_pigeon/pages/HomePages.dart';
import 'package:condo_pigeon/pages/PartyRoomDetail.dart';
import 'package:condo_pigeon/pages/ServiceElevetorDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ServiceElevetorListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ServiceElevetorListPageState();
  }
}

class _ServiceElevetorListPageState extends State<ServiceElevetorListPage> {
  var _listserviceElevetor = new List<ServiceElevetorItem>();
  String _UserID, _CondoID;

  Future<List<ServiceElevetorItem>> listDataJSON() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _UserID = preferences.getString(Register_UserID);
    _CondoID = preferences.getString(StrCondo_ID);
    Map data = {'condo_id': _CondoID, 'residence_user_id': _UserID};
    var url = Uri.parse(GetServiceElevetorListAPI);
    print('Payload : - ' + data.toString());
    var response = await http.post(url, body: data);
    if (response != null && response.statusCode == 200) {
      var jsonResponse = null;
      List loadedAnnouncements;
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (jsonResponse['success'] == 1) {
          CustomeSnackBarMessage(context, jsonResponse['message']);
          loadedAnnouncements = jsonResponse['srvcelvtrdata'];
          _listserviceElevetor = loadedAnnouncements
              .map((model) => ServiceElevetorItem.fromJson(model))
              .toList();
          final String encodedData = ServiceElevetorItem.encode(_listserviceElevetor);
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          await sharedPreferences.setString(ServiceEltrList, encodedData);
          print(_listserviceElevetor.length);
          print(_listserviceElevetor[0].se_starttime);
        } else {
          CustomeSnackBarMessage(context, jsonResponse['message']);
        }
        return _listserviceElevetor;
      }
    } else {
      throw Exception('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              return Future.delayed(
                Duration(seconds: 1),
                    () {
                  setState(() {
                  });
                },
              );
            },
            child: new Container(
              child: new Center(
                child: new FutureBuilder(
                    future: listDataJSON(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      else {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: new ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              var ServiceElevetorlst = _listserviceElevetor[index];
                              return GestureDetector(
                                  child: ServiceelevetorListRow(ServiceElevetorlst),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ServiceElevetorDetail(ServiceElevetorlst)),
                                    );
                                  });
                            },
                            itemCount: _listserviceElevetor == null ? 0 : _listserviceElevetor.length,
                          ),
                        );
                      }
                      ;
                    }),
              ),
            ),
          ));
  }

  Container ServiceelevetorListRow(ServiceElevetorItem _item) {
    return Container(
      height: 200,
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue, width: 0.5),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 3),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        _item.se_date,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(15, 0, 10, 0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Card(
                                          color:  _item.se_rqst_status == 'PENDING' ? Colors.red : Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 6, 15, 6),
                                            child: Text(
                                              _item.se_rqst_status,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    _item.se_starttime+" to "+ _item.se_endtime,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  "Requested Date: "+_item.se_rqst_datetime,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13),
                                ),
                              ),
                              Visibility(
                                visible: _item.se_sts_change_by.isEmpty ? false : true,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                  child: Text(
                                    "By: "+_item.se_sts_change_by,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Visibility(
                            visible: _item.se_rqst_status == 'PENDING'?true:false,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: SizedBox(
                                width: 80,
                                height: 35,
                                child: RaisedButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => LoginPage()),
                                    // );
                                    DeleteServiceElevetorRequestAPI(_item.srvcelvtr_id,context);
                                  },
                                  child: Text("Cancel"),
                                  color: Colors.grey,
                                  textColor: Colors.white,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  DeleteServiceElevetorRequestAPI(String strServiceElevetorId,
      BuildContext context) async {
    BuildContext dialogContext;
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return CustomeLoadingDialog("Please Wait...");
        });
    Map data = {
      'srvcelvtr_id': strServiceElevetorId,
    };
    print('Payload : - ' + data.toString());
    var jsonResponse = null;
    var url = Uri.parse(DeleteServiceElevetorAPI);
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        Navigator.pop(dialogContext);
        if (jsonResponse['success'] == 1) {
          CustomeSnackBarMessage(context, jsonResponse['message']);
          await listDataJSON();
          setState(() {
          });
        } else {
          CustomeSnackBarMessage(context, jsonResponse['message']);
        }
      }
    } else {
      EasyLoading.dismiss();
      print(response.body);
    }
  }
}
