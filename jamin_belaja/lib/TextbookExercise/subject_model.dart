import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String questionText;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromFirestore(Map<String, dynamic> data) {
    return Question(
      questionText: data['questionText'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? '',
    );
  }
}

class Chapter {
  final String id;
  final String chapterName;

  Chapter({
    required this.id,
    required this.chapterName,
  });

  factory Chapter.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chapter(
      id: doc.id,
      chapterName: data['chapterName'] ?? '',
    );
  }

  Future<List<Question>> fetchQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('subjects')
        .doc(id) // This should be the correct reference to the subject
        .collection('chapters')
        .doc(chapterName) // Assuming this references the correct chapter
        .collection('questions')
        .get();

    return snapshot.docs.map((doc) => Question.fromFirestore(doc.data())).toList();
  }
}

class Subject {
  final String id;
  final String name;
  bool isFavorite;

  Subject({
    required this.id,
    required this.name,
    required this.isFavorite,
  });

  static Future<Subject> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;

    return Subject(
      id: doc.id,
      name: data['name'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  Future<List<Chapter>> fetchChapters() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('subjects')
        .doc(name)
        .collection('chapters')
        .get();

    return snapshot.docs.map((doc) => Chapter.fromFirestore(doc)).toList();
  }

  Future<void> toggleFavoriteStatus() async {
    isFavorite = !isFavorite;

    // Update Firestore to reflect the change
    await FirebaseFirestore.instance
        .collection('subjects')
        .doc(id)
        .update({'isFavorite': isFavorite});
  }
}
