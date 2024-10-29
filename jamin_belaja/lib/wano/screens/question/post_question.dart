import 'package:flutter/material.dart';
// import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jamin_belaja/wano/services/database.dart';

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
    // Get the current user
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _databaseService = DatabaseService(uid: user.uid);
    } else {
      // Handle the case where the user is not logged in
      // For example, navigate to the login page
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<void> _submitPost(BuildContext context) async {
    if (_titleController.text.isNotEmpty &&
        _contextController.text.isNotEmpty &&
        _yearOfStudyController.text.isNotEmpty &&
        _subjectController.text.isNotEmpty &&
        _topicController.text.isNotEmpty) {
      // Create a new question using the addQuestionData method
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
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contextController,
              decoration: InputDecoration(labelText: 'Context'),
            ),
            TextField(
              controller: _yearOfStudyController,
              decoration: InputDecoration(labelText: 'Year of Study'),
            ),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              controller: _topicController,
              decoration: InputDecoration(labelText: 'Topic'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitPost(context),
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
