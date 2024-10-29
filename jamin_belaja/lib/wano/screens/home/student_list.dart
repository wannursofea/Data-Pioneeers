import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_app_new/models/students.dart';

class StudentList extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  @override
  Widget build(BuildContext context) {
    final students = Provider.of<List<StudentsList>>(context);
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(students[index].name),
          subtitle: Text(students[index].email),
        );
      },
    );
  }
}
