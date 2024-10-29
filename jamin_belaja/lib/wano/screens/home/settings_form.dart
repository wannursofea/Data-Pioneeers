import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jamin_belaja/wano/models/user.dart';
import 'package:jamin_belaja/wano/services/database.dart';
import 'package:jamin_belaja/wano/shared/constants.dart';
import 'package:jamin_belaja/wano/shared/loading.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  // final List<STring> sugars = ['0', '1', '2', '3', '4'];

  // // form values
  String _currentName = '';
  String _currentEmail = '';
  String _currentPassword = '';

  Widget build(BuildContext context) {
    final user =
        Provider.of<User?>(context); // get the user object from the provider

    return StreamBuilder<StudentData>(
        stream:
            user != null ? DatabaseService(uid: user.uid).studentData : null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            StudentData studentData = snapshot.data!;
            return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Update your student settings.',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: studentData.name,
                      decoration:
                          textInputDecoration, //.copyWith(hintText: 'Name'),
                      validator: (val) => (val == null || val.isEmpty)
                          ? 'Please enter a name'
                          : null,
                      onChanged: (val) => setState(() => _currentName = val),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Color(int.parse('0xff6C47E1'))),
                      ),
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await DatabaseService(uid: user!.uid).updateUserData(
                              _currentName, _currentEmail, _currentPassword);
                          // _currentName ?? studentData.name,
                          // _currentEmail ?? studentData.email,
                          // _currentPassword ?? studentData.password);
                          Navigator.pop(context);
                        }
                      },
                    )
                  ],
                ));
          } else {
            return Loading();
          }
        });
  }
}
