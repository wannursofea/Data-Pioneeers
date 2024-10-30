import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamin_belaja/models/questions.dart';
import 'package:jamin_belaja/models/reply.dart';
import 'package:jamin_belaja/models/students.dart';
import 'package:jamin_belaja/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference studentCollection =
      FirebaseFirestore.instance.collection('students');

  // Future updateUserData(String name, String email, String password, String phone) async {
  //   return await studentCollection.doc(uid).set({
  //     'name': name,
  //     'email': email,
  //     'password': password,
  //   });
  // Inside database.dart
  Future<void> updateUserData(String name, String email, String password) async {
    return await studentCollection.doc(uid).set({
      'name': name,
      'email': email,
      'password': password,
      // 'phone': phone,
      // 'age': age,
      // 'username': username,
      // 'educationLevel': educationLevel,
      // 'grade': grade,
    });

  }

  StudentData _studentDataFromSnapshot(DocumentSnapshot snapshot) {
    return StudentData(
      uid: uid,
      name: snapshot['name'],
      email: snapshot['email'],
      password: snapshot['password'],
    );
  }

  Stream<StudentData> get studentData {
    return studentCollection.doc(uid).snapshots().map(_studentDataFromSnapshot);
  }

  Stream<List<StudentsList>> get studentList {
    return studentCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return StudentsList(
          name: doc.get('name') ?? '',
          email: doc.get('email') ?? '',
          password: doc.get('password') ?? '',
        );
      }).toList();
    });
  }

  CollectionReference get questionsCollection =>
      FirebaseFirestore.instance.collection('questions');

  Future<void> addQuestionData(
    String title,
    String contextQuestion,
    Map<String, String> keywords,
  ) async {
    String uid = _auth.currentUser?.uid ?? '';

    await questionsCollection.add({
      'userId': uid,
      'title': title,
      'context': contextQuestion,
      'keywords': {
        'yearOfStudy': keywords['yearOfStudy'] ?? '',
        'subject': keywords['subject'] ?? '',
        'topic': keywords['topic'] ?? '',
      },
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<QuestionsList>> get questionList {
    return questionsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return QuestionsList(
          id: doc.id,
          uid: doc.get('userId') ?? '',
          title: doc.get('title') ?? '',
          context: doc.get('context') ?? '',
          keywords: {
            'yearOfStudy': doc.get('keywords')['yearOfStudy'] ?? '',
            'subject': doc.get('keywords')['subject'] ?? '',
            'topic': doc.get('keywords')['topic'] ?? '',
          },
          createdAt: doc.get('createdAt') ?? Timestamp.now(),
        );
      }).toList();
    });
  }

  Stream<List<QuestionsList>> searchQuestions(String keyword) {
    return questionsCollection
        .where('keywords.subject', isEqualTo: keyword)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return QuestionsList(
          id: doc.id,
          uid: doc.get('userId') ?? '',
          title: doc.get('title') ?? '',
          context: doc.get('context') ?? '',
          keywords: {
            'yearOfStudy': doc.get('keywords')['yearOfStudy'] ?? '',
            'subject': doc.get('keywords')['subject'] ?? '',
            'topic': doc.get('keywords')['topic'] ?? '',
          },
          createdAt: doc.get('createdAt') ?? Timestamp.now(),
        );
      }).toList();
    });
  }

  final CollectionReference replyCollection =
      FirebaseFirestore.instance.collection('replies');

  Stream<List<Reply>> getReplies(String questionId) {
    return replyCollection
        .doc(questionId)
        .collection('replies')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Reply(
          id: doc.id,
          questionId: questionId,
          userId: doc['userId'],
          content: doc['content'],
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  Future<void> addReply(
      String questionId, String content, String userId) async {
    try {
      await replyCollection.doc(questionId).collection('replies').add({
        'userId': userId,
        'content': content,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Failed to add reply: $e');
    }
  }
}
