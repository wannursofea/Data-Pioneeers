import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/textbook_model.dart';
import 'textbook_details.dart';

class TextbookPage extends StatefulWidget {
  const TextbookPage({Key? key}) : super(key: key);

  @override
  _TextbookPageState createState() => _TextbookPageState();
}

class _TextbookPageState extends State<TextbookPage> {
  final CollectionReference _textbooksCollection =
      FirebaseFirestore.instance.collection('textbook');

  bool showFavorites = false;
  bool showHistory = false;
  List<Textbook> _recentlyClickedTextbooks = [];
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

  void _updateHistory(Textbook textbook) {
    setState(() {
      _recentlyClickedTextbooks.remove(textbook);
      _recentlyClickedTextbooks.insert(0, textbook);
      if (_recentlyClickedTextbooks.length > 3) {
        _recentlyClickedTextbooks.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6C74E1),
        title: Text('Baca Buku Teks', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
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
                hintText: 'Cari buku teks...',
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
            isSelected: [!showFavorites && !showHistory, showFavorites, showHistory],
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
            child: StreamBuilder<QuerySnapshot>(
              stream: _textbooksCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final textbooks = snapshot.data!.docs
                    .map((doc) => Textbook.fromFirestore(doc))
                    .toList();

                List<Textbook> filteredTextbooks = textbooks;
                if (showFavorites) {
                  filteredTextbooks = filteredTextbooks
                      .where((textbook) => textbook.isFavorite)
                      .toList();
                }

                if (showHistory) {
                  filteredTextbooks = _recentlyClickedTextbooks;
                } else if (searchTerm.isNotEmpty) {
                  filteredTextbooks = filteredTextbooks
                      .where((textbook) =>
                          textbook.name!.toLowerCase().contains(searchTerm))
                      .toList();
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: filteredTextbooks.length,
                  itemBuilder: (context, index) {
                    Textbook textbook = filteredTextbooks[index];
                    Color cardColor = _getPastelColor(index);

                    return GestureDetector(
                      onTap: () {
                        _updateHistory(textbook);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TextbookDetailsPage(
                              textbook: textbook,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        color: cardColor,
                        child: Stack(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  textbook.name!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(
                                  textbook.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: textbook.isFavorite ? Colors.red : Colors.grey,
                                ),
                                onPressed: () async {
                                  await textbook.toggleFavoriteStatus();
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
