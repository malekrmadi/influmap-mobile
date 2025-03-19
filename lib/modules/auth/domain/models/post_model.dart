class Post {
  final String userId;
  final String placeId;
  final String type;
  final List<String> media;
  final String text;
  final DateTime expiresAt;

  Post({
    required this.userId,
    required this.placeId,
    required this.type,
    required this.media,
    required this.text,
    required this.expiresAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] as String,
      placeId: json['placeId'] as String,
      type: json['type'] as String,
      media: List<String>.from(json['media'] as List),
      text: json['text'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'placeId': placeId,
      'type': type,
      'media': media,
      'text': text,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
} 