import 'package:flutter/material.dart';
import 'package:jamin_belaja/wano/models/user.dart';
import 'package:jamin_belaja/wano/screens/authenticate/authenticate.dart';
import 'package:jamin_belaja/wano/screens/home/home.dart';
import 'package:provider/provider.dart';

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
