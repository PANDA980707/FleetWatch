class UserModel {
  final String uid;
  final String email;
  final String role;
  final String? name;
  final String? phone;
  final String? rank;
  final String? photoUrl;
  final String? cvUrl;
  final String? citizenship;
  final String? experience;

  const UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.name,
    this.phone,
    this.rank,
    this.photoUrl,
    this.cvUrl,
    this.citizenship,
    this.experience,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'name': name,
      'phone': phone,
      'rank': rank,
      'photoUrl': photoUrl,
      'cvUrl': cvUrl,
      'citizenship': citizenship,
      'experience': experience,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      role: map['role'] ?? 'seafarer',
      name: map['name'],
      phone: map['phone'],
      rank: map['rank'],
      photoUrl: map['photoUrl'],
      cvUrl: map['cvUrl'],
      citizenship: map['citizenship'],
      experience: map['experience'],
    );
  }
}
