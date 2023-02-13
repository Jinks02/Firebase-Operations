import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/ui/auth/verify_phone_code_screen.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({Key? key}) : super(key: key);

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  final _phoneNumberController = TextEditingController();
  bool _loading = false;
  final _auth = FirebaseAuth.instance;
  Utils utils = Utils();

 // void verificationComplete
 //      (PhoneAuthCredential credential) async {
 //    await _auth.signInWithCredential(credential).then((value) async {
 //      if (value.user != null) {
 //        log("Done !!", name: "verificationCompleted");
 //      } else {
 //        log("Failed!!", name: "verificationCompleted");
 //      }
 //    }).catchError((e) {
 //      Fluttertoast.showToast(msg: 'Something Went Wrong: ${e.toString()}');
 //    });
 //  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with phone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _phoneNumberController,
              decoration: InputDecoration(hintText: '+91 1234567897'),
            ),
            SizedBox(
              height: 60,
            ),
            customButton('Login', () {
              // todo implement request to firebase to send verification code
              setState(() {
                _loading=true;
              });
              _auth.verifyPhoneNumber(
                  phoneNumber: _phoneNumberController.text.trim(),
                  verificationCompleted: (context) {

                    setState(() {
                      _loading=false;
                    });
                  },
                  verificationFailed: (error) {
                    utils.showToastMessage(error.toString());
                    debugPrint('in verification failed');
                    setState(() {
                      _loading=false;
                    });
                  },
                  codeSent: (String verificationID, int? token) {
                    // we get verification id and otp code ie. token
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VerifyCodeScreen(verificationId: verificationID,),
                      ),
                    );
                    setState(() {
                      _loading=false;
                    });
                  },
                  codeAutoRetrievalTimeout: (error) {
                    utils.showToastMessage(error.toString());
                    debugPrint('in code timeout');
                    setState(() {
                      _loading=false;
                    });
                  });
            }, _loading),
          ],
        ),
      ),
    );
  }
}
