class Reply {
  final String id;
  final String questionId;
  final String userId;
  final String content;
  final DateTime createdAt;

  Reply({
    required this.id,
    required this.questionId,
    required this.userId,
    required this.content,
    required this.createdAt,
  });
}
