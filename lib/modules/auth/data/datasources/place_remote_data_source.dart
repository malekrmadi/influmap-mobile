//import 'dart:convert';
import 'dart:convert';
import 'package:auth/core/network/api_client.dart';
import '../../domain/models/place_model.dart';

class PlaceRemoteDataSource {
  final ApiClient _apiClient;

  PlaceRemoteDataSource(this._apiClient);

  Future<List<Place>> getAllPlaces() async {
    try {
      print('📥 Récupération de tous les lieux...');
      final List<dynamic> data = await _apiClient.getAllPlaces();
      print('✅ ${data.length} lieux récupérés avec succès');
      
      final places = data.map((json) {
        try {
          return Place.fromJson(json);
        } catch (e) {
          print('⚠️ Erreur lors de la conversion d\'un lieu: $e');
          print('⚠️ Données problématiques: ${jsonEncode(json)}');
          throw Exception('Erreur de format dans les données du lieu: $e');
        }
      }).toList();
      
      return places;
    } catch (e) {
      print('❌ Erreur lors de la récupération des lieux: $e');
      throw Exception('Error fetching places: $e');
    }
  }

  Future<Place> getPlaceById(String id) async {
    try {
      print('📥 Récupération du lieu avec l\'id: $id');
      final dynamic data = await _apiClient.getPlaceById(id);
      print('✅ Lieu récupéré avec succès: ${jsonEncode(data)}');
      
      try {
        return Place.fromJson(data);
      } catch (e) {
        print('⚠️ Erreur lors de la conversion du lieu: $e');
        print('⚠️ Données problématiques: ${jsonEncode(data)}');
        throw Exception('Erreur de format dans les données du lieu: $e');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération du lieu: $e');
      throw Exception('Error fetching place: $e');
    }
  }
  
  Future<Place> createPlace(Place place) async {
    try {
      // Conversion du Place en Map pour l'API
      final Map<String, dynamic> placeData = {
        'name': place.name,
        'description': place.description,
        'category': place.category,
        'location': {
          'latitude': place.location.latitude,
          'longitude': place.location.longitude,
        },
        'rating': place.rating,
        'reviewsCount': place.reviewsCount,
        'tags': place.tags,
      };
      
      // Log de la requête pour debug
      print('📤 Envoi de la requête pour créer un lieu: ${jsonEncode(placeData)}');
      
      // Appel de l'API
      final dynamic data = await _apiClient.createPlace(placeData);
      
      // Log de succès
      print('✅ Lieu créé avec succès: ${jsonEncode(data)}');
      
      try {
        return Place.fromJson(data);
      } catch (e) {
        print('⚠️ Erreur lors de la conversion du lieu créé: $e');
        print('⚠️ Données problématiques: ${jsonEncode(data)}');
        // Retourner le lieu original en cas d'erreur de parsing
        return place;
      }
    } catch (e) {
      print('❌ Erreur lors de la création du lieu: $e');
      throw Exception('Error creating place: $e');
    }
  }
} 