import 'package:flutter/material.dart';
import 'package:jamin_belaja/wano/models/students.dart';

class StudentTile extends StatelessWidget {
  final StudentsList student;
  StudentTile({required this.student});

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(student.name),
          subtitle: Text(student.email),
        ),
      ),
    );
  }
}
