import '../../domain/models/place_model.dart';
import '../../domain/repositories/place_repository.dart';
import '../datasources/place_remote_data_source.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final PlaceRemoteDataSource remoteDataSource;
  
  PlaceRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<List<Place>> getAllPlaces() async {
    try {
      return await remoteDataSource.getAllPlaces();
    } catch (e) {
      // For development, return mock data if API is not available
      return _getMockPlaces();
    }
  }
  
  @override
  Future<Place> getPlaceById(String id) async {
    try {
      return await remoteDataSource.getPlaceById(id);
    } catch (e) {
      // For development, return mock data if API is not available
      return _getMockPlaces().firstWhere((place) => place.id == id, 
        orElse: () => _getMockPlaces().first);
    }
  }
  
  @override
  Future<Place> createPlace(Place place) async {
    // Simulation d'un appel API
    await Future.delayed(const Duration(seconds: 1));
    // Dans une vraie implémentation, on enverrait les données à l'API
    // et on retournerait la réponse
    return place;
  }
  
  // Mock data for development
  List<Place> _getMockPlaces() {
    return [
      Place(
        id: '67c5206857141410588d993b',
        name: 'Café Cosy',
        description: 'Un endroit parfait pour travailler et se détendre',
        category: 'Café',
        rating: 4.3,
        reviewsCount: 3,
        tags: ['brunch', 'cosy'],
        location: Location(latitude: 48.8566, longitude: 2.3522),
        createdAt: DateTime.parse('2025-03-03T03:22:16.906Z'),
        updatedAt: DateTime.parse('2025-03-03T04:04:48.376Z'),
      ),
      Place(
        id: '67c5206857141410588d993c',
        name: 'Restaurant Gourmet',
        description: 'Cuisine raffinée dans un cadre élégant',
        category: 'Restaurant',
        rating: 4.7,
        reviewsCount: 12,
        tags: ['gastronomie', 'élégant'],
        location: Location(latitude: 48.8584, longitude: 2.3488),
        createdAt: DateTime.parse('2025-03-02T14:30:00.000Z'),
        updatedAt: DateTime.parse('2025-03-03T09:15:22.000Z'),
      ),
      Place(
        id: '67c5206857141410588d993d',
        name: 'Bar à Cocktails',
        description: 'Ambiance festive et cocktails créatifs',
        category: 'Bar',
        rating: 4.5,
        reviewsCount: 8,
        tags: ['cocktails', 'soirée'],
        location: Location(latitude: 48.8605, longitude: 2.3376),
        createdAt: DateTime.parse('2025-03-01T18:45:00.000Z'),
        updatedAt: DateTime.parse('2025-03-02T22:10:15.000Z'),
      ),
      Place(
        id: '67c5206857141410588d993e',
        name: 'Café Littéraire',
        description: 'Café chaleureux avec une grande bibliothèque',
        category: 'Café',
        rating: 4.2,
        reviewsCount: 5,
        tags: ['livres', 'calme'],
        location: Location(latitude: 48.8530, longitude: 2.3499),
        createdAt: DateTime.parse('2025-02-28T10:20:00.000Z'),
        updatedAt: DateTime.parse('2025-03-01T15:30:45.000Z'),
      ),
      Place(
        id: '67c5206857141410588d993f',
        name: 'Restaurant Italien',
        description: 'Authentiques saveurs italiennes',
        category: 'Restaurant',
        rating: 4.6,
        reviewsCount: 15,
        tags: ['italien', 'pizza', 'pasta'],
        location: Location(latitude: 48.8550, longitude: 2.3450),
        createdAt: DateTime.parse('2025-02-27T12:15:00.000Z'),
        updatedAt: DateTime.parse('2025-03-02T18:45:30.000Z'),
      ),
      Place(
        id: '67c5206857141410588d9940',
        name: 'Bar Lounge',
        description: 'Ambiance détendue et musique live',
        category: 'Bar',
        rating: 4.4,
        reviewsCount: 7,
        tags: ['musique', 'lounge'],
        location: Location(latitude: 48.8620, longitude: 2.3400),
        createdAt: DateTime.parse('2025-02-26T20:30:00.000Z'),
        updatedAt: DateTime.parse('2025-03-01T23:55:10.000Z'),
      ),
    ];
  }
} 