class Subjectivequestion {
  final String id;
  final String uid;
  final String title;
  final String context;
  final Map<String, dynamic> keywords;
  final String expectedAnswer;
  //final String referenceMaterial;

  Subjectivequestion({
    required this.id,
    required this.uid,
    required this.title,
    required this.context,
    required this.keywords,
    required this.expectedAnswer,
    //required this.referenceMaterial,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': uid,
      'title': title,
      'context': context,
      'keywords': keywords,
      'expectedAnswer': expectedAnswer,
      //'referenceMaterial': referenceMaterial,
    };
  }

  factory Subjectivequestion.fromMap(Map<String, dynamic> map, String id) {
    return Subjectivequestion(
      id: id,
      title: map['title'],
      uid: map['uid'],
      context: map['context'],
      keywords: Map<String, dynamic>.from(map['keywords'] ?? {}),
      expectedAnswer: map['expectedAnswer'],
      //referenceMaterial: map['referenceMaterial'],
    );
  }
}
