import 'package:cloud_firestore/cloud_firestore.dart';

class Textbook {
  final String id;
  final String? name;
  final String? subject;
  final String? year;
  final String? downloadUrl;
  bool isFavorite; // Favorite status

  Textbook({
    required this.id,
    this.name,
    this.subject,
    this.year,
    this.downloadUrl,
    this.isFavorite = false,
  });

  factory Textbook.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Textbook(
      id: doc.id,
      name: data['name'] ?? '',
      subject: data['subject'] ?? '',
      year: data['year'],
      downloadUrl: data['downloadUrl'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  // Method to update the favorite status in Firestore
  Future<void> toggleFavoriteStatus() async {
    isFavorite = !isFavorite; // Toggle the favorite status
    await FirebaseFirestore.instance
        .collection('textbook')
        .doc(id)
        .update({'isFavorite': isFavorite});
  }
}
