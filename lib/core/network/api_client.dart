import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final String baseUrl = "http://10.0.2.2:5001"; // Backend base URL
  final String loginEndpoint = "/api/users/login"; // Login endpoint
  final String signupEndpoint = "/api/users/signup"; // Signup endpoint
  final String usersEndpoint = "/api/users"; // Get all users
  final String placesEndpoint = "/api/places"; // Get all places
  final String followersCountEndpoint = "/api/friendships/followers/count/"; // Get followers count
  final String followingCountEndpoint = "/api/friendships/following/count/"; // Get following count

  // General method for making POST requests
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint"); // Full URL for the request
    print("🔹 Sending POST request to: $url");
    print("📤 Request Body: ${jsonEncode(body)}");

    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );

    print("📥 Response Status Code: ${response.statusCode}");
    print("📥 Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("❌ Request failed: ${response.body}");
    }
  }

  // General method for making GET requests
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint"); // Full URL for the request


    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );



    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("❌ Request failed: ${response.body}");
    }
  }

  // Login function
  Future<Map<String, dynamic>> login(String email, String password) async {
    return await post(loginEndpoint, {"email": email, "password": password});
  }

  // Signup function
  Future<Map<String, dynamic>> signup(
      String username,
      String email,
      String password,
      String avatar,
      String bio,
      int level,
      List<String> badges) async {
    return await post(signupEndpoint, {
      "username": username,
      "email": email,
      "password": password,
      "avatar": avatar,
      "bio": bio,
      "level": level,
      "badges": badges,
    });
  }

  // Get all users
  Future<List<dynamic>> getAllUsers() async {
    return await get(usersEndpoint);
  }

  // Get all places
  Future<List<dynamic>> getAllPlaces() async {
    return await get(placesEndpoint);
  }

  // Get followers count
  Future<int> getFollowersCount(String userId) async {
    final response = await get("$followersCountEndpoint$userId");
    return response["followersCount"];
  }

  // Get following count
  Future<int> getFollowingCount(String userId) async {
    final response = await get("$followingCountEndpoint$userId");
    return response["followingCount"];
  }
}
