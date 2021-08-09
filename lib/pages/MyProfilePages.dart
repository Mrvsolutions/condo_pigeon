import 'dart:convert';
import 'dart:io';
import 'package:condo_pigeon/api/api.dart';
import 'package:condo_pigeon/model/UserProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:condo_pigeon/Comman/Util.dart';
import 'package:condo_pigeon/Comman/string.dart';
import 'package:condo_pigeon/pages/AppToolbar.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyProfilePages extends StatefulWidget {
  @override
  _MyProfilePagesState createState() => _MyProfilePagesState();
}

class _MyProfilePagesState extends State<MyProfilePages> {
  final FocusNode myFocusNode = FocusNode();
  var _titleheading = "My Profile";
  DateTime currentDate = DateTime.now();
  String dateTime;
  DateTime selectedDate = DateTime.now();
  File _image;
  String _UserID,_Apart_No;
  String Uploaded_pimgUrl;
  SharedPreferences preferences;
  // TextEditingController _dateController = TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _contactController = new TextEditingController();
  final ImagePicker _picker = ImagePicker();
  // Future<Null> _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       initialDatePickerMode: DatePickerMode.day,
  //       firstDate: DateTime(1900),
  //       lastDate: DateTime(2100));
  //   if (picked != null)
  //     setState(() {
  //       selectedDate = picked;
  //       // _dateController.text = DateFormat.yMd().format(selectedDate);
  //       _dateController.text =
  //           formatDate(selectedDate, [dd, '/', mm, '/', yyyy]);
  //     });
  // }
  @override
  void initState() {
    //_dateController.text = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);
    super.initState();
        () async {
      await GetSharePrefrenceValue();
      setState(() {
      });
    } ();

  }
  Future GetSharePrefrenceValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _nameController.text = preferences.getString(StrUserName);
    _emailController.text = preferences.getString(StrUserEmail);
    Uploaded_pimgUrl = preferences.getString(Strru_profile_pic);
    _contactController.text = preferences.getString(StrContactNumber);
    _UserID = preferences.getString(Register_UserID);
    _Apart_No = preferences.getString(Strapt_no);
  }

  _imgFromCamera() async {
  //  File image = await ImagePicker.pickImage(source: ImageSource.camera);
   PickedFile pickedFile = await _picker.getImage(source: ImageSource.camera);
   final File image = File(pickedFile.path);

    setState(() {
      _image = image;
      UploadProfilePicRequest();
    });
  }

  _imgFromGallery() async {
  //  File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    PickedFile pickedFile = await _picker.getImage(source: ImageSource.gallery);
    final File image = File(pickedFile.path);
    setState(() {
      _image = image;
      UploadProfilePicRequest();
    });
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
   // dateTime = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]); //DateFormat.yMd().format(DateTime.now());
    return MaterialApp(
      builder: EasyLoading.init(),
      home: new Scaffold(
          appBar: AppToolbar(context, _titleheading, true),
          body: new Container(
            color: Colors.white,
            child: new ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    new Container(
                      height: 130.0,
                      color: Colors.blue,
                      child: Image.asset(
                        "assets/bg_img.png",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                        color: Colors.blue.withOpacity(0.4),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: Stack( children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white,
                              child: Uploaded_pimgUrl != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  Uploaded_pimgUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(50)),
                                width: 100,
                                height: 100,
                                child: Image.asset('assets/person.png'),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 60.0, left: 100.0, right: 10),
                            child: InkWell(
                              onTap: (){
                                _showPicker(context);
                              },
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 16.0,
                                    child: Image.asset(
                                      "assets/ic_camera.png",
                                      width: 17,
                                      height: 17,
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ]),
                    ),
                    new Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: 15, top: 180, left: 25, right: 25),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Center(
                                child: Text(
                              _nameController.text,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24),
                            )),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                  hintText: "Enter Name", labelText: "Name"),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _emailController,
                              readOnly: true,
                              decoration: InputDecoration(
                                  hintText: "Enter E-Mail",
                                  labelText: "E-Mail"),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _contactController,
                              decoration: InputDecoration(
                                  hintText: "Enter Contact Number",
                                  labelText: "Contact"),
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     _selectDate(context);
                            //   },
                            //   child: TextFormField(
                            //     decoration: InputDecoration(
                            //         hintText: "Enter Date of birth",
                            //         labelText: "Date of Birth"),
                            //     style: TextStyle(
                            //         color: Colors.black,
                            //         fontFamily: "Montserrat",
                            //         fontWeight: FontWeight.w600,
                            //         fontSize: 18),
                            //     keyboardType: TextInputType.datetime,
                            //     enabled: false,
                            //     controller: _dateController,
                            //     onSaved: (String val) {
                            //       _setDate = val;
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: RaisedButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => VerifyEmailPage()),
                          // );
                          if (_nameController.text.isNotEmpty &&
                              _contactController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty) {
                            EditProfileRequest(_nameController.text,
                                _emailController.text, _contactController.text);
                          }
                        },
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                        color: Colors.blue,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void UploadProfilePicRequest() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String base64Image = base64Encode(_image.readAsBytesSync());
    String fileName = _image.path.split("/").last;
    EasyLoading.show(status: 'Please Wait...');
    print('_UserID:- '+_UserID+'\nfilename:-'+fileName+'\nImageencode:- '+base64Image);
     var url = Uri.parse(UploadProfilePicAPI);
    http.post(url, body: {
      "residence_user_id": _UserID,
      "ru_profile_pic": base64Image,
      "name": fileName,
    }).then((res) {
      print(res.statusCode);
      if (res.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(res.body);
        if (jsonResponse != null) {
          EasyLoading.dismiss();
          if (jsonResponse['success'] == 1) {
            Uploaded_pimgUrl = jsonResponse['pimgUrl'];
            print("pimgUrl -  "+ Uploaded_pimgUrl.toString());
            setState(() {
            });
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
        print(res.body);
      }
    }).catchError((err) {
      EasyLoading.dismiss();
      EasyLoadingToastMessage(context, 'Please Try again letter, image not uploaded');
      print('error image upload - '+err.toString());
    });
  }
  void EditProfileRequest(String StrName, StrEmail, StrContact) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // var UserID = preferences.getString(Register_UserID);
    EasyLoading.show(status: 'Please Wait...');
    Map data = {
      'residence_user_id': _UserID,
      'apt_no': _Apart_No,
      'resident_name': StrName,
      'resident_contactno': StrContact,
      'resident_email': StrEmail,
    };
    print(data.toString());
    var url = Uri.parse(EditProfileAPI);
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
          List userdata = jsonResponse['userdata'];
          var _userProfile = userdata
              .map((model) => UserProfile.fromJson(model))
              .toList();
          print("userdata -  "+_userProfile.toString());
          sharedPreferences.setString(Register_UserID, _userProfile[0].residence_user_id);
          sharedPreferences.setString(StrCondo_ID, _userProfile[0].condo_id);
          sharedPreferences.setString(StrUserName,_userProfile[0].resident_name);
          sharedPreferences.setString(StrUserEmail, _userProfile[0].resident_email);
          sharedPreferences.setString(StrContactNumber, _userProfile[0].resident_contactno);
          sharedPreferences.setString(Strru_profile_pic, _userProfile[0].ru_profile_pic);
          String msg = jsonResponse['message']+", CondoID:"+_userProfile[0].condo_id+", Name: "+_userProfile[0].resident_name+","
              " USERID: "+_userProfile[0].residence_user_id+", USER_Contanct: "+_userProfile[0].resident_contactno;
          print('Message: - ' + msg);
          EasyLoadingToastMessage(context, jsonResponse['message']);
          setState(() {
          });
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
