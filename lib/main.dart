import 'package:condo_pigeon/Comman/string.dart';
import 'package:condo_pigeon/pages/HomePages.dart';
import 'package:condo_pigeon/pages/MyProfilePages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/LoginPage.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
Future main() async{
  String  _loginStatus = "";
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  String token = await FirebaseMessaging.instance.getToken();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  _loginStatus = preferences.getString("message");
  print('token: - ' + token);
  // await saveTokenToDatabase(token);
  runApp(MaterialApp(
    title: "Condo Pigeon",
     home: MyAPP(_loginStatus),
   // home: (_loginStatus == LOGIN_COMPLETE)? HomePages(): LoginPage()
  ));
}
class MyAPP extends StatefulWidget {
 // const MyAPP({Key key}) : super(key: key);
    String logined;
    MyAPP(@required this.logined);
  @override
  _MyAPPState createState() => _MyAPPState();
}

class _MyAPPState extends State<MyAPP> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      // if (message != null) {
      //   Navigator.pushNamed(context, '/message',
      //       arguments: MessageArguments(message, true));
      // }
      print("initState:- Condo 1");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      print("Onmessage:- Condo 1");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print("onMessageOpenedApp:- Condo 2");

    });

  }
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ( widget.logined == LOGIN_COMPLETE)? HomePages(0): LoginPage()
    ],);
  }
}

