import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/firebase_auth_helper.dart';
import '../../helper/firebase_firestore_DB_helper.dart';

class Home_page extends StatefulWidget {
  const Home_page({Key? key}) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  String? title;
  String? note;
 late SharedPreferences sharedPreferences;
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController notecontroller = TextEditingController();

  GlobalKey<FormState> imsertformKey = GlobalKey<FormState>();
  GlobalKey<FormState> updateformKey = GlobalKey<FormState>();

  String date = DateTime.now().toString().split(" ")[0];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getper();
  }
  getper()
  async{
    sharedPreferences = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {

    //User? user = ModalRoute.of(context)!.settings.arguments as User?;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your notes",
          style: TextStyle(
              color: Colors.black,
              fontSize: 21,
              fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[200],
        actions: [
          IconButton(
              onPressed: () async{
                FirebaseAuthHelper.firebaseAuthHelper.logOut();
                await sharedPreferences.setBool("isLogin", false);
                Navigator.of(context).pushReplacementNamed('Login_page');
              },
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.black,
              ))
        ],
      ),
      // drawer: Drawer(
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      //   child: Column(
      //     children: [
      //       Expanded(
      //           flex: 3,
      //           child: Container(
      //             alignment: Alignment.center,
      //             decoration: BoxDecoration(
      //               color: Colors.blue[200],
      //               borderRadius:
      //                   BorderRadius.only(topRight: Radius.circular(20)),
      //             ),
      //             child: CircleAvatar(
      //               radius: 70,
      //               backgroundColor: Colors.yellow[100],
      //               backgroundImage: (user!.photoURL != null)
      //                   ? NetworkImage(user!.photoURL as String)
      //                   : (user!.isAnonymous)
      //                       ? NetworkImage(
      //                           "https://o.remove.bg/downloads/d961157e-0be1-4367-a2e7-feb979a9d1e7/images-removebg-preview.png")
      //                       : null,
      //             ),
      //           )),
      //       Expanded(
      //           flex: 8,
      //           child: Container(
      //             child: Column(
      //               children: [
      //                 Container(
      //                   height: 50,
      //                   alignment: Alignment.centerLeft,
      //                   child: (user!.isAnonymous)
      //                       ? Container()
      //                       : (user!.displayName == null)
      //                           ? Container()
      //                           : Card(
      //                              elevation: 2,
      //                             child: Container(
      //                                 height: 70,
      //                               alignment: Alignment.center,
      //                               width: double.infinity,
      //                               child: Text(
      //                                   "  Username : ${user!.displayName}"),
      //                             ),
      //                           ), // Text("Phone : ${user!.phoneNumber}"),
      //                 ),
      //                 Container(
      //                   alignment: Alignment.centerLeft,
      //                   child: (user!.isAnonymous)
      //                       ? Container()
      //                       : Card(
      //                         elevation: 2,
      //                         child: Container(
      //                           height: 45,
      //                             alignment: Alignment.center,
      //                         width: double.infinity,
      //                         child: Text("  Email : ${user!.email}")),
      //                       ),
      //                 ),
      //               ],
      //             ),
      //           )),
      //     ],
      //   ),
      // ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("notes").snapshots(),
          builder: (context, snapShot) {
            if (snapShot.hasError) {
              return Center(
                child: Text("Error : ${snapShot.error}"),
              );
            } else if (snapShot.hasData) {
              QuerySnapshot<Map<String, dynamic>> data =
                  snapShot.data as QuerySnapshot<Map<String, dynamic>>;

              List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                  data.docs;

              return MasonryGridView.builder(
                  padding: EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  physics: BouncingScrollPhysics(),
                  itemCount: allDocs.length,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.pushNamed(context, 'Notes_Open_page', arguments: allDocs[i].data());
                        });
                      },
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.blue[300],
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                Container(
                                alignment: Alignment.center,
                                // height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12)),
                                    color: Colors.purple[100]),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 50,right: 8,bottom: 8,top: 8),
                                  child: Text(
                                    "${allDocs[i].data()['title']}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20),
                                  ),
                                ),
                               ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 6.0,bottom: 6,right: 6,left: 6),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 33,
                                      width: 33,
                                      child: Text(
                                        "${i + 1}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[900],fontSize: 17),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(9),
                                            bottomRight: Radius.circular(9)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              // height: 150,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("${allDocs[i].data()['date']}",style: TextStyle(fontWeight: FontWeight.bold),),
                                      ),

                                      // CircleAvatar(
                                      //   radius: 30,
                                      //   backgroundImage: (allDocs[i].data()['image'] != null)
                                      //       ? MemoryImage(
                                      //       allDocs[i].data()['image'] as Uint8List)
                                      //       : null,
                                      //   backgroundColor: Colors.grey[300],
                                      // ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 35.0, left: 10, right: 10, bottom: 10),
                                    child: Text("${allDocs[i].data()['note']}"),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 7.0,right: 2),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          child: PopupMenuButton<int>(
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: 1,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {

                                                      Map<String,dynamic> k = {
                                                        "title": allDocs[i].data()['title'],
                                                        "note": allDocs[i].data()['note'],
                                                        "id":allDocs[i].id,
                                                        "date": allDocs[i].data()['date'],
                                                      };
                                                      Navigator.pushNamed(context, 'Update_note',arguments: k);

                                                    });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.edit,color: Colors.blue[900]),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text("Edit")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // popupmenu item 2
                                              PopupMenuItem(
                                                value: 2,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() async {

                                                      Navigator.of(context).pop();

                                                      await FirestoreDBHelper
                                                          .firestoreDBHelper
                                                          .delete(id: allDocs[i].id);

                                                    });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete,color: Colors.blue[900],),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text("Delete")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                            offset: Offset(-29, 30),
                                            color: Colors.grey[200],
                                            elevation: 2,
                                          ),
                                        ),
                                      ),


                                    ],
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue[200],
        label: Text(
          "Add",
          style: TextStyle(color: Colors.blue[900]),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.blue[900],
        ),
        onPressed: () {
          // InsertAndValidate();
          Navigator.pushNamed(context, 'Add_note');
        },
      ),
    );
  }

  // InsertAndValidate() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (all) => AlertDialog(
  //       backgroundColor: Colors.white,
  //       content: Form(
  //         key: imsertformKey,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             SizedBox(
  //               height: 15,
  //             ),
  //             Text("${date}"),
  //             SizedBox(height: 15,),
  //             Card(
  //               elevation: 5,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20)),
  //               child: TextFormField(
  //                 controller: titlecontroller,
  //                 textInputAction: TextInputAction.next,
  //                 validator: (val) {
  //                   if (val!.isEmpty) {
  //                     return "Enter title...";
  //                   }
  //                 },
  //                 onSaved: (val) {
  //                   setState(() {
  //                     title = val;
  //                   });
  //                 },
  //                 decoration: InputDecoration(
  //                     hintText: "title",
  //                     hintStyle: TextStyle(color: Colors.grey[400]),
  //                     filled: true,
  //                     fillColor: Colors.white,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(20),
  //                       borderSide: BorderSide.none,
  //                     )),
  //               ),
  //             ),
  //             Card(
  //               elevation: 5,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20)),
  //               child: TextFormField(
  //                 maxLines: 3,
  //                 controller: notecontroller,
  //                 textInputAction: TextInputAction.next,
  //                 validator: (val) {
  //                   if (val!.isEmpty) {
  //                     return "Enter note...";
  //                   }
  //                 },
  //                 onSaved: (val) {
  //                   setState(() {
  //                     note = val;
  //                   });
  //                   print(note);
  //                 },
  //                 decoration: InputDecoration(
  //                     hintText: "note",
  //                     hintStyle: TextStyle(color: Colors.grey[400]),
  //                     filled: true,
  //                     fillColor: Colors.white,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(20),
  //                       borderSide: BorderSide.none,
  //                     )),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             OutlinedButton(
  //                 onPressed: () {
  //                   titlecontroller.clear();
  //                   notecontroller.clear();
  //
  //                   setState(() {
  //                     title = null;
  //                     note = null;
  //                   });
  //
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text("Cancel")),
  //             SizedBox(
  //               width: 20,
  //             ),
  //             ElevatedButton(
  //               onPressed: () async {
  //                 if (imsertformKey.currentState!.validate()) {
  //                   imsertformKey.currentState!.save();
  //
  //                   Map<String, dynamic> data = {
  //                     'title': title,
  //                     'note': note,
  //                     'date' : date,
  //                   };
  //
  //                   await FirestoreDBHelper.firestoreDBHelper
  //                       .insert(data: data);
  //                   Navigator.of(context).pop();
  //
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(
  //                       content: Text("Record inserted successfully..."),
  //                       backgroundColor: Colors.green,
  //                       behavior: SnackBarBehavior.floating,
  //                     ),
  //                   );
  //                   print("validate successfully...");
  //                 } else {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(
  //                       content: Text("Record insertion failed"),
  //                       backgroundColor: Colors.red,
  //                       behavior: SnackBarBehavior.floating,
  //                     ),
  //                   );
  //                 }
  //
  //                 titlecontroller.clear();
  //                 notecontroller.clear();
  //
  //                 setState(() {
  //                   title = null;
  //                   note = null;
  //                   // image = null;
  //                 });
  //               },
  //               child: Text("Insert"),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  // UpdateAndValidate () {
  //
  //   titlecontroller.text = alDocs[i]['title'];
  //   agecontroller.text = age.toString();
  //   notecontroller.text = note;
  //
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (all) => AlertDialog(
  //       backgroundColor: Colors.white,
  //       content: Form(
  //         key: updateformKey,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Stack(
  //             //   alignment: Alignment.center,
  //             //   children: [
  //             //     CircleAvatar(
  //             //       radius: 40,
  //             //       backgroundImage: (image != null)
  //             //           ? MemoryImage(image as Uint8List)
  //             //           : null,
  //             //       backgroundColor: Colors.grey[300],
  //             //     ),
  //             //     IconButton(onPressed: () {
  //             //       setState(() async {
  //             //         final ImagePicker pick = ImagePicker();
  //             //
  //             //         XFile? xfile = await pick.pickImage(source: ImageSource.camera,imageQuality: 50);
  //             //         image = await xfile!.readAsBytes();
  //             //       });
  //             //     }, icon: Icon(Icons.add_a_photo_outlined)),
  //             //   ],
  //             // ),
  //             SizedBox(height: 15,),
  //             Card(
  //               elevation: 5,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20)),
  //               child: TextFormField(
  //                 controller: titlecontroller,
  //                 textInputAction: TextInputAction.next,
  //                 validator: (val) {
  //                   if (val!.isEmpty) {
  //                     return "Enter title...";
  //                   }
  //                 },
  //                 onSaved: (val) {
  //                   setState(() {
  //                     title = val;
  //                   });
  //                 },
  //                 decoration: InputDecoration(
  //                     prefixIcon: Icon(
  //                       Icons.person,
  //                       color: Colors.black,
  //                     ),
  //                     hintText: "title",
  //                     hintStyle: TextStyle(color: Colors.grey[400]),
  //                     filled: true,
  //                     fillColor: Colors.white,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(20),
  //                       borderSide: BorderSide.none,
  //                     )),
  //               ),
  //             ),
  //             Card(
  //               elevation: 5,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20)),
  //               child: TextFormField(
  //                 controller: agecontroller,
  //                 textInputAction: TextInputAction.next,
  //                 validator: (val) {
  //                   if (val!.isEmpty) {
  //                     return "Enter age...";
  //                   }
  //                 },
  //                 onSaved: (val) {
  //                   setState(() {
  //                     age = int.parse(val!);
  //                   });
  //                   print(age);
  //                 },
  //                 keyboardType: TextInputType.number,
  //                 decoration: InputDecoration(
  //                     prefixIcon: Icon(
  //                       Icons.real_estate_agent_rounded,
  //                       color: Colors.black,
  //                     ),
  //                     hintText: "Age",
  //                     hintStyle: TextStyle(color: Colors.grey[400]),
  //                     filled: true,
  //                     fillColor: Colors.white,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(20),
  //                       borderSide: BorderSide.none,
  //                     )),
  //               ),
  //             ),
  //             Card(
  //               elevation: 5,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20)),
  //               child: TextFormField(
  //                 controller: notecontroller,
  //                 textInputAction: TextInputAction.next,
  //                 validator: (val) {
  //                   if (val!.isEmpty) {
  //                     return "Enter note...";
  //                   }
  //                 },
  //                 onSaved: (val) {
  //                   setState(() {
  //                     note = val;
  //                   });
  //                   print(note);
  //                 },
  //                 decoration: InputDecoration(
  //                     prefixIcon: Icon(
  //                       Icons.subject,
  //                       color: Colors.black,
  //                     ),
  //                     hintText: "note",
  //                     hintStyle: TextStyle(color: Colors.grey[400]),
  //                     filled: true,
  //                     fillColor: Colors.white,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(20),
  //                       borderSide: BorderSide.none,
  //                     )),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             OutlinedButton(
  //                 onPressed: () {
  //                   titlecontroller.clear();
  //                   agecontroller.clear();
  //                   notecontroller.clear();
  //
  //                   setState(() {
  //                     title = null;
  //                     age = null;
  //                     note = null;
  //                     // image = null;
  //                   });
  //
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text("Cancel")),
  //             SizedBox(
  //               width: 20,
  //             ),
  //             ElevatedButton(onPressed: () async {
  //               if (updateformKey.currentState!.validate()) {
  //                 updateformKey.currentState!.save();
  //
  //                 Map<String, dynamic> data = {
  //                   'title' : title,
  //                   'age' : age,
  //                   'note' : note,
  //                 };
  //
  //                 await FirestoreDBHelper.firestoreDBHelper.insert(data: data );
  //                 Navigator.of(context).pop();
  //
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text(
  //                         "Record updated successfully..."),
  //                     backgroundColor: Colors.green,
  //                     behavior: SnackBarBehavior.floating,
  //                   ),
  //                 );
  //                 print("validate successfully...");
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text("Record updation failed"),
  //                     backgroundColor: Colors.red,
  //                     behavior: SnackBarBehavior.floating,
  //                   ),
  //                 );
  //               }
  //
  //               titlecontroller.clear();
  //               agecontroller.clear();
  //               notecontroller.clear();
  //
  //               setState(() {
  //                 title = null;
  //                 age = null;
  //                 note = null;
  //                 // image = null;
  //               });
  //
  //             }, child: Text("Update"),),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }
  //
  UpdateandValidate({required allId}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (all) => AlertDialog(
        backgroundColor: Colors.black,
        content: Form(
          key: updateformKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Stack(
                //   alignment: Alignment.center,
                //   children: [
                //     CircleAvatar(
                //       radius: 40,
                //       backgroundImage: (image != null)
                //           ? MemoryImage(image as Uint8List)
                //           : null,
                //       backgroundColor: Colors.grey[300],
                //     ),
                //     IconButton(onPressed: () {
                //       setState(() async {
                //         final ImagePicker pick = ImagePicker();
                //
                //         XFile? xfile = await pick.pickImage(source: ImageSource.camera,imageQuality: 50);
                //         image = await xfile!.readAsBytes();
                //       });
                //     }, icon: Icon(Icons.add_a_photo_outlined)),
                //   ],
                // ),
                SizedBox(
                  height: 15,
                ),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    controller: titlecontroller,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.white),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter title...";
                      }
                    },
                    onSaved: (val) {
                      setState(() {
                        title = val;
                      });
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: "Title",
                        hintStyle: TextStyle(color: Colors.grey[400],fontSize: 21),
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    controller: notecontroller,
                    maxLines: 10,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.white),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter note...";
                      }
                    },
                    onSaved: (val) {
                      setState(() {
                        note = val;
                      });
                      print(note);
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: "Notes",
                        hintStyle: TextStyle(color: Colors.grey[400],fontSize: 21),
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Container(
            height: 30,
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {
                      titlecontroller.clear();
                      notecontroller.clear();

                      setState(() {
                        title = "";
                        note = "";
                      });

                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (updateformKey.currentState!.validate()) {
                      updateformKey.currentState!.save();

                      await FirestoreDBHelper.firestoreDBHelper
                          .update(id: allId, title: title!, note: note!);
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Record updated successfully..."),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      print("validate successfully...");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Record updation failed"),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }

                    titlecontroller.clear();
                    notecontroller.clear();

                    setState(() {
                      title = "";
                      note = "";
                      // image = null;
                    });
                  },
                  child: Text("Update"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

