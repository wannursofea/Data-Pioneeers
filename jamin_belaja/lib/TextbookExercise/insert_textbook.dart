// insert_textbook.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class InsertTextbook {
  // Method to add new textbooks to Firestore
  static Future<void> insertTextbooks() async {
    // List of textbook data
    final textbooks = [
      {
        'name': 'Bahasa Arab Tingkatan 3',
        'subject': 'Bahasa Arab',
        'year': 'Tingkatan 3',
        'downloadUrl': 'dummy_url_1',
        'isFavorite': false,
      },
      {
        'name': 'Asas Sains Komputer Tingkatan 3',
        'subject': 'Asas Sains Komputer',
        'year': 'Tingkatan 3',
        'downloadUrl': 'dummy_url_1',
        'isFavorite': false,
      },
      {
        'name': 'Reka Bentuk & Teknologi Tingkatan 3',
        'subject': 'Reka Bentuk & Teknologi',
        'year': 'Tingkatan 3',
        'downloadUrl': 'dummy_url_2',
        'isFavorite': false,
      },
      {
        'name': 'Matematik Tingkatan 3',
        'subject': 'Matematik',
        'year': 'Tingkatan 3',
        'downloadUrl': 'dummy_url_2',
        'isFavorite': false,
      },
      {
        'name': 'Sejarah Tingkatan 3',
        'subject': 'Sejarah',
        'year': 'Tingkatan 3',
        'downloadUrl': 'dummy_url_2',
        'isFavorite': false,
      },
    ];

    // Loop through the list and add each textbook to Firestore
    for (var textbook in textbooks) {
      await FirebaseFirestore.instance.collection('textbook').add(textbook);
    }
  }
}
