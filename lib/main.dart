
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_keeper_firestore_database/views/screens/homepage.dart';
import 'package:note_keeper_firestore_database/views/screens/loginpage.dart';
import 'package:note_keeper_firestore_database/views/screens/notes_add_page.dart';
import 'package:note_keeper_firestore_database/views/screens/notes_open_page.dart';
import 'package:note_keeper_firestore_database/views/screens/notes_update_page.dart';
import 'package:note_keeper_firestore_database/views/screens/signin_page.dart';
import 'package:note_keeper_firestore_database/views/screens/signup_page.dart';
import 'package:note_keeper_firestore_database/views/screens/splash_screen.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();


  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: 'Splash_screen',
      routes: {
        '/' : (context) => Home_page(),
        'Login_page' : (context) => Login_page(),
        'Splash_screen' : (context) => Splash_screen(),
        'Signup_page' : (context) => Signup_page(),
        'Signin_page' : (context) => Signin_page(),
        'Notes_Open_page' : (context) => Notes_Open_page(),
        'Add_note' : (context) => Add_note(),
        'Update_note' : (context) => Update_note(),
      },
    ),
  );
}