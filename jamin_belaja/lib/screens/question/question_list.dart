import 'package:flutter/material.dart';
import 'package:jamin_belaja/screens/question/reply_question.dart';
import 'package:provider/provider.dart';
import 'package:jamin_belaja/models/questions.dart';
import 'package:jamin_belaja/services/database.dart';
import 'package:jamin_belaja/services/auth.dart';
import 'package:jamin_belaja/models/user.dart' as custom_user;

class QuestionList extends StatefulWidget {
  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';

  // Mock recent keywords
  final List<String> recentKeywords = ['Form 3', 'Math', 'Algebra'];

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
        backgroundColor: Color(0xFFF0F0F0),
        appBar: AppBar(
          backgroundColor: Color(0xFF6C74E1),
          elevation: 0,
          title: const Text(''),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Search Bar
            Container(
              padding: EdgeInsets.all(16),
              color: Color(0xFF6C74E1),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: _searchQuestions,
                  ),
                ],
              ),
            ),
            // Recent Keywords
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  children: recentKeywords.map((keyword) {
                    return Chip(
                      label: Text(keyword),
                      backgroundColor: Color(0xFFEFEFEF),
                      labelStyle: TextStyle(color: Colors.black54),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Questions List
            Expanded(
              child: Consumer<List<QuestionsList>>(
                builder: (context, questions, _) {
                  if (questions == null || questions.isEmpty) {
                    return Center(child: Text('No questions found.'));
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ReplyQuestion(question: question),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.grey[300],
                                      child: Icon(Icons.person,
                                          size: 15, color: Colors.grey[600]),
                                    ),
                                    SizedBox(width: 8),
                                    Spacer(),
                                    Text(
                                      '• ${question.createdAt.toDate().toLocal()}',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  question.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  question.context,
                                  style: TextStyle(color: Colors.black87),
                                ),
                                SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  children:
                                      question.keywords.values.map((keyword) {
                                    return Chip(
                                      label: Text(keyword),
                                      backgroundColor: Colors.grey[100],
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
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
