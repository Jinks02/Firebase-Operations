import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({Key? key}) : super(key: key);

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {
  bool _loading = false;
  final _postController = TextEditingController();
  Utils utils = Utils();
  final _firestoreCollectionInstance = FirebaseFirestore.instance
      .collection('users'); // creating a collection called users

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Firestore data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              maxLines: 4,
              controller: _postController,
              decoration: InputDecoration(
                  hintText: "What's in your mind?",
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 30,
            ),
            customButton('Add', () {
              setState(() {
                _loading = true;
              });

              final id = DateTime.now().millisecondsSinceEpoch.toString();
              _firestoreCollectionInstance
                  .doc(id // giving id as id to document created
                      )
                  .set({
                'description': _postController.text.toString(),
                'id': id
              }).then((value) {
                setState(() {
                  _loading = false;
                });
                utils.showToastMessage("post added");
              }).onError((error, stackTrace) {
                setState(() {
                  _loading = false;
                });
                utils.showToastMessage(error.toString());
              }); // creating document of collection
            }, _loading)
          ],
        ),
      ),
    );
  }
}
