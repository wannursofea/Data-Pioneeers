import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jamin_belaja/services/database.dart';

class PostQuestionPage extends StatefulWidget {
  @override
  _PostQuestionPageState createState() => _PostQuestionPageState();
}

class _PostQuestionPageState extends State<PostQuestionPage> {
  final _titleController = TextEditingController();
  final _contextController = TextEditingController();
  final _yearOfStudyController = TextEditingController();
  final _subjectController = TextEditingController();
  final _topicController = TextEditingController();
  late final DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _databaseService = DatabaseService(uid: user.uid);
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<void> _submitPost(BuildContext context) async {
    if (_titleController.text.isNotEmpty &&
        _contextController.text.isNotEmpty) {
      await _databaseService.addQuestionData(
        _titleController.text,
        _contextController.text,
        {
          'yearOfStudy': _yearOfStudyController.text,
          'subject': _subjectController.text,
          'topic': _topicController.text,
        },
      );

      Navigator.of(context).pop(); // Close the page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: Color(0xFF6C74E1),
        elevation: 0,
        title: Text(
          'Post',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => _submitPost(context),
            child: Text(
              'Post',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Add your post title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contextController,
              decoration: InputDecoration(
                hintText: 'Ask your question here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
              maxLines: 8,
            ),
            SizedBox(height: 16),
            // Keywords Section
            TextField(
              controller: _yearOfStudyController,
              decoration: InputDecoration(
                hintText: 'Year of Study',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                hintText: 'Subject',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _topicController,
              decoration: InputDecoration(
                hintText: 'Topic',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
