import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_app_new/models/user.dart';
import 'package:student_app_new/screens/authenticate/authenticate.dart';
import 'package:student_app_new/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user =
        Provider.of<User?>(context); // get the user object from the provider
    print(user);
    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return HomePage();
    }
  }
}
