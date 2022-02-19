import 'dart:convert';
import 'package:condo_pigeon/Comman/Util.dart';
import 'package:condo_pigeon/Comman/string.dart';
import 'package:condo_pigeon/api/api.dart';
import 'package:condo_pigeon/model/announcementItem.dart';
import 'package:condo_pigeon/pages/AnnouncementDetail.dart';
import 'package:condo_pigeon/pages/HomePages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementsListPage extends StatefulWidget {
  AnnouncementsListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AnnouncementsListPageState();
  }
}

class AnnouncementsListPageState extends State<AnnouncementsListPage> {
  var _listannmnt = new List<AnnouncementItem>();
  String _UserID, _CondoID;

  Future<List<AnnouncementItem>> listDataJSON() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _UserID = preferences.getString(Register_UserID);
    _CondoID = preferences.getString(StrCondo_ID);
    Map data = {'condo_id': _CondoID, 'residence_user_id': _UserID};
    var url = Uri.parse(GetAnnouncementDataAPI);
    print('Payload : - ' + data.toString());
    var response = await http.post(url, body: data);
    if (response != null && response.statusCode == 200) {
      var jsonResponse = null;
      List loadedAnnouncements;
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (jsonResponse['success'] == 1) {
      //    CustomeSnackBarMessage(context, jsonResponse['message']);
          loadedAnnouncements = jsonResponse['ancmntdata'];
          _listannmnt = loadedAnnouncements
              .map((model) => AnnouncementItem.fromJson(model))
              .toList();
          print(_listannmnt.length);
        } else {
        //  CustomeSnackBarMessage(context, jsonResponse['message']);
        }
        return _listannmnt;
      }
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<void> initState() {
    // TODO: implement initState
    // getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async{
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
              //future: DefaultAssetBundle.of(context),
              future: listDataJSON(),
              builder: (context, snapshot) {
                // var beers = json.decode(snapshot.data.toString());
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: new ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        var Announcementlst = _listannmnt[index];
                        return GestureDetector(
                            child: AnnouncementListItem(Announcementlst),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AnnouncementDetail(Announcementlst)),
                              );
                            });
                      },
                      itemCount: _listannmnt == null ? 0 : _listannmnt.length,
                    ),
                  );
                }
              }),
        ),
      ),
    ));
  }

  Container AnnouncementListItem(AnnouncementItem item) {
    return Container(
      height: 150,
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue, width: 0.5),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(0.5),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5)),
                  color: Colors.blue,
                ),
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              "assets/ic_list_announcement.png",
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.ancmnt_title,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  item.ancmnt_datetime,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                  textAlign: TextAlign.left,
                                )
                              ],
                            ),

                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(item.ancment_description,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w400,
                                        height: 1.4,
                                        fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/ic_location.png",
                                    width: 20,
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "2 KM",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                item.ack_status == "Pending"?Icons.mark_email_unread :Icons.mark_email_read,
                                color:item.ack_status == "Pending"? Colors.lightBlue: Colors.grey,
                                size: 20,),
                            ),
                          ],
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
    );
  }

// void GetAnnouncementData(String condo_ID, String USerID) async {
//   print('befor call api: - ' +
//       'condo_ID : - ' +
//       condo_ID +
//       ', USerID: - ' +
//       USerID);
//   Map data = {'condo_id': condo_ID, 'residence_user_id': USerID};
//   var jsonResponse = null;
//   if (condo_ID != null && USerID != null) {
//     var url = Uri.parse(GetAnnouncementDataAPI);
//     print('Payload : - ' + data.toString());
//     var response = await http.post(url, body: data);
//     if (response != null && response.statusCode == 200) {
//       jsonResponse = json.decode(response.body);
//       if (jsonResponse != null) {
//         //  setState(() {
//         //  });
//         if (jsonResponse['success'] == 1) {
//           CustomeSnackBarMessage(context, jsonResponse['message']);
//           List loadedCars = jsonResponse['ancmntdata'];
//           _listannmnt = loadedCars
//               .map((model) => AnnouncementItem.fromJson(model))
//               .toList();
//           print(_listannmnt.length);
//         } else {
//           CustomeSnackBarMessage(context, jsonResponse['message']);
//         }
//       }
//     } else {
//       print(response.body);
//     }
//   }
// }

}
