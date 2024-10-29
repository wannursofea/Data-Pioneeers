import 'package:flutter/material.dart';
import 'package:student_app_new/screens/authenticate/register.dart';
import 'package:student_app_new/services/auth.dart';
import 'package:student_app_new/shared/constants.dart';
import 'package:student_app_new/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  void dispose() {
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _loading,
      builder: (context, loading, child) {
        return loading
            ? Loading()
            : Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Color(int.parse('0xff6C47E1')),
                  elevation: 0.0,
                  title: Text('Sign in to Jamin App'),
                  actions: [
                    TextButton.icon(
                      icon: Icon(Icons.person),
                      label: Text('Register',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        widget.toggleView();
                      },
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SignInForm(
                    formKey: _formKey,
                    email: email,
                    password: password,
                    onEmailChanged: (value) => setState(() => email = value),
                    onPasswordChanged: (value) =>
                        setState(() => password = value),
                    onSubmit: () async {
                      if (_formKey.currentState!.validate()) {
                        _loading.value = true;
                        dynamic result = await _auth.signInWithEmailAndPassword(
                            email, password);
                        if (result == null) {
                          _loading.value = false;
                          setState(() {
                            error = 'Could not sign in with those credentials';
                          });
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) =>
                                    Register(toggleView: widget.toggleView)),
                          );
                        }
                      }
                    },
                    error: error,
                  ),
                ),
              );
      },
    );
  }
}

class SignInForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String email;
  final String password;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final Function onSubmit;
  final String error;

  SignInForm({
    required this.formKey,
    required this.email,
    required this.password,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onSubmit,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'Email'),
            validator: (val) => val!.isEmpty ? 'Enter an email' : null,
            onChanged: onEmailChanged,
          ),
          SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'Password'),
            obscureText: true,
            validator: (val) =>
                val!.length < 6 ? 'Enter a password 6+ chars long' : null,
            onChanged: onPasswordChanged,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            child: Text('Sign In', style: TextStyle(color: Colors.white)),
            onPressed: () => onSubmit(),
          ),
          SizedBox(height: 12.0),
          Text(
            error,
            style: TextStyle(color: Colors.red, fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
