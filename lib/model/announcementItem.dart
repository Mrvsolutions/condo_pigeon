import 'package:flutter/material.dart';

class AnnouncementItem {
  String ancmnt_id;
  String condo_id;
  String ancmnt_datetime;
  String ancmnt_title;
  String ancment_description;
  String ancmnt_img;
  String ancmnt_mode;
  String ack_id;
  String residence_user_id;
  String ack_status;

  AnnouncementItem(
      String ancmnt_id,
      String condo_id,
      String ancmnt_datetime,
      String ancmnt_title,
      String ancment_description,
      String ancmnt_img,
      String ancmnt_mode,
      String ack_id,
      String residence_user_id,
      String ack_status) {
    this.ancmnt_id = ancmnt_id;
    this.condo_id = condo_id;
    this.ancmnt_datetime = ancmnt_datetime;
    this.ancmnt_title = ancmnt_title;
    this.ancment_description = ancment_description;
    this.ancmnt_img = ancmnt_img;
    this.ancmnt_mode = ancmnt_mode;
    this.ack_id = ack_id;
    this.residence_user_id = residence_user_id;
    this.ack_status = ack_status;
  }

  AnnouncementItem.fromJson(Map json)
      : ancmnt_id = json['ancmnt_id'],
        condo_id = json['condo_id'],
        ancmnt_datetime = json['ancmnt_datetime'],
        ancmnt_title = json['ancmnt_title'],
        ancment_description = json['ancment_description'],
        ancmnt_img = json['ancmnt_img'],
        ancmnt_mode = json['ancmnt_mode'],
        ack_id = json['ack_id'],
        residence_user_id = json['residence_user_id'],
        ack_status = json['ack_status'];

  Map toJson() {
    return {'ancmnt_id': ancmnt_id, 'condo_id': condo_id, 'ancmnt_datetime': ancmnt_datetime,
      'ancmnt_title': ancmnt_title, 'ancment_description': ancment_description, 'ancmnt_img': ancmnt_img,
      'ancmnt_mode': ancmnt_mode, 'ack_id': ack_id, 'residence_user_id': residence_user_id,'ack_status': ack_status,};
  }
}
