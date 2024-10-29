import 'package:firebase_core/firebase_core.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
//import 'insertsubjects.dart';
//import 'insert_textbook.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter is initialized
  await Firebase.initializeApp(); // Initialize Firebase

  // Call the insertSampleData function once to insert data
  //insertSampleData();
  // Call the insertTextbooks function once to insert data
  //await InsertTextbook.insertTextbooks(); 
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'EduAid'),
    );
  }
}
