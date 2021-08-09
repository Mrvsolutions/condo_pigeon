import 'dart:async';
import 'dart:convert';
import 'package:condo_pigeon/Comman/Util.dart';
import 'package:condo_pigeon/Comman/string.dart';
import 'package:condo_pigeon/api/api.dart';
import 'package:condo_pigeon/model/ChatMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatDetailPageState();
  }
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  var _Messageslst = new List<ChatMessage>();
  String _UserID, _CondoID;
  final ScrollController _scrollController = ScrollController();

  TextEditingController _MessagetextController = new TextEditingController();

  Future<List<ChatMessage>> listDataJSON() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _UserID = preferences.getString(Register_UserID);
    _CondoID = preferences.getString(StrCondo_ID);
    Map data = {'condo_id': _CondoID, 'residence_user_id': _UserID};
    var url = Uri.parse(GetAllMessageAPI);
    print('Payload : - ' + data.toString());
    var response = await http.post(url, body: data);
    if (response != null && response.statusCode == 200) {
      var jsonResponse = null;
      List loadedMsgdata;
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (jsonResponse['success'] == 1) {
         // EasyLoadingToastMessage(context, jsonResponse['message']);
          loadedMsgdata = jsonResponse['msgdata'];
          _Messageslst = loadedMsgdata
              .map((model) => ChatMessage.fromJson(model))
              .toList();
          print(_Messageslst.length);
          Timer(
            Duration(seconds: 1),
                () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
          );

        } else {
          EasyLoadingToastMessage(context, jsonResponse['message']);
        }
        return _Messageslst;
      }
    } else {
      throw Exception('Error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      home: Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.white,
        //   flexibleSpace: SafeArea(
        //       child: Container(
        //     padding: EdgeInsets.only(right: 16),
        //     child: Row(
        //       children: <Widget>[
        //         // IconButton(
        //         //   onPressed: (){
        //         //     Navigator.pop(context);
        //         //   },
        //         //   icon: Icon(Icons.arrow_back,color: Colors.black,),
        //         // ),
        //         SizedBox(
        //           width: 5,
        //         ),
        //         CircleAvatar(
        //           backgroundImage: NetworkImage(
        //               "https://images.pexels.com/photos/2820884/pexels-photo-2820884.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
        //           maxRadius: 20,
        //         ),
        //         SizedBox(
        //           width: 12,
        //         ),
        //         Expanded(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: <Widget>[
        //               Text(
        //                 "Admin",
        //                 style:
        //                     TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        //               ),
        //               SizedBox(
        //                 height: 6,
        //               ),
        //               //  Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
        //             ],
        //           ),
        //         ),
        //         //Icon(Icons.settings,color: Colors.black54,),
        //       ],
        //     ),
        //   )),
        // ),
        body: Stack(
          children: <Widget>[
            FutureBuilder(
                future: listDataJSON(),
                builder: (context, snapshot) {
                  // var beers = json.decode(snapshot.data.toString());
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return new ListView.builder(
                      controller: _scrollController,
                      itemCount: _Messageslst.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      padding: EdgeInsets.only(top: 10, bottom: 60),
                      itemBuilder: (context, index) {
                        var _msgItem = _Messageslst[index];
                        return Container(
                          padding:
                          EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                          child: Align(
                            alignment: (_msgItem.to_uid_type == "residence"
                                ? Alignment.topLeft
                                : Alignment.topRight),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (_msgItem.to_uid_type == "residence"
                                    ? Colors.grey.shade200
                                    : Colors.blue[200]),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Text(
                                _msgItem.msg_text,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _MessagetextController,
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if(_MessagetextController.text.isNotEmpty)
                          {
                           SendMessageRequest(_MessagetextController.text);
                          }
                        else
                          {
                            EasyLoadingToastMessage(context, StrmessageEnter);
                          }
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void SendMessageRequest(String strmessage) async {
    EasyLoading.show(status: 'Please Wait...');
    Map data = {
      'condo_id': _CondoID,
      'residence_user_id': _UserID,
      'msg_text': strmessage,
    };
    print(data.toString());
    var url = Uri.parse(SendMessageAPI);
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
          listDataJSON();
          setState(() {
           _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
           print("Position:- "+_scrollController.position.maxScrollExtent.toString());
          });
          _MessagetextController.clear();
          EasyLoadingToastMessage(context, jsonResponse['message']);

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
