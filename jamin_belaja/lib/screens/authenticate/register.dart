import 'package:flutter/material.dart';
import 'package:jamin_belaja/main.dart';
import 'package:jamin_belaja/services/auth.dart';
import 'package:jamin_belaja/services/database.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService _auth = AuthService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedEducationLevel;
  String? selectedGrade;
  String errorMessage = '';
  String nameError = '';
  String usernameError = '';
  String ageError = '';
  String emailError = '';
  String phoneError = '';
  String passwordError = '';

  final List<String> educationLevels = ['Primary School', 'Secondary School'];
  final Map<String, List<String>> grades = {
    'Primary School': [
      'Standard 1',
      'Standard 2',
      'Standard 3',
      'Standard 4',
      'Standard 5',
      'Standard 6'
    ],
    'Secondary School': ['Form 1', 'Form 2', 'Form 3', 'Form 4', 'Form 5'],
  };

  bool validateFields() {
    setState(() {
      nameError = nameController.text.isEmpty ? 'Name is required' : '';
      usernameError = usernameController.text.isEmpty ? 'Username is required' : '';
      ageError = ageController.text.isEmpty ? 'Age is required' : '';
      emailError = emailController.text.isEmpty ? 'Email is required' : '';
      phoneError = phoneController.text.isEmpty ? 'Phone number is required' : '';
      passwordError = passwordController.text.isEmpty ? 'Password is required' : '';
      if (emailController.text.isNotEmpty &&
          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
        emailError = 'Invalid email format';
      }
    });
    return nameError.isEmpty &&
        usernameError.isEmpty &&
        ageError.isEmpty &&
        emailError.isEmpty &&
        phoneError.isEmpty &&
        passwordError.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6C74E1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        title: Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Create Your Profile",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                    errorText: nameError.isNotEmpty ? nameError : null,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                    errorText: usernameError.isNotEmpty ? usernameError : null,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Age",
                    border: OutlineInputBorder(),
                    errorText: ageError.isNotEmpty ? ageError : null,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    errorText: emailError.isNotEmpty ? emailError : null,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                    errorText: phoneError.isNotEmpty ? phoneError : null,
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedEducationLevel,
                  hint: Text("Select Education Level"),
                  items: educationLevels.map((String level) {
                    return DropdownMenuItem<String>(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedEducationLevel = newValue;
                      selectedGrade = null;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                if (selectedEducationLevel != null)
                  DropdownButtonFormField<String>(
                    value: selectedGrade,
                    hint: Text("Select Grade/Form"),
                    items: grades[selectedEducationLevel]!.map((String grade) {
                      return DropdownMenuItem<String>(
                        value: grade,
                        child: Text(grade),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGrade = newValue;
                      });
                    },
                    decoration: InputDecoration(
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
                    errorText: passwordError.isNotEmpty ? passwordError : null,
                  ),
                ),
                SizedBox(height: 20),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ElevatedButton(
                  onPressed: () async {
                    if (validateFields()) {
                      try {
                        var user = await _auth.registerWithEmailAndPassword(
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                        );

                        if (user != null) {
                          // Add user details to the students collection
                          DatabaseService databaseService = DatabaseService(uid: user.uid);
                          await databaseService.updateUserData(
                            nameController.text,
                            emailController.text,
                            passwordController.text,
                          );

                          Navigator.pushNamed(context, '/login');
                        } else {
                          setState(() {
                            errorMessage = 'Registration failed. Please try again.';
                          });
                        }
                      } catch (e) {
                        setState(() {
                          errorMessage = e.toString();
                        });
                      }
                    }
                  },
                  child: Text("Create Account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}