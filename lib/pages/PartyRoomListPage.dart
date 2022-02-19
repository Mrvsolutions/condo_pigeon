import 'dart:convert';
import 'package:condo_pigeon/Comman/CustomeLoadingDialog.dart';
import 'package:condo_pigeon/Comman/Util.dart';
import 'package:condo_pigeon/Comman/string.dart';
import 'package:condo_pigeon/api/api.dart';
import 'package:condo_pigeon/model/PartyRoomItem.dart';
import 'package:condo_pigeon/pages/AnnouncementDetail.dart';
import 'package:condo_pigeon/pages/HomePages.dart';
import 'package:condo_pigeon/pages/PartyRoomDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PartyRoomListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PartyRoomListPageState();
  }
}

class _PartyRoomListPageState extends State<PartyRoomListPage> {
  var _listpartroom = new List<PartyRoomItem>();
  String _UserID, _CondoID;

  Future<List<PartyRoomItem>> listDataJSON() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _UserID = preferences.getString(Register_UserID);
    _CondoID = preferences.getString(StrCondo_ID);
    Map data = {'condo_id': _CondoID, 'residence_user_id': _UserID};
    var url = Uri.parse(GetPartyRoomListAPI);
    print('Payload : - ' + data.toString());
    var response = await http.post(url, body: data);
    if (response != null && response.statusCode == 200) {
      var jsonResponse = null;
      List loadedAnnouncements;
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (jsonResponse['success'] == 1) {
     //     CustomeSnackBarMessage(context, jsonResponse['message']);
          loadedAnnouncements = jsonResponse['prtyrmdata'];
          _listpartroom = loadedAnnouncements
              .map((model) => PartyRoomItem.fromJson(model))
              .toList();
          final String encodedData = PartyRoomItem.encode(_listpartroom);
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          // await sharedPreferences.setString(PartRoomList,_listpartroom.toString());
          await sharedPreferences.setString(PartRoomList, encodedData);
          print(_listpartroom.length);
        } else {
     //     CustomeSnackBarMessage(context, jsonResponse['message']);
        }
        return _listpartroom;
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
                              var Partyroomlst = _listpartroom[index];
                              return GestureDetector(
                                  child: PartyRoomListRow(Partyroomlst),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PartyRoomDetail(Partyroomlst)),
                                    );
                                  });
                            },
                            itemCount: _listpartroom == null ? 0 : _listpartroom.length,
                          ),
                        );
                      }
                      ;
                    }),
              ),
            ),
          ));
  }

  Container PartyRoomListRow(PartyRoomItem _item) {
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
                                      _item.pr_eventname,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(15, 0, 10, 0),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Card(
                                        color: _item.pr_rqst_status == 'PENDING' ? Colors.red : Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 6, 15, 6),
                                          child: Text(
                                            _item.pr_rqst_status,
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
                                    _item.pr_startdate+" to "+ _item.pr_enddate,
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
                                  "Requested Date: "+_item.pr_rqst_datetime,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13),
                                ),
                              ),
                              Visibility(
                                visible: _item.sts_change_by.isEmpty ? false : true,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                  child: Text(
                                    "By : "+_item.sts_change_by,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
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
                            visible: _item.pr_rqst_status == 'PENDING'?true:false,
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
                                    DeletePartyRoomRequestAPI(_item.party_id,context);
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

  DeletePartyRoomRequestAPI(String strPartyroomId,
      BuildContext context) async {
    // EasyLoading.show(status: 'Loading...');
    BuildContext dialogContext;
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return CustomeLoadingDialog("Please Wait...");
        });
    Map data = {
      'party_id': strPartyroomId,
    };
    print('party Payload : - ' + data.toString());
    var jsonResponse = null;
    var url = Uri.parse(DeletePartyRoomAPI);
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        // EasyLoading.dismiss();
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
