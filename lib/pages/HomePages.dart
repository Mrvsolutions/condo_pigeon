import 'package:condo_pigeon/pages/AccountSettingPage.dart';
import 'package:condo_pigeon/pages/AnnouncementsListPage.dart';
import 'package:condo_pigeon/pages/AppToolbar.dart';
import 'package:condo_pigeon/pages/ChatDetailPage.dart';
import 'package:condo_pigeon/pages/PartyRoomListPage.dart';
import 'package:condo_pigeon/pages/ServiceElevetorListPage.dart';
import 'package:condo_pigeon/pages/chatPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomePages extends StatelessWidget {
  //const HomePages({Key? key}) : super(key: key);
  int _Indextab;
  HomePages(this._Indextab);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyStatefulWidget(_Indextab),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
 // const MyStatefulWidget({key}) : super(key: key);
  int _selectedIndex;
  MyStatefulWidget(@required this._selectedIndex);
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
 // int _selectedIndex = 0;
  final List<String> titleList = ["Announcement", "Party Room", "Service Elevetor","Messages","Setting"];
  String currentTitle;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  final _widgetOptions = [
    new AnnouncementsListPage(),
    new PartyRoomListPage(),
    new ServiceElevetorListPage(),
    new ChatDetailPage(),
    new AccountSettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget._selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    currentTitle = titleList[widget._selectedIndex];
    return Scaffold(
      appBar: AppToolbar(context, currentTitle,false),
      body: Center(
        child: _widgetOptions.elementAt(widget._selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
       // type: BottomNavigationBarType.fixed,
       // showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/ic_announcement.png")),
            label: 'Announcement',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/ic_partyroom.png")),
            label: 'Party Room',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/ic_service_elevator.png")),
            label: 'Service Elevetor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: widget._selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }


}
