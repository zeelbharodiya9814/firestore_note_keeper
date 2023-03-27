import 'package:flutter/material.dart';

import '../../helper/firebase_firestore_DB_helper.dart';

class Update_note extends StatefulWidget {
  const Update_note({Key? key}) : super(key: key);

  @override
  State<Update_note> createState() => _Update_noteState();
}

class _Update_noteState extends State<Update_note> {
  String? title;
  String? note;

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController notecontroller = TextEditingController();

  GlobalKey<FormState> updateformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> allDocsupdate =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // UpdateandValidate(allId: allDocs[i].id);
    // var allId = allDocsupdate['id'];
    titlecontroller.text = allDocsupdate['title'];
    notecontroller.text = allDocsupdate['note'];

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: updateformKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15 ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${allDocsupdate['date']}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: TextFormField(
                        controller: titlecontroller,
                        style: TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.next,
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
                            hintStyle: TextStyle(
                                color: Colors.grey[400], fontSize: 21),
                            filled: true,
                            fillColor: Colors.black,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, top: 10),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: TextFormField(
                        maxLines: 30,
                        controller: notecontroller,
                        style: TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.next,
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
                            hintStyle: TextStyle(
                                color: Colors.grey[400], fontSize: 21),
                            filled: true,
                            fillColor: Colors.black,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              // borderSide: BorderSide.none,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              child: FloatingActionButton.extended(
                onPressed: () {
                  titlecontroller.clear();
                  notecontroller.clear();

                  setState(() {
                    title = null;
                    note = null;
                  });

                  Navigator.pop(context);
                },
                label: Text("Cancel"),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Container(
              height: 40,
              child: FloatingActionButton.extended(
                label: Text("Update"),
                onPressed: () async {
                  if (updateformKey.currentState!.validate()) {
                    updateformKey.currentState!.save();

                    var allId = allDocsupdate['id'];

                    await FirestoreDBHelper.firestoreDBHelper
                        .update(id: allId, title: title!, note: note!);

                    Navigator.pop(context);

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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
