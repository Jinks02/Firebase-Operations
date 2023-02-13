import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/ui/auth/login_screen.dart';
import 'package:firebase_practice/ui/firestore/firestore_list_screen.dart';
import 'package:firebase_practice/ui/upload_image_screen.dart';
import 'package:flutter/material.dart';

import '../ui/post/post_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final _auth = FirebaseAuth.instance;

    final user = _auth.currentUser.toString();
    // debugPrint(user);

    if (_auth.currentUser != null) {
      Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).push(
          MaterialPageRoute(
            // builder: (context) => UploadImageScreen(),
            builder: (context) => FirestoreScreen(),
          ),
        ),
      );
    } else {
      Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).push(
          MaterialPageRoute(
            // builder: (context) => UploadImageScreen(),
            builder: (context) => LoginScreen(),
          ),
        ),
      );
    }
  }
}
