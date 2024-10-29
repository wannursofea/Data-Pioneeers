import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

void insertSampleData() async {
  // Define subjects data
  Map<String, dynamic> subjectsData = {
    'Bahasa Melayu': {
      'Bab 1': [
        {
          'questionText': "Apakah maksud pantun?",
          'options': ["Sajak", "Syair", "Pantun", "Prosa"],
          'correctAnswer': "Pantun"
        },
        {
          'questionText': "Apakah tema utama dalam pantun empat kerat?",
          'options': ["Keluarga", "Persahabatan", "Nasihat", "Keindahan alam"],
          'correctAnswer': "Nasihat"
        },
      ],
      'Bab 2': [
        {
          'questionText': "Apakah maksud peribahasa 'bagai aur dengan tebing'?",
          'options': ["Bekerjasama", "Bergaduh", "Berlawan", "Berjauhan"],
          'correctAnswer': "Bekerjasama"
        }
      ]
    },
    'Sejarah': {
      'Bab 1': [
        {
          'questionText': "Siapakah yang digelar sebagai 'Bapa Kemerdekaan' Malaysia?",
          'options': ["Tun Dr. Mahathir Mohamad", "Tun Abdul Razak", "Tunku Abdul Rahman", "Tun Hussein Onn"],
          'correctAnswer': "Tunku Abdul Rahman"
        },
        {
          'questionText': "Pada tahun berapakah Malaysia mencapai kemerdekaan?",
          'options': ["1955", "1956", "1957", "1958"],
          'correctAnswer': "1957"
        }
      ],
      'Bab 2': [
        {
          'questionText': "Apakah tujuan utama penubuhan ASEAN?",
          'options': ["Kerjasama ekonomi", "Kerjasama ketenteraan", "Perpaduan serantau", "Menguatkan budaya"],
          'correctAnswer': "Perpaduan serantau"
        }
      ]
    },
    'Sains': {
      'Bab 1: Pengenalan kepada Sains': [
        {
          'questionText': "Apakah itu sains?",
          'options': ["Kaji selidik alam", "Proses penghasilan", "Penyelidikan manusia", "Bahasa pengaturcaraan"],
          'correctAnswer': "Kaji selidik alam"
        }
      ],
      'Bab 2: Pengukuran': [
        {
          'questionText': "Apakah unit asas bagi panjang?",
          'options': ["Kilometer", "Meter", "Centimeter", "Milimeter"],
          'correctAnswer': "Meter"
        }
      ],
      'Bab 3: Zat dan Kegunaannya': [
        {
          'questionText': "Apakah zat yang membentuk semua benda?",
          'options': ["Cecair", "Gas", "Padat", "Semua di atas"],
          'correctAnswer': "Semua di atas"
        }
      ],
      'Bab 4: Tenaga dan Perubahannya': [
        {
          'questionText': "Apakah jenis tenaga yang dihasilkan oleh matahari?",
          'options': ["Tenaga elektrik", "Tenaga cahaya", "Tenaga nuklear", "Tenaga angin"],
          'correctAnswer': "Tenaga cahaya"
        }
      ],
      'Bab 5: Ekosistem': [
        {
          'questionText': "Apakah komponen utama ekosistem?",
          'options': ["Organisma", "Habitat", "Pemakanan", "Semua di atas"],
          'correctAnswer': "Semua di atas"
        }
      ]
    },
    'Asas Sains Komputer': {
      'Bab 1: Pengenalan kepada Komputer': [
        {
          'questionText': "Apakah komponen utama komputer?",
          'options': ["Perisian", "Perkakasan", "Data", "Semua di atas"],
          'correctAnswer': "Semua di atas"
        }
      ],
      'Bab 2: Algoritma dan Pemprograman': [
        {
          'questionText': "Apakah yang dimaksudkan dengan algoritma?",
          'options': ["Langkah-langkah untuk menyelesaikan masalah", "Kumpulan data", "Bahasa pengaturcaraan", "Sistem operasi"],
          'correctAnswer': "Langkah-langkah untuk menyelesaikan masalah"
        }
      ],
      'Bab 3: Struktur Data': [
        {
          'questionText': "Apakah yang dimaksudkan dengan struktur data?",
          'options': ["Cara menyimpan data", "Proses pengiraan", "Pengaturcaraan sistem", "Semua di atas"],
          'correctAnswer': "Cara menyimpan data"
        }
      ],
      'Bab 4: Pengaturcaraan Berorientasikan Objek': [
        {
          'questionText': "Apakah ciri utama pengaturcaraan berorientasikan objek?",
          'options': ["Menggunakan fungsi", "Menggunakan objek", "Menggunakan algoritma", "Menggunakan data"],
          'correctAnswer': "Menggunakan objek"
        }
      ],
      'Bab 5: Rangkaian Komputer': [
        {
          'questionText': "Apakah fungsi utama rangkaian komputer?",
          'options': ["Menghubungkan komputer", "Menyimpan data", "Menghantar mesej", "Semua di atas"],
          'correctAnswer': "Menghubungkan komputer"
        }
      ]
    },
    'Geografi': {
      'Bab 1: Pengenalan Geografi': [
        {
          'questionText': "Apakah yang dimaksudkan dengan geografi?",
          'options': ["Kajian bumi", "Kajian manusia", "Kajian haiwan", "Kajian tumbuh-tumbuhan"],
          'correctAnswer': "Kajian bumi"
        }
      ],
      'Bab 2: Peta dan Pengukuran': [
        {
          'questionText': "Apakah simbol yang digunakan untuk mewakili gunung di peta?",
          'options': ["Lingkaran", "Segitiga", "Persegi", "Garis lurus"],
          'correctAnswer': "Segitiga"
        }
      ],
      'Bab 3: Iklim dan Cuaca': [
        {
          'questionText': "Apakah yang mempengaruhi iklim sesebuah kawasan?",
          'options': ["Ketinggian", "Jarak dari laut", "Bentuk muka bumi", "Semua di atas"],
          'correctAnswer': "Semua di atas"
        }
      ]
    }
  };

  // Loop through subjects and insert data into Firestore
  for (String subject in subjectsData.keys) {
    DocumentReference subjectDoc = firestore.collection('subjects').doc(subject);

    // Set subject document with additional fields
    await subjectDoc.set({
      'name': subject,
      'isFavorite': false, // or true based on your logic
    });

    for (String chapter in subjectsData[subject].keys) {
      DocumentReference chapterDoc = subjectDoc.collection('chapters').doc(chapter);

      // Set chapter document with chapterName field
      await chapterDoc.set({
        'chapterName': chapter,
      });

      // Loop through questions
      for (var question in subjectsData[subject][chapter]) {
        // Check if the question already exists
        QuerySnapshot existingQuestions = await chapterDoc.collection('questions')
            .where('questionText', isEqualTo: question['questionText'])
            .get();

        // If it doesn't exist, add it
        if (existingQuestions.docs.isEmpty) {
          await chapterDoc.collection('questions').add({
            'questionText': question['questionText'],
            'options': question['options'],
            'correctAnswer': question['correctAnswer'],
          });
        }
      }
    }
  }

  // print("Data inserted successfully!");
}
