import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart%20';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String userName = "Dummy Name";
  String userEmail = "Dummy Email";
  String userId = "Dummy Id";

  var db = FirebaseFirestore.instance;

  void getUserDetails() {
    var authUser = FirebaseAuth.instance.currentUser;
    db.collection("users").doc(authUser!.uid).get().then((dataSnapshot) {
      userName = dataSnapshot.data()?["name"] ?? "";
      userEmail = dataSnapshot.data()?["email"] ?? "";
      userId = dataSnapshot.data()?["id"] ?? "";
      notifyListeners();
    });
  }
}
