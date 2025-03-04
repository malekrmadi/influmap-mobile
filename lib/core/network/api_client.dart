import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final String baseUrl = "http://10.0.2.2:5001"; // Backend base URL
  final String loginEndpoint = "/api/users/login"; // Login endpoint

  // General method for making POST requests
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$loginEndpoint"); // Full URL for the request
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

  // Login function that calls the POST request
  Future<Map<String, dynamic>> login(String email, String password) async {
    print("🔍 Debug: login URL before calling post: $baseUrl$loginEndpoint");
    return await post(loginEndpoint, {"email": email, "password": password});
  }
}
