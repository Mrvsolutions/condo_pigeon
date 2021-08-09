import 'dart:convert';

import 'package:flutter/material.dart';

class ServiceElevetorItem {
  String srvcelvtr_id;
  String condo_id;
  String se_rqst_datetime;
  String se_date;
  String se_starttime;
  String se_endtime;
  String se_rqst_status;
  String residence_user_id;
  String se_sts_change_by;
  String se_sts_change_datetime;

  ServiceElevetorItem(
      String srvcelvtr_id,
      String condo_id,
      String se_rqst_datetime,
      String se_date,
      String se_starttime,
      String se_endtime,
      String se_rqst_status,
      String residence_user_id,
      String se_sts_change_by,
      String se_sts_change_datetime) {
    this.srvcelvtr_id = srvcelvtr_id;
    this.condo_id = condo_id;
    this.se_rqst_datetime = se_rqst_datetime;
    this.se_date = se_date;
    this.se_starttime = se_starttime;
    this.se_endtime = se_endtime;
    this.se_rqst_status = se_rqst_status;
    this.residence_user_id = residence_user_id;
    this.se_sts_change_by = se_sts_change_by;
    this.se_sts_change_datetime = se_sts_change_datetime;
  }

  ServiceElevetorItem.fromJson(Map json)
      : srvcelvtr_id = json['srvcelvtr_id'],
        condo_id = json['condo_id'],
        se_rqst_datetime = json['se_rqst_datetime'],
        se_date = json['se_date'],
        se_starttime = json['se_starttime'],
        se_endtime = json['se_endtime'],
        se_rqst_status = json['se_rqst_status'],
        residence_user_id = json['residence_user_id'],
        se_sts_change_by = json['se_sts_change_by'],
        se_sts_change_datetime = json['se_sts_change_datetime'];

  Map toJson() {
    return {'srvcelvtr_id': srvcelvtr_id, 'condo_id': condo_id, 'se_rqst_datetime': se_rqst_datetime,
      'se_date': se_date, 'se_starttime': se_starttime,
      'se_endtime': se_endtime, 'se_rqst_status': se_rqst_status, 'residence_user_id': residence_user_id,
      'se_sts_change_by': se_sts_change_by,'se_sts_change_datetime': se_sts_change_datetime,};
  }
  static Map<String, dynamic> toMap(ServiceElevetorItem serviceeleitem) => {
    'srvcelvtr_id': serviceeleitem.srvcelvtr_id,
    'condo_id': serviceeleitem.condo_id,
    'se_rqst_datetime': serviceeleitem.se_rqst_datetime,
    'se_date': serviceeleitem.se_date,
    'se_starttime': serviceeleitem.se_starttime,
    'se_endtime': serviceeleitem.se_endtime,
    'se_rqst_status': serviceeleitem.se_rqst_status,
    'residence_user_id': serviceeleitem.residence_user_id,
    'se_sts_change_by': serviceeleitem.se_sts_change_by,
    'se_sts_change_datetime': serviceeleitem.se_sts_change_datetime,
  };

  static String encode(List<ServiceElevetorItem> servicelevetorlst) => json.encode(
    servicelevetorlst
        .map<Map<String, dynamic>>((serviceitem) => ServiceElevetorItem.toMap(serviceitem))
        .toList(),
  );

  static List<ServiceElevetorItem> decode(String serviceelvtrtms) =>
      (json.decode(serviceelvtrtms) as List<dynamic>)
          .map<ServiceElevetorItem>((item) => ServiceElevetorItem.fromJson(item))
          .toList();
}
