import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'exercise_chapter.dart';
import '../../models/subject_model.dart'; // Import your subject model

class ExercisePage extends StatefulWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  bool showFavorites = false;
  bool showHistory = false;
  final List<Color> _pastelColors = [
    Color(0xFFB2E1D4),
    Color(0xFFFAE3B3),
    Color(0xFFD4B2E1),
    Color(0xFFB3D4FA),
    Color(0xFFFAF1B3),
    Color(0xFFE2B2C6),
  ];

  final TextEditingController _searchController = TextEditingController();
  String searchTerm = '';

  Color _getPastelColor(int index) {
    return _pastelColors[index % _pastelColors.length];
  }

  List<Subject> _recentlyClickedSubjects = [];

  void _updateHistory(Subject subject) {
    setState(() {
      _recentlyClickedSubjects.remove(subject);
      _recentlyClickedSubjects.insert(0, subject);
      if (_recentlyClickedSubjects.length > 3) {
        _recentlyClickedSubjects.removeLast();
      }
    });
  }

  Future<List<Subject>> _fetchSubjects() async {
    final snapshot = await FirebaseFirestore.instance.collection('subjects').get();
    List<Subject> subjects = await Future.wait(
      snapshot.docs.map((doc) => Subject.fromFirestore(doc)).toList(),
    );
    return subjects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6C74E1),
        title: Text(
          'Bersedia untuk latihan?',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Subject>>(
        future: _fetchSubjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No subjects found.'));
          }

          List<Subject> _subjects = snapshot.data!;

          List<Subject> filteredSubjects = showFavorites
              ? _subjects.where((s) => s.isFavorite).toList()
              : showHistory
                  ? _recentlyClickedSubjects
                  : _subjects;

          // Apply search filtering
          if (!showFavorites && !showHistory && searchTerm.isNotEmpty) {
            filteredSubjects = filteredSubjects
                .where((subject) =>
                    subject.name.toLowerCase().contains(searchTerm))
                .toList();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      searchTerm = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari subjek...',
                    prefixIcon: Icon(Icons.search, color: Color(0xFF6C74E1)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Color(0xFF6C74E1)),
                    ),
                  ),
                ),
              ),
              ToggleButtons(
                borderColor: Color(0xFF6C74E1),
                selectedBorderColor: Color(0xFF6C74E1),
                fillColor: Color(0xFF6C74E1).withOpacity(0.2),
                selectedColor: Color(0xFF6C74E1),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('All'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('Favorites'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('History'),
                  ),
                ],
                isSelected: [
                  !showFavorites && !showHistory,
                  showFavorites,
                  showHistory,
                ],
                onPressed: (int index) {
                  setState(() {
                    if (index == 0) {
                      showFavorites = false;
                      showHistory = false;
                    } else if (index == 1) {
                      showFavorites = true;
                      showHistory = false;
                    } else if (index == 2) {
                      showFavorites = false;
                      showHistory = true;
                    }
                  });
                },
              ),
              SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: filteredSubjects.length,
                  itemBuilder: (context, index) {
                    final subject = filteredSubjects[index];
                    Color cardColor = _getPastelColor(index);

                    return GestureDetector(
                      onTap: () {
                        _updateHistory(subject);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExerciseChapterPage(subjectTitle: subject.name),
                          ),
                        );
                      },
                      child: Card(
                        color: cardColor,
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                subject.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(
                                  subject.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: subject.isFavorite
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    
                                    // Update Firestore to reflect the change
                                    subject.toggleFavoriteStatus();
                                    // Optionally update history
                                    
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
