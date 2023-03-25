import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../helper/firebase_firestore_DB_helper.dart';

class Notes_Open_page extends StatefulWidget {
  const Notes_Open_page({Key? key}) : super(key: key);

  @override
  State<Notes_Open_page> createState() => _Notes_Open_pageState();
}

class _Notes_Open_pageState extends State<Notes_Open_page> {
  String? title;
  String? note;

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController notecontroller = TextEditingController();

  GlobalKey<FormState> updateformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> detail =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes",
          style: TextStyle(
              color: Colors.blue[900],
              fontSize: 21,
              fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[200],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Card(
              elevation: 5,
              shadowColor: Colors.blue[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                            color: Colors.blue[900]),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 50, right: 8, bottom: 11, top: 11),
                          child: Text(
                            "${detail['title']}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 6.0, bottom: 6, right: 6, left: 6),
                          child: Container(
                            alignment: Alignment.center,
                            width: 40,
                            height: 40,
                            child: IconButton(
                              onPressed: () async {
                                await Share.share(
                                    "-------------Notes-------------\nTitle : ${detail['title']}\n------------------------------------\n=> ${detail['note']}");
                              },
                              icon: const Icon(
                                Icons.share_outlined,
                                size: 25,
                                color: Colors.blue,
                              ),
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
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 10, right: 10, bottom: 15),
                          child: Text("${detail['note']}"),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     Padding(
                        //       padding:
                        //           const EdgeInsets.only(bottom: 7.0, right: 2),
                        //       child: Container(
                        //         height: 30,
                        //         width: 30,
                        //         child: PopupMenuButton<int>(
                        //           itemBuilder: (context) => [
                        //             PopupMenuItem(
                        //               value: 1,
                        //               child: GestureDetector(
                        //                 onTap: () {
                        //                   setState(() {
                        //                     Navigator.of(context).pop();
                        //
                        //                     UpdateandValidate(
                        //                         allId: detail['id']);
                        //                     titlecontroller.text =
                        //                         detail['title'];
                        //                     notecontroller.text =
                        //                         detail['note'];
                        //                   });
                        //                 },
                        //                 child: Row(
                        //                   children: [
                        //                     Icon(Icons.edit,
                        //                         color: Colors.blue[900]),
                        //                     SizedBox(
                        //                       width: 10,
                        //                     ),
                        //                     Text("Edit")
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //             // popupmenu item 2
                        //             PopupMenuItem(
                        //               value: 2,
                        //               child: InkWell(
                        //                 onTap: () {
                        //                   setState(() async {
                        //                     Navigator.of(context).pop();
                        //
                        //                     await FirestoreDBHelper
                        //                         .firestoreDBHelper
                        //                         .delete(id: detail['id']);
                        //                   });
                        //                 },
                        //                 child: Row(
                        //                   children: [
                        //                     Icon(
                        //                       Icons.delete,
                        //                       color: Colors.blue[900],
                        //                     ),
                        //                     SizedBox(
                        //                       width: 10,
                        //                     ),
                        //                     Text("Delete")
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //           offset: Offset(-29, 30),
                        //           color: Colors.grey[200],
                        //           elevation: 2,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
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
          ),
        ],
      ),
    );
  }

  // UpdateandValidate({required allId}) {
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
  //             Stack(
  //               alignment: Alignment.center,
  //               children: [
  //                 CircleAvatar(
  //                   radius: 40,
  //                   backgroundImage: (image != null)
  //                       ? MemoryImage(image as Uint8List)
  //                       : null,
  //                   backgroundColor: Colors.grey[300],
  //                 ),
  //                 IconButton(onPressed: () {
  //                   setState(() async {
  //                     final ImagePicker pick = ImagePicker();
  //
  //                     XFile? xfile = await pick.pickImage(source: ImageSource.camera,imageQuality: 50);
  //                     image = await xfile!.readAsBytes();
  //                   });
  //                 }, icon: Icon(Icons.add_a_photo_outlined)),
  //               ],
  //             ),
  //             SizedBox(
  //               height: 15,
  //             ),
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
  //                 if (updateformKey.currentState!.validate()) {
  //                   updateformKey.currentState!.save();
  //
  //                   await FirestoreDBHelper.firestoreDBHelper
  //                       .update(id: allId, title: title!, note: note!);
  //                   Navigator.of(context).pop();
  //
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(
  //                       content: Text("Record updated successfully..."),
  //                       backgroundColor: Colors.green,
  //                       behavior: SnackBarBehavior.floating,
  //                     ),
  //                   );
  //                   print("validate successfully...");
  //                 } else {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(
  //                       content: Text("Record updation failed"),
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
  //               child: Text("Update"),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }
}
