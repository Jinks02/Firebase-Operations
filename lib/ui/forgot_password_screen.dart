import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  Utils utils = Utils();
  final _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("forgot pass screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "email"
                  ),
                ),

            SizedBox(height: 40,),

            customButton('Forgot', () {
                  _auth.sendPasswordResetEmail(email: _emailController.text).then((value) {
                    utils.showToastMessage('reset password email sent');
                  }).onError((error, stackTrace) {
                    utils.showToastMessage('error in resetting password');
                  });
            }, false)
          ],
        ),
      ),
    );
  }
}
