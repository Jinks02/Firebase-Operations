import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/ui/post/post_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/custom_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final verificationId;
  const VerifyCodeScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _otpController = TextEditingController();
  bool _loading = false;
  final _auth = FirebaseAuth.instance;
  Utils utils = Utils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify otp code'),
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
              controller: _otpController,
              decoration: InputDecoration(hintText: '6 digit code'),
            ),
            SizedBox(
              height: 60,
            ),
            customButton('Verify', () async {
              setState(() {
                _loading = true;
              });

              final credentials = PhoneAuthProvider.credential(
                verificationId: widget.verificationId,
                smsCode: _otpController.text.trim(),
              );
              try {
                await _auth.signInWithCredential(credentials);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PostScreen(),
                  ),

                );
                debugPrint('verification success');

                setState(() {
                  _loading = false;
                });
              } catch (e) {
                setState(() {
                  _loading = false;
                });
                utils.showToastMessage(
                  e.toString(),
                );
                debugPrint('in catch of verify screen');
              }
            }, _loading),
          ],
        ),
      ),
    );
  }
}
