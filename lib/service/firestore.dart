import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_sample/model/user.dart';

class FirestoreService {
  static final _instance = FirestoreService._constructor();

  factory FirestoreService() => _instance;

  FirestoreService._constructor();

  final Firestore _firestore = Firestore.instance;

  Future checkUsername(String username) async {
    try {
      return await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .getDocuments();
    } catch (error) {
      return error;
    }
  }

  Future setUserData(User user) async {
    try {
      return await _firestore
          .collection('users')
          .document(user.uid)
          .setData(user.toMap());
    } catch (error) {
      return error;
    }
  }
}
