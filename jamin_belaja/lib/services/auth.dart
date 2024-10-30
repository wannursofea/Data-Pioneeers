import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:jamin_belaja/services/database.dart';
import 'package:jamin_belaja/models/user.dart' as custom_user;

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  // Create user object based on FirebaseUser
  custom_user.User? _userFromFirebaseUser(firebase_auth.User? user) {
    return user != null ? custom_user.User(uid: user.uid) : null;
  }

  // Auth change user stream
  Stream<custom_user.User?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Get current user
  firebase_auth.User? get currentUser {
    return _auth.currentUser;
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      firebase_auth.UserCredential result = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      firebase_auth.User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // // Register with email and password
  // Future registerWithEmailAndPassword(String email, String password) async {
  //   try {
  //     firebase_auth.UserCredential result = await _auth
  //         .createUserWithEmailAndPassword(email: email, password: password);
  //     firebase_auth.User? user = result.user;

  //     //create a new document for the user with the uid
  //     await DatabaseService(uid: user!.uid)
  //         .updateUserData('new user', email, password); // Updated

  //     return _userFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // Inside auth.dart
Future<custom_user.User?> registerWithEmailAndPassword(
    String email,
    String password,
    String name) async {
  try {
    firebase_auth.UserCredential result = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);
    firebase_auth.User? user = result.user;

    // Create a new document for the user with the uid and additional data
    await DatabaseService(uid: user!.uid).updateUserData(
      name,
      email,
      password,
    );

    return _userFromFirebaseUser(user);
  } catch (e) {
    print(e.toString());
    return null;
  }
}


  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
