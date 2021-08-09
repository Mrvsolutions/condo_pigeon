import 'dart:convert';

class UserProfile {
  String residence_user_id;
  String condo_id;
  String resident_name;
  String resident_email;
  String resident_contactno;
  String chng_pswd_rqst;
  String apt_no;
  String ru_profile_pic;

  UserProfile(String residence_user_id, String condo_id ,String resident_name, String resident_email,String resident_contactno,String chng_pswd_rqst, String apt_no, String ru_profile_pic) {
    this.residence_user_id = residence_user_id;
    this.condo_id = condo_id;
    this.resident_name = resident_name;
    this.resident_email = resident_email;
    this.resident_contactno = resident_contactno;
    this.chng_pswd_rqst = chng_pswd_rqst;
    this.apt_no = apt_no;
    this.ru_profile_pic = ru_profile_pic;
  }

  UserProfile.fromJson(Map json)
      : residence_user_id = json['residence_user_id'],
        condo_id = json['condo_id'],
        resident_name = json['resident_name'],
        resident_email = json['resident_email'],
        resident_contactno = json['resident_contactno'],
        chng_pswd_rqst = json['chng_pswd_rqst'],
        apt_no = json['apt_no'],
        ru_profile_pic = json['ru_profile_pic'];


  Map toJson() {
    return {'residence_user_id': residence_user_id, 'condo_id':condo_id,'resident_name': resident_name, 'resident_email': resident_email,'resident_contactno': resident_contactno,'chng_pswd_rqst':chng_pswd_rqst,'apt_no':apt_no,'ru_profile_pic':ru_profile_pic};
  }
}