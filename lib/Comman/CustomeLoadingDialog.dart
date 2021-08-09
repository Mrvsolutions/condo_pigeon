import 'package:condo_pigeon/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomeLoadingDialog extends StatelessWidget {
  final title;

  CustomeLoadingDialog(this.title);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(
              Radius.circular(10.0))),
      //title: Text('Alert'),
      content: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Builder(
          builder: (context){
            var height = MediaQuery.of(context).size.height/6;
            var width = MediaQuery.of(context).size.width/3;
           return Center(
             child: Container(
               alignment: Alignment.center,
                color: Colors.black,
                height: height ,
                width: width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 2,
                      ),
                      SizedBox(height: 10,),
                      Text(title,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                    ]
                ),
              ),
           );
          }
        ),
      ),
    );
  }
}