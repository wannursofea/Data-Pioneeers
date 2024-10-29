import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/subject_model.dart'; // Ensure this import for the Question model is correct

class ChapterQuestionPage extends StatefulWidget {
  final String subjectTitle;
  final String chapterTitle;

  const ChapterQuestionPage({Key? key, required this.subjectTitle, required this.chapterTitle}) : super(key: key);

  @override
  _ChapterQuestionPageState createState() => _ChapterQuestionPageState();
}

class _ChapterQuestionPageState extends State<ChapterQuestionPage> {
  Future<List<Question>> _fetchQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('subjects')
        .doc(widget.subjectTitle)
        .collection('chapters')
        .doc(widget.chapterTitle)
        .collection('questions')
        .get();

    return snapshot.docs.map((doc) => Question.fromFirestore(doc.data())).toList();
  }

  String? _selectedAnswer;
  int _currentQuestionIndex = 0;
  List<Question> _questions = [];

void _checkAnswer() {
  final currentQuestion = _questions[_currentQuestionIndex];
  final isCorrect = _selectedAnswer == currentQuestion.correctAnswer;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          padding: EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              colors: isCorrect
                  ? [Color(0xFFB4E4CE), Color(0xFFE8F6EF)] // Pastel greens for correct
                  : [Color(0xFFFFB4B4), Color(0xFFFFD6D6)], // Pastel reds for incorrect
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCorrect ? Icons.check_circle_outline : Icons.highlight_off,
                size: 60,
                color: isCorrect ? Color(0xFF6FAF92) : Color(0xFFE57B7B), // Subtle pastel accent
              ),
              SizedBox(height: 20),
              Text(
                isCorrect ? 'Betul!' : 'Salah',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 10),
              Text(
                isCorrect ? 'Kekalkan momentum anda!' : 'Sila cuba lagi!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    if (_currentQuestionIndex < _questions.length - 1) {
                      _currentQuestionIndex++;
                      _selectedAnswer = null;
                    } else {
                      _currentQuestionIndex = 0;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: BorderSide(
                    color: isCorrect ? Color(0xFFB4E4CE) : Color(0xFFFFB4B4),
                    width: 2,
                  ),
                ),
                child: Text(
                  'Teruskan',
                  style: TextStyle(
                    color: isCorrect ? Color(0xFF6FAF92) : Color(0xFFE57B7B),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.chapterTitle} - Kuiz', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF6C74E1),
        elevation: 2,
      ),
      body: FutureBuilder<List<Question>>(
        future: _fetchQuestions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No questions found.'));
          }

          _questions = snapshot.data!;
          final currentQuestion = _questions[_currentQuestionIndex];

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFEDF2FA),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, spreadRadius: 1)],
                  ),
                  child: Text(
                    currentQuestion.questionText,
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                  ),
                ),
                SizedBox(height: 30.0),
                Column(
                  children: currentQuestion.options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Material(
                        color: _selectedAnswer == option ? Color(0xFFDCE4F6) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        elevation: _selectedAnswer == option ? 2 : 0,
                        shadowColor: Colors.black26,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            setState(() {
                              _selectedAnswer = option;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            child: Row(
                              children: [
                                Icon(
                                  _selectedAnswer == option ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                  color: Color(0xFF6C74E1),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(fontSize: 16.0, color: Color(0xFF333333)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: _selectedAnswer == null ? null : _checkAnswer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                      child: Text('Hantar Jawaban', style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.w500)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C74E1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: _selectedAnswer == null ? 0 : 3,
                      shadowColor: Colors.black54,
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
