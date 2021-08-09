import 'package:condo_pigeon/model/chatUsersModel.dart';
import 'package:condo_pigeon/pages/conversationList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsers> chatUsers = [
    ChatUsers(name: "Pinkal Patel", messageText: "Hello Chat Done", imageURL: "https://images.pexels.com/photos/2820884/pexels-photo-2820884.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", time: "Now"),
    ChatUsers(name: "Vimal Parmar", messageText: "Busy! Call me in 20 mins", imageURL: "https://picsum.photos/250?image=9", time: "Yesterday"),
    ChatUsers(name: "Pradip Sojitra", messageText: "That's Great", imageURL: "https://images.pexels.com/photos/2899097/pexels-photo-2899097.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", time: "31 Mar"),
    ChatUsers(name: "Manoj Thori", messageText: "Hey where are you?", imageURL: "https://picsum.photos/250?image=9", time: "28 Mar"),
    ChatUsers(name: "Riya", messageText: "That's Great", imageURL: "https://images.pexels.com/photos/213780/pexels-photo-213780.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", time: "28 Mar"),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
       itemCount: chatUsers.length,
      // shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 10),
      itemBuilder: (context, index){
        return ConversationList(
          name: chatUsers[index].name,
          messageText: chatUsers[index].messageText,
          imageUrl: chatUsers[index].imageURL,
          time: chatUsers[index].time,
          isMessageRead: (index == 0 || index == 3)?true:false,
        );
      },
    );
  }
}
