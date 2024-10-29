import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jamin_belaja/wano/models/user.dart';
import 'package:jamin_belaja/wano/screens/wrapper.dart';
import 'package:jamin_belaja/wano/services/auth.dart';
import 'package:provider/provider.dart';

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
