class ObjectiveQuestion {
  final String id; // Document ID from Firestore
  final String exerciseID; // ID of the exercise this question belongs to
  final String title; // Title of the exercise
  final String description; // Description of the exercise
  final String questionText; // The text of the question
  final Map<String, String> options; // The answer options (A, B, C, D)
  final String correctAnswer; // The correct option
  final String explanation; // Explanation for the correct answer
  final Map<String, String> keywords; // Keywords related to the question

  ObjectiveQuestion({
    required this.id,
    required this.exerciseID,
    required this.title,
    required this.description,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.keywords,
  });

  // Convert ObjectiveQuestion instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'exerciseID': exerciseID,
      'exerciseTitle': title,
      'exerciseDescription': description,
      'questionText': questionText,
      'options': options,
      'correctOption': correctAnswer,
      'explanation': explanation,
      'keywords': keywords,
    };
  }

  // Create an ObjectiveQuestion instance from a map (retrieved from Firestore)
  factory ObjectiveQuestion.fromMap(Map<String, dynamic> map, String id) {
    return ObjectiveQuestion(
      id: id,
      exerciseID: map['exerciseID'] ?? '', // Ensure exerciseID is included
      title: map['title'] ?? '', // Title of the exercise
      description: map['description'] ?? '', // Description of the exercise
      questionText: map['questionText'],
      options: Map<String, String>.from(map['options'] ?? {}),
      correctAnswer: map['correctAnswer'],
      explanation: map['explanation'],
      keywords: Map<String, String>.from(map['keywords'] ?? {}),
    );
  }
}
