// ignore_for_file: file_names

import 'dart:convert';

class User {
  String? id;
  String? uid;
  String? uName;
  String? uPassword;
  String? uGroup;
  String? uFirstname;
  String? uLastname;
  String? uActive;
  User({
    this.id,
    this.uid,
    this.uName,
    this.uPassword,
    this.uGroup,
    this.uFirstname,
    this.uLastname,
    this.uActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'uName': uName,
      'uPassword': uPassword,
      'uGroup': uGroup,
      'uFirstname': uFirstname,
      'uLastname': uLastname,
      'uActive': uActive,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      uid: map['uid'],
      uName: map['uName'],
      uPassword: map['uPassword'],
      uGroup: map['uGroup'],
      uFirstname: map['uFirstname'],
      uLastname: map['uLastname'],
      uActive: map['uActive'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
