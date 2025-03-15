class User {
  final String id;
  final String username;
  final String email;
  final String? password;
  final String? avatar;
  final String? bio;
  final int level;
  final List<String> badges;
  final int followersCount;
  final int followingCount;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.password,
    this.avatar,
    this.bio,
    this.level = 1,
    this.badges = const [],
    this.followersCount = 0,
    this.followingCount = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      avatar: json['avatar'] as String?,
      bio: json['bio'] as String?,
      level: json['level'] as int? ?? 1,
      badges: json['badges'] != null 
          ? List<String>.from(json['badges']) 
          : [],
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'password': password,
      'avatar': avatar,
      'bio': bio,
      'level': level,
      'badges': badges,
      'followersCount': followersCount,
      'followingCount': followingCount,
    };
  }
} 