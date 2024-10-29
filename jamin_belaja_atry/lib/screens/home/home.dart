import 'package:flutter/material.dart';
import 'package:jamin_belaja/screens/exercise/exercise_page.dart';
import 'package:jamin_belaja/screens/text_book/textbook_page.dart';
import 'package:provider/provider.dart';
import 'package:jamin_belaja/screens/authenticate/sign_in.dart';
import 'package:jamin_belaja/screens/question/post_question.dart';
import 'package:jamin_belaja/screens/question/question_list.dart';
import 'package:jamin_belaja/services/auth.dart';
import 'package:jamin_belaja/models/user.dart' as custom_user;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return StreamProvider<custom_user.User?>.value(
      value: _auth.user,
      initialData: null,
      child: Consumer<custom_user.User?>(builder: (context, user, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Jamin'),
            centerTitle: true,
            actions: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  // Show confirmation dialog
                  bool? confirmLogout = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false); // Return false
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true); // Return true
                            },
                            child: Text('Logout'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmLogout == true) {
                    await _auth.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => SignIn(toggleView: () {})),
                    );
                  }
                },
                icon: Icon(Icons.logout),
                label: Text('Logout'),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TextbookPage()),
                    );
                  },
                  child: const Text('Buku Teks'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ExercisePage()),
                    );
                  },
                  child: const Text('Buku Latihan'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the question list page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuestionList()),
                    );
                  },
                  child: const Text('Questions'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the post a question page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostQuestionPage()),
                    );
                  },
                  child: const Text('Post a Question'),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}
