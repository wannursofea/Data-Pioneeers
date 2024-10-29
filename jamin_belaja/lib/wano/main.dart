import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:student_app_new/models/user.dart';
import 'package:student_app_new/services/auth.dart';
import 'package:student_app_new/screens/wrapper.dart'; // Import the Wrapper widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(), // Set Wrapper as the initial screen
        // routes: {
        //   '/login': (context) => SignIn(toggleView: () {}),
        // },
      ),
    );
  }
}
