import 'dart:developer';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _imageFile;
  final _picker = ImagePicker();

  // firebase_storage.FirebaseStorage _firebaseStorage = firebase_storage.FirebaseStorage.instance
  FirebaseStorage _firebaseStorageInstance = FirebaseStorage.instance;

  DatabaseReference _firebaseDatabaseRef =
      FirebaseDatabase.instance.ref('Post');

  Utils utils = Utils();

  bool loading = false;

  Future getGalleryImage() async {
    // final pickedFile = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 80 );
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    // to capture img from cam pick img source.cam
    // img quality is optional, 80 means low quality

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        debugPrint('no file picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('upload image screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  // todo request access to gallery
                  getGalleryImage();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: _imageFile != null
                      ? Image.file(
                          _imageFile!.absolute,
                          fit: BoxFit.fill,
                        )
                      : Icon(Icons.image),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            customButton('Upload', () async {
              // todo firebse storage operation

              setState(() {
                loading = true;
              });

              // Reference firebaseStorageRef =
                  // FirebaseStorage.instance.ref('/folderName').child('images');  // image name must be unique
              Reference firebaseStorageRef = FirebaseStorage.instance.ref('/folderName/' + 'fileName');

              UploadTask uploadTask =
                  firebaseStorageRef.putFile(_imageFile!.absolute);

              Future.value(uploadTask).then((value) async {
                var imgUrl = await firebaseStorageRef.getDownloadURL();

                final id = DateTime.now().millisecondsSinceEpoch.toString();
                _firebaseDatabaseRef.child(id).set({
                  'id':id,
                  'url':imgUrl
                }).then((value) {
                  setState(() {
                    loading=false;
                  });
                  utils.showToastMessage('uploaded to realtime db');
                }).onError((error, stackTrace) {
                  setState(() {
                    loading=false;
                  });
                  utils.showToastMessage('error in uploading');
                });
              }).onError((error, stackTrace) {
                setState(() {
                  loading=false;
                });
                utils.showToastMessage('error in uploading1');
              });

              // await Future.value(uploadTask).then((value) async {
              //   var imgUrl =
              //       await firebaseStorageRef.getDownloadURL().toString();
              //
              //   final id = DateTime.now().millisecondsSinceEpoch.toString();
              //   _firebaseDatabaseRef
              //       .child(id)
              //       .set({'id': id, 'url': imgUrl.toString()}).then((value) {
              //     setState(() {
              //       loading = false;
              //     });
              //     utils.showToastMessage("uploaded in realtime db");
              //   }).onError((error, stackTrace) {
              //     setState(() {
              //       loading = false;
              //     });
              //     utils.showToastMessage("error in uploading in realtime db");
              //   });
              // }).onError((error, stackTrace) {});
              //
              // setState(() {
              //   loading = false;
              // });
              // utils.showToastMessage("error in uploading in realtime db");
            }, loading),
          ],
        ),
      ),
    );
  }
}
