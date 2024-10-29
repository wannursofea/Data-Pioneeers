import 'package:flutter/material.dart';
import 'package:jamin_belaja/screens/authenticate/register.dart';
import 'package:jamin_belaja/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = false;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  Widget build(BuildContext context) {
    if (showSignIn) {
      return Container(
        child: SignIn(toggleView: toggleView),
      );
    } else {
      return Container(
        child: Register(toggleView: toggleView),
      );
    }
  }
}
