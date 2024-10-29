import 'package:flutter/material.dart';
import 'package:jamin_belaja/models/user.dart';
import 'package:jamin_belaja/screens/authenticate/profile_page.dart';
import 'package:jamin_belaja/screens/authenticate/edit_profile_page.dart';
import 'package:jamin_belaja/screens/exercise/exercise_page.dart'; // Import the ExercisePage
import 'package:jamin_belaja/screens/question/post_question.dart'; // Import the PostQuestionPage
import 'package:jamin_belaja/screens/question/question_list.dart'; // Import the QuestionListPage
import 'package:jamin_belaja/screens/text_book/textbook_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(
          user: StudentData(
              name: "Guest",
              email: "guest@example.com",
              uid: '',
              password: '')),
      routes: {
        '/profile': (context) => ProfilePage(),
        '/edit_profile': (context) => EditProfilePage(),
        '/post_question': (context) =>
            PostQuestionPage(), // Add the route for posting questions
        '/exercise': (context) =>
            ExercisePage(), // Add the route for ExercisePage
        '/questions': (context) => QuestionList(),
        '/textbooks': (context) =>
            TextbookPage(), // Add the route for QuestionList
      },
    );
  }
}

class MainPage extends StatelessWidget {
  final StudentData user; // Add a field to hold user info
  MainPage({required this.user}); // Constructor

  final List<String> recentHistory = [
    "Sejarah Textbook",
    "Math Notes",
    "Science Homework"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6C74E1),
        title: Text('Main Page'),
        automaticallyImplyLeading: false, // Remove back arrow
      ),
      body: SingleChildScrollView(
        // Make the entire page scrollable
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // "Hello, Welcome" text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hello, Welcome 👋",
                            style: TextStyle(fontSize: 24)),
                        Text(user.name,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight:
                                    FontWeight.bold)), // Use user's name
                      ],
                    ),
                  ),
                  // Profile picture (CircleAvatar)
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                        'assets/user_profile.png'), // Display profile picture
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                  "Empowering Your Learning Journey, No Matter the Challenges!",
                  style: TextStyle(fontSize: 22, color: Colors.blueAccent)),
              SizedBox(height: 20),

              // Post a Question Section
              Card(
                child: ListTile(
                  title: Text('Post a Question'),
                  subtitle: Text('Share your questions with others!'),
                  trailing: Icon(Icons.question_answer),
                  onTap: () {
                    // Navigate to the PostQuestionPage
                    Navigator.pushNamed(context, '/post_question');
                  },
                ),
              ),
              SizedBox(height: 20),

              // Question List Section
              Card(
                child: ListTile(
                  title: Text('View Questions'),
                  subtitle: Text('Browse questions shared by others!'),
                  trailing: Icon(Icons.list),
                  onTap: () {
                    // Navigate to the QuestionListPage
                    Navigator.pushNamed(context, '/questions');
                  },
                ),
              ),
              SizedBox(height: 20),

              // Recent History Section
              Text("Continue where you left off",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap:
                    true, // Ensure it doesn't take more space than needed
                physics:
                    NeverScrollableScrollPhysics(), // Disable scrolling of ListView
                itemCount: recentHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(recentHistory[index]),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navigate to the respective book or note page
                    },
                  );
                },
              ),

              SizedBox(height: 20),

              // Exercise Section
              Text("Exercise Section",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: Text('Access Exercises'),
                  subtitle: Text('Practice your skills with exercises!'),
                  trailing: Icon(Icons.assignment),
                  onTap: () {
                    // Navigate to the ExercisePage
                    Navigator.pushNamed(context, '/exercise');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Set to 0 because it's the home page
        onTap: (int index) {
          if (index == 0) {
            // Home Button: Stay on this page
          } else if (index == 1) {
            Navigator.pushNamed(context, '/textbooks');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'TextBook',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
