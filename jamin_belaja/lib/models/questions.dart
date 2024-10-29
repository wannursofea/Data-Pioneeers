import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionsList {
  final String id; // Unique ID for the question
  final String title;
  final String context;
  final String uid;
  final Map<String, String> keywords; // Map of keywords to the question
  final Timestamp createdAt; // Timestamp of when the question was created

  QuestionsList({
    required this.id,
    required this.title,
    required this.context,
    required this.uid,
    required this.keywords,
    required this.createdAt,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'userId': uid,
  //     'title': title,
  //     'body': body,
  //     'keywords': keywords,
  //     'createdAt': createdAt,
  //   };
  // }

  factory QuestionsList.fromMap(Map<String, dynamic> map, String id) {
    return QuestionsList(
      id: id,
      title: map['title'],
      context: map['context'],
      uid: map['uid'],
      keywords:
          Map<String, String>.from(map['keywords'] ?? {}), // Safely cast to Map
      createdAt: map['createdAt'], // Cast to Timestamp
    );
  }
}
