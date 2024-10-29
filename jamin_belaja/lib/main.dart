import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jamin_belaja/screens/authenticate/login_page.dart';
import 'package:jamin_belaja/screens/authenticate/register.dart';
import 'package:jamin_belaja/screens/text_book/textbook_page.dart';
import 'package:jamin_belaja/screens/authenticate/profile_page.dart';
import 'package:jamin_belaja/screens/authenticate/edit_profile_page.dart';
import 'package:jamin_belaja/screens/exercise/exercise_page.dart'; // Import the ExercisePage
import 'package:jamin_belaja/screens/question/post_question.dart';
import 'package:jamin_belaja/screens/question/question_list.dart'; // Import the QuestionListPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<User?>.value(
//       value: AuthService().user,
//       initialData: null,
//       child: MaterialApp(
//         home: Wrapper(), // Set Wrapper as the initial screen
//         // routes: {
//         //   '/login': (context) => SignIn(toggleView: () {}),
//         // },
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/profile': (context) => ProfilePage(),
        '/edit_profile': (context) => EditProfilePage(),
        '/post_question': (context) =>
            PostQuestionPage(), // Add the route for posting questions
        '/exercise': (context) => ExercisePage(),
        '/questions': (context) => QuestionList(),
        '/textbooks': (context) =>
            TextbookPage(), // Add the route for ExercisePage
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.all(20.0), // Adding padding around the content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Welcome Text
            Text(
              'Welcome to JaminBelaja!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10), // Adding some space between the two texts
            Text(
              'First time here?',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40), // Adding space before buttons

            // Log In Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                minimumSize:
                    Size(double.infinity, 50), // Button takes full width
              ),
              child: Text('Log In'),
            ),
            SizedBox(height: 20), // Space between buttons

            // Sign Up Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              style: ElevatedButton.styleFrom(
                minimumSize:
                    Size(double.infinity, 50), // Button takes full width
              ),
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
