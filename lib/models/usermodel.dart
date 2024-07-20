class UserModel {
  String uid;
  String name;
  String email;
  String profilePicUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePicUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      profilePicUrl: map['profilePicUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePicUrl': profilePicUrl,
    };
  }
}
