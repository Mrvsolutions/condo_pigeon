import 'package:flutter/cupertino.dart';

class ChatMessage {
  String msg_id;
  String condo_id;
  String to_uid;
  String to_uid_type;
  String from_uid;
  String from_uid_type;
  String msg_text;
  String msg_date;
  String msg_time;
  String msg_isread;

  ChatMessage(
      String msg_id,
      String condo_id,
      String to_uid,
      String to_uid_type,
      String from_uid,
      String from_uid_type,
      String msg_text,
      String msg_date,
      String msg_time,
      String msg_isread) {
    this.msg_id = msg_id;
    this.condo_id = condo_id;
    this.to_uid = to_uid;
    this.to_uid_type = to_uid_type;
    this.from_uid = from_uid;
    this.from_uid_type = from_uid_type;
    this.msg_text = msg_text;
    this.msg_date = msg_date;
    this.msg_time = msg_time;
    this.msg_isread = msg_isread;
  }
  ChatMessage.fromJson(Map json)
      : msg_id = json['msg_id'],
        condo_id = json['condo_id'],
        to_uid = json['to_uid'],
        to_uid_type = json['to_uid_type'],
        from_uid = json['from_uid'],
        from_uid_type = json['from_uid_type'],
        msg_text = json['msg_text'],
        msg_date = json['msg_date'],
        msg_time = json['msg_time'],
        msg_isread = json['msg_isread'];

  Map toJson() {
    return {'msg_id': msg_id, 'condo_id': condo_id, 'to_uid': to_uid,
      'to_uid_type': to_uid_type, 'from_uid': from_uid, 'from_uid_type': from_uid_type,
      'msg_text': msg_text, 'msg_date': msg_date, 'msg_time': msg_time,'msg_isread': msg_isread,};
  }
}
