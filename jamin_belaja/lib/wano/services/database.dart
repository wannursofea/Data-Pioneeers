import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamin_belaja/wano/models/objectivequestion.dart';
import 'package:jamin_belaja/wano/models/questions.dart';
import 'package:jamin_belaja/wano/models/students.dart';
import 'package:jamin_belaja/wano/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Student userID = uid
  final String uid;
  DatabaseService({required this.uid});

  // STUDENT INFORMATION //

  // Student collection reference
  final CollectionReference studentCollection =
      FirebaseFirestore.instance.collection('students');

  // Method to update user data in the students collection
  Future updateUserData(String name, String email, String password) async {
    return await studentCollection.doc(uid).set({
      'name': name,
      'email': email,
      'password': password,
    });
  }

  // StudentData from snapshot
  StudentData _studentDataFromSnapshot(DocumentSnapshot snapshot) {
    return StudentData(
      uid: uid,
      name: snapshot['name'],
      email: snapshot['email'],
      password: snapshot['password'],
    );
  }

  // Get student doc from stream
  Stream<StudentData> get studentData {
    return studentCollection.doc(uid).snapshots().map(_studentDataFromSnapshot);
  }

  // Get student list from stream
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

  // QUESTION INFORMATION //

  // Questions collection reference
  CollectionReference get questionsCollection =>
      FirebaseFirestore.instance.collection('questions');

  // Method to add a new question to the questions collection
  Future<void> addQuestionData(
    String title,
    String contextQuestion,
    Map<String, String> keywords,
  ) async {
    String uid = _auth.currentUser?.uid ?? ''; // Get the current user's UID

    // Ensure keywords include the expected entries
    await questionsCollection.add({
      'userId': uid,
      'title': title,
      'context': contextQuestion,
      'keywords': {
        'yearOfStudy': keywords['yearOfStudy'] ?? '',
        'subject': keywords['subject'] ?? '',
        'topic': keywords['topic'] ?? '',
      },
      'createdAt': FieldValue.serverTimestamp(), // Use server timestamp
    });
  }

  // Method to retrieve questions from the questions collection
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

  // Method to search questions based on keywords
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

  //OBJECTIVE QUESTION INFORMATION //

  // Objective Questions collection reference
  CollectionReference get objectiveQuestionsCollection =>
      FirebaseFirestore.instance.collection('objectivequestions');

  // Method to retrieve objective questions from the objectiveQuestions collection
  Stream<List<ObjectiveQuestion>> get objectiveQuestionList {
    return objectiveQuestionsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ObjectiveQuestion.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Method to retrieve the list of exercises (subjects) under the objectiveExercise collection
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

  // Method to retrieve all questions under a specific exercise
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
}
