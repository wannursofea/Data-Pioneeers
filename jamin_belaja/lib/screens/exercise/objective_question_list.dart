import 'package:flutter/material.dart';
import 'package:jamin_belaja/models/objectivequestion.dart';
import 'package:jamin_belaja/services/database.dart';
import 'package:provider/provider.dart';
import 'package:jamin_belaja/models/user.dart' as custom_user;

class ObjectiveQuestionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final custom_user.User? user = Provider.of<custom_user.User?>(context);
    final String uid = user?.uid ?? '';

    return StreamProvider<List<Map<String, dynamic>>>.value(
      value: DatabaseService(uid: uid).getExerciseList(),
      initialData: [],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Objective Questions'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Consumer<List<Map<String, dynamic>>>(
          builder: (context, exercises, _) {
            if (exercises == null || exercises.isEmpty) {
              return Center(child: Text('No exercises found.'));
            }
            return ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      exercise['title'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(exercise['description']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetailsPage(
                            exerciseID: exercise['id'],
                            exerciseTitle: exercise['title'],
                            exerciseDescription: exercise['description'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ExerciseDetailsPage extends StatelessWidget {
  final String exerciseID;
  final String exerciseTitle;
  final String exerciseDescription;

  ExerciseDetailsPage({
    required this.exerciseID,
    required this.exerciseTitle,
    required this.exerciseDescription,
  });

  @override
  Widget build(BuildContext context) {
    final custom_user.User? user = Provider.of<custom_user.User?>(context);
    final String uid = user?.uid ?? '';

    return StreamProvider<List<ObjectiveQuestion>>.value(
      value: DatabaseService(uid: uid).getQuestionsForExercise(exerciseID),
      initialData: [],
      child: Scaffold(
        appBar: AppBar(
          title: Text(exerciseTitle),
        ),
        body: Consumer<List<ObjectiveQuestion>>(
          builder: (context, questions, _) {
            if (questions == null || questions.isEmpty) {
              return Center(child: Text('No questions found.'));
            }
            return ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(question.description),
                        SizedBox(height: 8),
                        Text(
                          question.questionText,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        ...question.options.entries.map((entry) {
                          return Text('${entry.key}: ${entry.value}');
                        }).toList(),
                        SizedBox(height: 8),
                        Text(
                          'Keywords: ${question.keywords.values.join(', ')}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
