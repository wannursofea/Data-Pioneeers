import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
    'Secondary School': [
      'Form 1',
      'Form 2',
      'Form 3',
      'Form 4',
      'Form 5'
    ],
  };

  String? selectedEducationLevel;
  String? selectedGrade;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6C74E1),
        title: Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Add code to change profile picture
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/user_profile.png'),
                      ),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                CustomTextField(label: 'Username', icon: Icons.person),
                CustomTextField(label: 'Age', icon: Icons.cake),
                CustomTextField(label: 'Email', icon: Icons.email),
                
                // Education Level Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Education Level',
                      prefixIcon: Icon(Icons.school, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    value: selectedEducationLevel,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedEducationLevel = newValue;
                        selectedGrade = null; // Reset grade when education level changes
                      });
                    },
                    items: educationLevels.map<DropdownMenuItem<String>>((String level) {
                      return DropdownMenuItem<String>(
                        value: level,
                        child: Text(level),
                      );
                    }).toList(),
                  ),
                ),

                // Grade Dropdown (conditional)
                if (selectedEducationLevel != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Grade/Form',
                        prefixIcon: Icon(Icons.grade, color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      value: selectedGrade,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGrade = newValue;
                        });
                      },
                      items: selectedEducationLevel != null
                          ? grades[selectedEducationLevel]!.map<DropdownMenuItem<String>>((String grade) {
                              return DropdownMenuItem<String>(
                                value: grade,
                                child: Text(grade),
                              );
                            }).toList()
                          : [],
                    ),
                  ),

                CustomTextField(label: 'Phone Number', icon: Icons.phone),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Save profile logic
                    Navigator.pop(context); // Return to profile page after saving
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6C74E1),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;

  CustomTextField({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }
}
