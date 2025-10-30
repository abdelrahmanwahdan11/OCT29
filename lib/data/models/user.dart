class User {
  User({required this.id, required this.name, this.email});

  final String id;
  final String name;
  final String? email;

  bool get isGuest => email == null;
}
