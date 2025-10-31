class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.isGuest,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final bool isGuest;

  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    bool? isGuest,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}
