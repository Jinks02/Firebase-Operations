import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_practice/ui/auth/login_screen.dart';
import 'package:firebase_practice/ui/post/add_post_screen.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _auth = FirebaseAuth.instance;
  Utils utils = Utils();
  final firebaseDbRef = FirebaseDatabase.instance.ref('Post');
  final _searchFilterController = TextEditingController();
  final _editPostController = TextEditingController();

  Future<void> showUpdatePostDialog(String description, String id) async {
    _editPostController.text = description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: Container(
              child: TextField(
                maxLines: 4,
                decoration: InputDecoration(hintText: 'Edit'),
                controller: _editPostController,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  firebaseDbRef.child(id).update({
                    'description' : _editPostController.text.toString(),
                  }).then((value) {
                    utils.showToastMessage("Update successful");
                  }).onError((error, stackTrace) {
                    utils.showToastMessage(error.toString());
                  });
                },
                child: Text('Update'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Post Screen"),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut().then((value) {
                debugPrint('logout success of');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }).onError((error, stackTrace) {
                utils.showToastMessage(
                  error.toString(),
                );
              });
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Expanded(
          //   child: StreamBuilder(
          //     // to show db data on ui using stream builder, can use when we want to listen to firebaseDbRef in init state
          //     stream: firebaseDbRef.onValue,
          //     builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //
          //       if (snapshot.hasData) {
          //
          //         Map<dynamic,dynamic> dbDataIntoMap = snapshot.data?.snapshot.value as Map<dynamic,dynamic>;
          //         List<dynamic> mapToList= [];
          //         mapToList.clear();
          //         mapToList = dbDataIntoMap.values.toList();
          //         debugPrint(dbDataIntoMap.toString());
          //         debugPrint(mapToList.toString());
          //
          //         return ListView.builder(
          //           itemCount: snapshot.data?.snapshot.children.length,
          //           itemBuilder: (context, index) {
          //             return ListTile(
          //               title: Text(mapToList[index]['description']),
          //               subtitle: Text(mapToList[index]['id'].toString()),
          //             );
          //           },
          //         );
          //       }
          //       else{
          //         return CircularProgressIndicator();
          //       }
          //
          //     },
          //   ),
          // ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _searchFilterController,
              onChanged: (value) {
                setState(() {
                  // set state helps in filter search function
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              // to show db data on ui
              query: firebaseDbRef,
              defaultChild: const Text("Loading"),
              itemBuilder: (context, snapshot, animation, index) {


                final description =
                    snapshot.child('description').value.toString();
                final id = snapshot.child('id').value.toString();
                if (_searchFilterController.text.isEmpty) {
                  return ListTile(
                    subtitle: Text(
                      id,
                    ),
                    title: Text(
                      description,
                    ),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).pop(); // to close popup
                              showUpdatePostDialog(description,id);
                            },
                            leading: Icon(Icons.edit),
                            title: Text("Edit"),
                          ),
                        ),
                         PopupMenuItem(
                          value: 2,
                          child: ListTile(
                            onTap: (){
                              firebaseDbRef.child(snapshot.child('id').value.toString()).remove(); // referring the child to remove by its id
                              Navigator.of(context).pop();
                            },
                            leading: Icon(Icons.delete_outline),
                            title: Text("Delete"),
                          ),
                        )
                      ],
                    ),
                  );
                } else if (description
                    .toLowerCase()
                    .contains(_searchFilterController.text.toLowerCase())) {
                  return ListTile(
                    subtitle: Text(
                      snapshot.child('id').value.toString(),
                    ),
                    title: Text(
                      snapshot.child('description').value.toString(),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddPostScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
