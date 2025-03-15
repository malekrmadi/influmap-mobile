import '../models/place_model.dart';

abstract class PlaceRepository {
  Future<List<Place>> getAllPlaces();
  Future<Place> getPlaceById(String id);
} 