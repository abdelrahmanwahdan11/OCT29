class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isGuest,
    required this.avatarUrl,
    required this.kycLevel,
    required this.reputation,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isGuest;
  final String avatarUrl;
  final int kycLevel;
  final double reputation;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    bool? isGuest,
    String? avatarUrl,
    int? kycLevel,
    double? reputation,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isGuest: isGuest ?? this.isGuest,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      kycLevel: kycLevel ?? this.kycLevel,
      reputation: reputation ?? this.reputation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'isGuest': isGuest,
      'avatarUrl': avatarUrl,
      'kycLevel': kycLevel,
      'reputation': reputation,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      isGuest: json['isGuest'] as bool,
      avatarUrl: json['avatarUrl'] as String,
      kycLevel: json['kycLevel'] as int,
      reputation: (json['reputation'] as num).toDouble(),
    );
  }
}
