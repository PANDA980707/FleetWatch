enum UserRole { seaman, crewing }

class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'role': role.name,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
        role: UserRole.values.byName(json['role'] as String),
      );
}
