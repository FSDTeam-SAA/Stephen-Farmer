class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;

  const User({required this.id, required this.name, required this.email, this.avatarUrl, required this.createdAt});

  User copyWith({String? id, String? name, String? email, String? avatarUrl, DateTime? createdAt}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
