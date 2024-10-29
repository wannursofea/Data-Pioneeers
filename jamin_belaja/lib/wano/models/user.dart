class User {
  final String uid;

  User({required this.uid});
}

class StudentData {
  final String uid;
  final String name;
  final String email;
  final String password;

  StudentData(
      {required this.uid,
      required this.name,
      required this.email,
      required this.password});
}
