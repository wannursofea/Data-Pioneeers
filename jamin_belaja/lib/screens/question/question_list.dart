import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jamin_belaja/models/questions.dart';
import 'package:jamin_belaja/services/database.dart';
import 'package:jamin_belaja/services/auth.dart';
import 'package:jamin_belaja/models/user.dart' as custom_user;
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionList extends StatefulWidget {
  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';

  void _searchQuestions() {
    setState(() {
      _searchKeyword = _searchController.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final custom_user.User? user = Provider.of<custom_user.User?>(context);
    final String uid = user?.uid ?? '';

    return StreamProvider<List<QuestionsList>>.value(
      value: _searchKeyword.isEmpty
          ? DatabaseService(uid: uid).questionList
          : DatabaseService(uid: uid).searchQuestions(_searchKeyword),
      initialData: [],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Questions'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search by keyword',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchQuestions,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<List<QuestionsList>>(
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
                              Text(question.context),
                              SizedBox(height: 8),
                              Text(
                                'Keywords: ${question.keywords.values.join(', ')}',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Created at: ${question.createdAt.toDate().toString()}',
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
          ],
        ),
      ),
    );
  }
}
