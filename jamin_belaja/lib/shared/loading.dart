import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.purple,
          size: 50.0,
        ),
      ),
    );
  }
}
// Compare this snippet from jamin_belaja/jamin_belaja/wano/lib/screens/home/home.dart: