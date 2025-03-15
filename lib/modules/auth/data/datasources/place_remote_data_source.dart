import 'dart:convert';
import 'package:auth/core/network/api_client.dart';
import '../../domain/models/place_model.dart';

class PlaceRemoteDataSource {
  final ApiClient _apiClient;

  PlaceRemoteDataSource(this._apiClient);

  Future<List<Place>> getAllPlaces() async {
    try {
      final List<dynamic> data = await _apiClient.getAllPlaces();
      return data.map((json) => Place.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching places: $e');
    }
  }

  Future<Place> getPlaceById(String id) async {
    try {
      final dynamic data = await _apiClient.getPlaceById(id);
      return Place.fromJson(data);
    } catch (e) {
      throw Exception('Error fetching place: $e');
    }
  }
} 