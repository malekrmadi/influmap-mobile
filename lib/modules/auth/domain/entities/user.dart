class User {
  final String id;
  final String username;
  final String email;
  final String token;
  final String avatar;
  final String bio;
  final int level;
  final List<String> badges;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
    required this.avatar,
    required this.bio,
    required this.level,
    required this.badges,
  });
}
