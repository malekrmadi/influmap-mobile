import '../../domain/models/place_model.dart';
import '../../domain/repositories/place_repository.dart';
import '../datasources/place_remote_data_source.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final PlaceRemoteDataSource remoteDataSource;
  
  PlaceRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<List<Place>> getAllPlaces() async {
    return await remoteDataSource.getAllPlaces();
  }
  
  @override
  Future<Place> getPlaceById(String id) async {
    return await remoteDataSource.getPlaceById(id);
  }
  
  @override
  Future<Place> createPlace(Place place) async {
    return await remoteDataSource.createPlace(place);
  }
} 