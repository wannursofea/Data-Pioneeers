// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:student_app_new/services/database.dart';
// import 'package:student_app_new/models/objectivequestion.dart';
// import 'package:student_app_new/models/user.dart' as custom_user;

// class ExerciseDetailsPage extends StatelessWidget {
//   final String exerciseID;
//   final String exerciseTitle;
//   final String exerciseDescription;

//   ExerciseDetailsPage({
//     required this.exerciseID,
//     required this.exerciseTitle,
//     required this.exerciseDescription,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final custom_user.User? user = Provider.of<custom_user.User?>(context);
//     final String uid = user?.uid ?? '';

//     return StreamProvider<List<ObjectiveQuestion>>.value(
//       value: DatabaseService(uid: uid).getQuestionsForExercise(exerciseID),
//       initialData: [],
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(exerciseTitle),
//         ),
//         body: Consumer<List<ObjectiveQuestion>>(
//           builder: (context, questions, _) {
//             if (questions == null || questions.isEmpty) {
//               return Center(child: Text('No questions found.'));
//             }
//             return ListView.builder(
//               itemCount: questions.length,
//               itemBuilder: (context, index) {
//                 final question = questions[index];
//                 return Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           question.questionText,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 18),
//                         ),
//                         SizedBox(height: 8),
//                         ...question.options.entries.map((entry) {
//                           return Text('${entry.key}: ${entry.value}');
//                         }).toList(),
//                         SizedBox(height: 8),
//                         Text(
//                           'Keywords: ${question.keywords.values.join(', ')}',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
