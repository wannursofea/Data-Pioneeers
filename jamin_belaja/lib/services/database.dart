import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamin_belaja/models/objectivequestion.dart';
import 'package:jamin_belaja/models/questions.dart';
import 'package:jamin_belaja/models/students.dart';
import 'package:jamin_belaja/models/subject_model.dart';
import 'package:jamin_belaja/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference studentCollection =
      FirebaseFirestore.instance.collection('students');

  Future updateUserData(String name, String email, String password) async {
    return await studentCollection.doc(uid).set({
      'name': name,
      'email': email,
      'password': password,
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

  CollectionReference get objectiveQuestionsCollection =>
      FirebaseFirestore.instance.collection('objectivequestions');

  Stream<List<ObjectiveQuestion>> get objectiveQuestionList {
    return objectiveQuestionsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ObjectiveQuestion.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getExerciseList() {
    return _firestore
        .collection('objectiveExercise')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'exerciseID': doc.get('exerciseID') ?? '',
          'title': doc.get('title') ?? '',
          'description': doc.get('description') ?? '',
        };
      }).toList();
    });
  }

  Stream<List<ObjectiveQuestion>> getQuestionsForExercise(String exerciseID) {
    return _firestore
        .collection('objectiveExercise')
        .doc(exerciseID)
        .collection('Questions')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ObjectiveQuestion.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  CollectionReference get subjectCollection =>
      FirebaseFirestore.instance.collection('subjects');

  Future<List<Question>> fetchQuestions(
      String subjectId, String chapterName) async {
    final subject = Subject(id: subjectId, name: '', isFavorite: false);
    return await subject.fetchQuestions(chapterName);
  }

  Future<Subject> getSubject(String subjectId) async {
    final doc = await FirebaseFirestore.instance
        .collection('subjects')
        .doc(subjectId)
        .get();
    return Subject.fromFirestore(doc);
  }

  Future<List<Chapter>> fetchChapters(String subjectId) async {
    final subject = Subject(id: subjectId, name: '', isFavorite: false);
    return await subject.fetchChapters();
  }

  Future<void> toggleFavoriteStatus(String subjectId) async {
    final subject = Subject(id: subjectId, name: '', isFavorite: false);
    await subject.toggleFavoriteStatus();
  }

  
}
