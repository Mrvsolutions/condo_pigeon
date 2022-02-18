import 'package:condo_pigeon/pages/AddPartyRoomPage.dart';
import 'package:condo_pigeon/pages/AddServiceElevetor.dart';
import 'package:condo_pigeon/pages/HomePages.dart';
import 'package:condo_pigeon/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

PreferredSize AppToolbar(
    BuildContext context, String _titleheading, bool _isVisibleBack, bool IsFromForgotorSignup) {
  bool _isVisible = false;
  bool _IsHomeIconShow = false;
  int selectedindix = 0;
  if (_titleheading == "Add Party Room") {
    selectedindix = 1;
  } else if (_titleheading == "Add Service Elevetor") {
    selectedindix = 2;
  } else if (_titleheading.contains("My Profile") || _titleheading.contains("Change Password")) {
    selectedindix = 4;
  }
  if (_titleheading == "Party Room" ||
      _titleheading == "Service Elevetor" ||
      _titleheading.contains("Add") ||
      _titleheading.contains("Change") ||
      _titleheading.contains("My")) {
    _isVisible = true;
  }

  if (_titleheading.contains("Add") ||
      _titleheading.contains("Change") ||
      _titleheading.contains("My")) {
    _IsHomeIconShow = true;
  }
  return PreferredSize(
    preferredSize: Size.fromHeight(95.0),
    child: AppBar(
      toolbarHeight: 90,
      flexibleSpace: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 35,
                    child: Visibility(
                      visible: _isVisibleBack,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                        onPressed: () {
                           // Navigator.of(context).pop(true);
                          if (IsFromForgotorSignup) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginPage()),
                                    (Route<dynamic> route) => false);
                          }
                          else {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomePages(selectedindix)),
                                    (Route<dynamic> route) => false);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isVisible,
                  child: FlatButton(
                    onPressed: () {
                      if (_titleheading == "Party Room") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddPartyRoomPage()),
                        );
                      } else if (_titleheading == "Service Elevetor") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddServiceElevetor()),
                        );
                      } else if (_IsHomeIconShow) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HomePages(selectedindix)),
                            (Route<dynamic> route) => false);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Icon(
                        _IsHomeIconShow ? Icons.home : Icons.add_circle,
                        color: Colors.black,
                        size: 35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  _titleheading,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ]),
        ),
      ),
      backgroundColor: Colors.white,
    ),
  );
}
