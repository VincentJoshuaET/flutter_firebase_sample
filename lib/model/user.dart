import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  String uid;
  String firstName;
  String middleName;
  String lastName;
  String mobile;
  String location;
  String gender;
  Timestamp dateOfBirth;
  String image;

  User(
      {@required this.uid,
      @required this.firstName,
      @required this.middleName,
      @required this.lastName,
      @required this.mobile,
      @required this.location,
      @required this.gender,
      @required this.dateOfBirth,
      this.image});

  User.fromMap(Map<String, dynamic> snapshot)
      : uid = snapshot['uid'] as String ?? '',
        firstName = snapshot['firstName'] as String ?? '',
        middleName = snapshot['middleName'] as String ?? '',
        lastName = snapshot['lastName'] as String ?? '',
        mobile = snapshot['mobile'] as String ?? '',
        location = snapshot['location'] as String ?? '',
        gender = snapshot['gender'] as String ?? '',
        dateOfBirth = snapshot['dateOfBirth'] as Timestamp ?? Timestamp.now(),
        image = snapshot['image'] as String;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'mobile': mobile,
      'location': location,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'image': image
    };
  }
}
