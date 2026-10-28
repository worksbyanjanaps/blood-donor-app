import 'package:blood_donation_app/update.dart';
import 'package:flutter/material.dart';
import 'add.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood donation app',
      debugShowCheckedModeBanner: false,
      routes: {
        '/':(context)=> HomePage(),
        '/add':(context)=> AddDonor(),
        '/update':(context)=> UpdatePage(),
      },
      initialRoute: '/',
    );
  }
}
