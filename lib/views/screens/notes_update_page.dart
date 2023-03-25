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

    Map<String, dynamic> allDocsupdate = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // UpdateandValidate(allId: allDocs[i].id);
    // var allId = allDocsupdate['id'];
    // titlecontroller.text = allDocsupdate['title'];
    // notecontroller.text = allDocsupdate['note'];

    return Scaffold(
      body: Column(
        children: [
          Form(
            key: updateformKey,
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
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        hintText: "title",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
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
                        prefixIcon: Icon(
                          Icons.subject,
                          color: Colors.black,
                        ),
                        hintText: "note",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: () {
                    titlecontroller.clear();
                    notecontroller.clear();

                    setState(() {
                      title = null;
                      note = null;
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

                    var allId = allDocsupdate['id'];
                    titlecontroller.text = allDocsupdate['title'];
                    notecontroller.text = allDocsupdate['note'];

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

                  titlecontroller.clear();
                  notecontroller.clear();

                  setState(() {
                    title = null;
                    note = null;
                    // image = null;
                  });
                },
                child: Text("Update"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
