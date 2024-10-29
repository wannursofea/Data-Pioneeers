// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:jamin_belaja/jamin_belaja/jamin_belaja/wano/services/database.dart';
// // import 'package:jamin_belaja/jamin_belaja/jamin_belaja/wano/models/question.dart';

// class SearchQuestionPage extends StatefulWidget {
//   @override
//   _SearchQuestionPageState createState() => _SearchQuestionPageState();
// }

// class _SearchQuestionPageState extends State<SearchQuestionPage> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchKeyword = '';

//   void _searchQuestions() {
//     setState(() {
//       _searchKeyword = _searchController.text.trim();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       // Handle the case where the user is not logged in
//       return Center(child: Text('Please log in to search questions.'));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search Questions'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       labelText: 'Search by keyword',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: _searchQuestions,
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot<Object?>>(
//               stream: _searchKeyword.isEmpty
//                   ? DatabaseService(uid: user.uid).getQuestions()
//                   : DatabaseService(uid: user.uid).searchQuestions(_searchKeyword),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(child: Text('No questions found.'));
//                 }

//                 final questions = snapshot.data!.docs
//                     .map((doc) => Question.fromMap(doc.data() as Map<String, dynamic>, doc.id))
//                     .toList();

//                 return ListView.builder(
//                   itemCount: questions.length,
//                   itemBuilder: (context, index) {
//                     final question = questions[index];

//                     return Card(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(question.title, style: TextStyle(fontWeight: FontWeight.bold)),
//                             SizedBox(height: 8),
//                             Text(question.body),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }