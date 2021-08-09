import 'dart:convert';

import 'package:condo_pigeon/Comman/Util.dart';
import 'package:condo_pigeon/api/api.dart';
import 'package:condo_pigeon/model/announcementItem.dart';
import 'package:condo_pigeon/pages/AppToolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class AnnouncementDetail extends StatefulWidget {
  AnnouncementItem  _item;
  AnnouncementDetail(@required this._item);
  @override
  _AnnouncementDetailState createState() => _AnnouncementDetailState();
}

class _AnnouncementDetailState extends State<AnnouncementDetail> {
  //var _titleheading = ;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      home: Scaffold(
          appBar: AppToolbar(context, widget._item.ancmnt_title,true),
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
                          widget._item.ancmnt_datetime ,
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        // Expanded(
                        //   child: Container(
                        //     child: Text(
                        //         widget._item.ancmnt_title,
                        //         style: TextStyle(
                        //             color: Colors.black,
                        //             fontFamily: "Montserrat",
                        //             fontWeight: FontWeight.w400,
                        //             height: 1.4,
                        //             fontSize: 15),
                        //         maxLines: 2,
                        //         overflow: TextOverflow.ellipsis),
                        //   ),
                        // ),
                        SizedBox(
                          width: 10,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Image.network(
                            ROOT+"/"+ widget._item.ancmnt_img,
                            height: 150.0,
                            width: 150.0,
                          ),
                        ),
                        // SizedBox(
                        //   width: 5,
                        // ),
                        // Column(
                        //   children: [
                        //     Image.asset(
                        //       "assets/ic_location.png",
                        //       width: 20,
                        //       height: 20,
                        //     ),
                        //     SizedBox(
                        //       width: 5,
                        //     ),
                        //     Text(
                        //       "2 KM",
                        //       style: TextStyle(
                        //           color: Colors.black,
                        //           fontFamily: "Montserrat",
                        //           fontWeight: FontWeight.w400,
                        //           fontSize: 13),
                        //       textAlign: TextAlign.left,
                        //     )
                        //   ],
                        // ),
                        // SizedBox(
                        //   width: 10,
                        // )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          widget._item.ancment_description,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w300,
                              height: 1.4,
                              fontSize: 15),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                        child: SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: RaisedButton(
                            onPressed: widget._item.ack_status == "Pending"? () async {
                              String ansmntId = widget._item.ancmnt_id;
                              AknowledgementAPI(widget._item.condo_id,ansmntId,widget._item.residence_user_id,context);
                            }:null,
                            child: Text(
                              widget._item.ack_status == "Pending"?"Acknowledge":"Acknowledged",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                fontSize: 18
                              ),
                            ),
                            color: widget._item.ack_status == "Pending"? Colors.lightBlue: Colors.grey,
                            textColor: Colors.white,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
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

  AknowledgementAPI(String Comdo_ID, String AnnouncementID, String Register_UserID,
      BuildContext context) async {
    EasyLoading.show(status: 'Loading...');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'condo_id': Comdo_ID,
      'ancmnt_id': AnnouncementID,
      'residence_user_id': Register_UserID
    };
    var jsonResponse = null;
    var url = Uri.parse(AnnouncementAknwlgAPI);
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        EasyLoading.dismiss();
        // setState(() {
        //   _isLoading = false;
        // });
        if (jsonResponse['success'] == 1) {
          EasyLoadingToastMessage(context, jsonResponse['message']);
        } else {
          EasyLoadingToastMessage(context, jsonResponse['message']);
        }
      }
    } else {
      EasyLoading.dismiss();
      print(response.body);
    }
  }
}
