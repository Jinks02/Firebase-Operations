import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool _loading = false;
  final databaseRef = FirebaseDatabase.instance
      .ref('Post'); // creates a node or table named post
  final _postController = TextEditingController();
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post Screen'),
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

              databaseRef.child(id).set({
                // datetime to give a unique id
                'description': _postController.text.toString(),
                'id': id
              }).then((value) {
                setState(() {
                  _loading = false;
                });
                utils.showToastMessage('Post added');
              }).onError((error, stackTrace) {
                setState(() {
                  _loading = false;
                });
                utils.showToastMessage(
                  error.toString(),
                );
              });
            }, _loading)
          ],
        ),
      ),
    );
  }
}
