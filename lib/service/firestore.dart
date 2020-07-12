import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_sample/model/user.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._constructor();

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._constructor();

  final Firestore _firestore = Firestore.instance;

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
