import 'dart:convert';
import 'package:condo_pigeon/Comman/Util.dart';
import 'package:condo_pigeon/api/api.dart';
import 'package:condo_pigeon/model/PartyRoomItem.dart';
import 'package:condo_pigeon/pages/AppToolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class PartyRoomDetail extends StatelessWidget {
 // var _titleheading = "Family Function"
  PartyRoomItem  _item;
  PartyRoomDetail(@required this._item);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      home: Scaffold(
          appBar: AppToolbar(context, _item.pr_eventname,true,false),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          _item.pr_startdate+" to "+ _item.pr_enddate,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Text(
                        _item.pr_evnt_desc,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w300,
                            height: 1.4,
                            fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                            "Requested Date: "+_item.pr_rqst_datetime,
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: RaisedButton(
                                onPressed: () async {
                                  DeletePartyRoomRequestAPI(_item.party_id,context);
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18
                                  ),
                                ),
                                color: Colors.red,
                                textColor: Colors.white,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
  DeletePartyRoomRequestAPI(String strPartyroomId,
      BuildContext context) async {
    EasyLoading.show(status: 'Loading...');
    Map data = {
      '‘party_id’': strPartyroomId,
    };
    var jsonResponse = null;
    var url = Uri.parse(DeletePartyRoomAPI);
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        EasyLoading.dismiss();
        if (jsonResponse['success'] == 1) {
          EasyLoadingToastMessage(context, jsonResponse['message']);
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
}
