import 'package:flutter/material.dart';
import 'package:jamin_belaja/main.dart';
import 'package:jamin_belaja/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jamin_belaja/models/user.dart';
// import 'profile_page.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Color(0xFF6C74E1), // AppBar background color set to the new color
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage()), // Navigate to MainPage
            );
          },
        ),
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Log In",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential userCredential =
                        await _auth.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    // Fetch user details from Firebase
                    String userName = emailController
                        .text; // Replace with actual user name retrieval logic
                    StudentData user = StudentData(
                        name: userName,
                        email: emailController.text,
                        uid: '',
                        password: ''); // Create a UserModel instance

                    // Navigate to main page after successful login
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(user: user),
                        ) // Pass the user object
                        );
                  } catch (e) {
                    // Handle error (you can also show a snackbar here)
                    print("Login failed: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Login failed. Please try again.")),
                    );
                  }
                },
                child: Text("Log In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
