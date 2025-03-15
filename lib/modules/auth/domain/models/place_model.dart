import 'package:flutter/foundation.dart';

class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class Place {
  final String id;
  final String name;
  final String description;
  final String category;
  final double rating;
  final int reviewsCount;
  final List<String> tags;
  final Location location;
  final DateTime createdAt;
  final DateTime updatedAt;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.rating,
    required this.reviewsCount,
    required this.tags,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      rating: json['rating'] as double,
      reviewsCount: json['reviewsCount'] as int,
      tags: List<String>.from(json['tags']),
      location: Location.fromJson(json['location']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'category': category,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'tags': tags,
      'location': location.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
} 