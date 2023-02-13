import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_practice/ui/firestore/add_firestore_data_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../auth/login_screen.dart';
import '../post/add_post_screen.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({Key? key}) : super(key: key);

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final _auth = FirebaseAuth.instance;
  Utils utils = Utils();

   TextEditingController _editDescriptionController = TextEditingController();
  final _firestoreCollectionInstanceStream = FirebaseFirestore.instance
      .collection('users').snapshots();

  CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users'); // ref of collection users


  Future<void> deleteFirestoreData (String id)async{
    await _collectionReference.doc(id).delete().then((value) {
      utils.showToastMessage('deleted successfully');
    }).onError((error, stackTrace) {
      utils.showToastMessage(error.toString());
    });
  }


  Future<void> updateFirestoreData (DocumentSnapshot documentSnapshot) async{
    if(documentSnapshot != null){
      _editDescriptionController.text = documentSnapshot['description']; // grab current value
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context){
          return Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  // prevent soft keyboard from covering text fields
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                maxLines: 4,
                controller: _editDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'update'
                ),
              ),
              SizedBox(height: 20,),

              ElevatedButton(onPressed: () async{
                final String updatedDescription = _editDescriptionController.text;
                if(updatedDescription != null ){
                  await _collectionReference.doc(documentSnapshot.id).update(
                      {
                        'description' : updatedDescription
                      }).then((value) {
                        utils.showToastMessage('update success');
                        Navigator.of(context).pop();
                  }).onError((error, stackTrace) {
                    utils.showToastMessage(error.toString());
                  });
                  _editDescriptionController.text ='';
                }
              }, child: const Text("Update"),),
            ],
          ),);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Firestore"),
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
        children:  [
          Expanded(
            child: StreamBuilder(
          // to show db data on ui using stream builder, can use when we want to listen to firebaseDbRef in init state
              stream: _collectionReference.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                if (snapshot.hasData) {

                  // Map<dynamic,dynamic> dbDataIntoMap = snapshot.data?.snapshot.value as Map<dynamic,dynamic>;
                  // List<dynamic> mapToList= [];
                  // mapToList.clear();
                  // mapToList = dbDataIntoMap.values.toList();
                  // debugPrint(dbDataIntoMap.toString());
                  // debugPrint(mapToList.toString());

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: (){
                          // todo update data on tapped
                          updateFirestoreData(snapshot.data!.docs[index]);
                        },
                        // snapshot.data!.docs[index] is of type DocumentSnapshot
                        title: Text(snapshot.data!.docs[index]['description'].toString()),
                        subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                        trailing: IconButton(onPressed: (){
                          // todo delete data
                          deleteFirestoreData(snapshot.data!.docs[index].id);
                        }, icon: Icon(Icons.delete_outline)),
                      );
                    },
                  );
                }
                else{
                  return CircularProgressIndicator();
                }

              },
            ),
          ),
          SizedBox(
            height: 10,
          ),

          // StreamBuilder<QuerySnapshot>(  // _firestoreCollectionInstanceStream returns Stream of type query snapshot
          //     stream: _firestoreCollectionInstanceStream,
          //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          //
          //       if(snapshot.connectionState == ConnectionState.waiting){
          //         return CircularProgressIndicator();
          //       }
          //       if(snapshot.hasError){
          //         return Text('error occured');
          //       }
          //       else{
          //         return Expanded(
          //           child: ListView.builder(
          //               itemCount: snapshot.data?.docs.length, // length of documents in firestore
          //               itemBuilder: (context, index) {
          //                 return ListTile(
          //                   onTap: (){
          //
          //                     // _collectionReference.doc(snapshot.data!.docs[index]['id'].toString()).update(
          //                     //     {
          //                     //       'description' :
          //                     //     }).then((value) {
          //                     //
          //                     // }).onError((error, stackTrace) {
          //                     //
          //                     // });
          //                   },
          //                   title: Text(snapshot.data!.docs[index]['description'].toString()),
          //                   subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
          //                 );
          //               }),
          //         );
          //       }
          //
          //     }),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddFirestoreDataScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
