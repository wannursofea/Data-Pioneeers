import 'package:flutter/material.dart';
import 'package:jamin_belaja/wano/screens/exercise/objective_question_list.dart';
import 'package:jamin_belaja/wano/screens/exercise/subjective_question_list.dart';

class ChooseQuestionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Question Type'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubjectiveQuestionsList()),
                );
              },
              child: Text('Subjective Questions'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubjectiveQuestionsList()),
                );
              },
              child: Text('Objective Questions'),
            ),
          ],
        ),
      ),
    );
  }
}
