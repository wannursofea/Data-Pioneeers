import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'exercise_chapter_display.dart';
import '../../models/subject_model.dart';

class ExerciseChapterPage extends StatelessWidget {
  final String subjectTitle;

  const ExerciseChapterPage({Key? key, required this.subjectTitle}) : super(key: key);

  // Fetch chapters directly from the subject document based on subject name
  Future<List<Chapter>> _fetchChaptersForSubject() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('subjects')
        .where('name', isEqualTo: subjectTitle)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Retrieve the chapters collection within the found subject document
      final chaptersSnapshot = await snapshot.docs.first.reference.collection('chapters').get();
      return chaptersSnapshot.docs.map((doc) => Chapter.fromFirestore(doc)).toList();
    }

    return []; // Return an empty list if no subject or chapters found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6C74E1),
        title: Text(
          '$subjectTitle - Buku Latihan',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Handle back button press
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.blue[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Chapter>>(
          future: _fetchChaptersForSubject(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red, fontSize: 14)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No chapters found.', style: TextStyle(color: Color(0xFF4A4A4A), fontSize: 14)));
            }

            final chapters = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wrap the card in a Center widget
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bersedia untuk latihan?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Pilih bab untuk $subjectTitle.',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 10.0),
                      itemCount: chapters.length,
                      itemBuilder: (context, index) {
                        final chapter = chapters[index];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0), // Add horizontal padding
                            title: Padding(
                              padding: const EdgeInsets.only(left: 8.0), // Additional left padding for the chapter name
                              child: Text(
                                chapter.chapterName,
                                style: TextStyle(
                                  color: Color(0xFF4A4A4A),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 18),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChapterQuestionPage(
                                    subjectTitle: subjectTitle,
                                    chapterTitle: chapter.chapterName,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
