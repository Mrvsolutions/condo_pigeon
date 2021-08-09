import 'dart:convert';

import 'package:flutter/material.dart';

class PartyRoomItem {
  String party_id;
  String condo_id;
  String pr_rqst_datetime;
  String pr_eventname;
  String pr_evnt_desc;
  String pr_startdate;
  String pr_enddate;
  String pr_rqst_status;
  String residence_user_id;
  String sts_change_by;
  String sts_change_datetime;

  PartyRoomItem(
      String party_id,
      String condo_id,
      String pr_rqst_datetime,
      String pr_eventname,
      String pr_evnt_desc,
      String pr_startdate,
      String pr_enddate,
      String pr_rqst_status,
      String residence_user_id,
      String sts_change_by,
      String sts_change_datetime) {
    this.party_id = party_id;
    this.condo_id = condo_id;
    this.pr_rqst_datetime = pr_rqst_datetime;
    this.pr_eventname = pr_eventname;
    this.pr_evnt_desc = pr_evnt_desc;
    this.pr_startdate = pr_startdate;
    this.pr_enddate = pr_enddate;
    this.pr_rqst_status = pr_rqst_status;
    this.residence_user_id = residence_user_id;
    this.sts_change_by = sts_change_by;
    this.sts_change_datetime = sts_change_datetime;
  }

  PartyRoomItem.fromJson(Map json)
      : party_id = json['party_id'],
        condo_id = json['condo_id'],
        pr_rqst_datetime = json['pr_rqst_datetime'],
        pr_eventname = json['pr_eventname'],
        pr_evnt_desc = json['pr_evnt_desc'],
        pr_startdate = json['pr_startdate'],
        pr_enddate = json['pr_enddate'],
        pr_rqst_status = json['pr_rqst_status'],
        residence_user_id = json['residence_user_id'],
        sts_change_by = json['sts_change_by'],
        sts_change_datetime = json['sts_change_datetime'];

  Map toJson() {
    return {'party_id': party_id, 'condo_id': condo_id, 'pr_rqst_datetime': pr_rqst_datetime,
      'pr_eventname': pr_eventname, 'pr_evnt_desc': pr_evnt_desc, 'pr_startdate': pr_startdate,
      'pr_enddate': pr_enddate, 'pr_rqst_status': pr_rqst_status, 'residence_user_id': residence_user_id,
      'sts_change_by': sts_change_by,'sts_change_datetime': sts_change_datetime,};
  }
  static Map<String, dynamic> toMap(PartyRoomItem partyroomitem) => {
    'party_id': partyroomitem.party_id,
    'condo_id': partyroomitem.condo_id,
    'pr_rqst_datetime': partyroomitem.pr_rqst_datetime,
    'pr_eventname': partyroomitem.pr_eventname,
    'pr_evnt_desc': partyroomitem.pr_evnt_desc,
    'pr_startdate': partyroomitem.pr_startdate,
    'pr_enddate': partyroomitem.pr_enddate,
    'pr_rqst_status': partyroomitem.pr_rqst_status,
    'residence_user_id': partyroomitem.residence_user_id,
    'sts_change_by': partyroomitem.sts_change_by,
    'sts_change_datetime': partyroomitem.sts_change_datetime,
  };

  static String encode(List<PartyRoomItem> partyRoomlst) => json.encode(
    partyRoomlst
        .map<Map<String, dynamic>>((partyroomitm) => PartyRoomItem.toMap(partyroomitm))
        .toList(),
  );

  static List<PartyRoomItem> decode(String partyroomsitms) =>
      (json.decode(partyroomsitms) as List<dynamic>)
          .map<PartyRoomItem>((item) => PartyRoomItem.fromJson(item))
          .toList();
}
