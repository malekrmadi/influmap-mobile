import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:auth/core/theme/app_theme.dart';
import 'package:auth/setup_locator.dart';
import '../../domain/models/place_model.dart';
import '../../domain/repositories/place_repository.dart';
import '../widgets/add_place_form.dart';
import '../widgets/place_marker.dart';
import '../pages/place_details_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final PlaceRepository _placeRepository;
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  List<Place> _places = [];
  bool _isLoading = true;
  String _errorMessage = '';
  
  // Position initiale de la carte (Paris)
  final LatLng _parisCenter = LatLng(48.8566, 2.3522);
  
  // État du formulaire d'ajout de lieu
  bool _showAddPlaceForm = false;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _placeRepository = sl<PlaceRepository>();
    _loadPlaces();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(_parisCenter, 13.0);
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPlaces() async {
    try {
      final places = await _placeRepository.getAllPlaces();
      setState(() {
        _places = places;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement des lieux: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _addPlace(Place place) async {
    try {
      print('🚀 Début de l\'ajout d\'un lieu: ${place.name}');
      print('📍 Coordonnées: ${place.location.latitude}, ${place.location.longitude}');
      print('🔖 Catégorie: ${place.category}');
      print('🏷️ Tags: ${place.tags.join(', ')}');
      
      final createdPlace = await _placeRepository.createPlace(place);
      print('✅ Lieu créé avec succès (id: ${createdPlace.id})');
      
      await _loadPlaces(); // Recharger la liste des lieux
      setState(() {
        _showAddPlaceForm = false;
        _selectedLocation = null;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lieu "${place.name}" ajouté avec succès'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('❌ Erreur lors de l\'ajout du lieu: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'ajout du lieu: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _handleMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _selectedLocation = point;
      _showAddPlaceForm = true;
    });
  }

  void _navigateToPlaceDetails(Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceDetailsPage(
          placeId: place.id,
          place: place,
        ),
      ),
    );
  }

  void _zoomIn() {
    _mapController.move(
      _mapController.center,
      _mapController.zoom + 1,
    );
  }

  void _zoomOut() {
    _mapController.move(
      _mapController.center,
      _mapController.zoom - 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _parisCenter,
              zoom: 13.0,
              onTap: _handleMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.auth.app',
              ),
              // Marqueurs des lieux
              MarkerLayer(
                markers: _places.map((place) => Marker(
                  point: LatLng(
                    place.location.latitude,
                    place.location.longitude,
                  ),
                  width: 120,
                  height: 120,
                  builder: (context) => PlaceMarker(
                    place: place,
                    onTap: () => _navigateToPlaceDetails(place),
                  ),
                )).toList(),
              ),
              // Marqueur de la position sélectionnée
              if (_selectedLocation != null && _showAddPlaceForm)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 40,
                      height: 40,
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_location_alt,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Search Bar
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher un lieu...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          
          // Zoom Controls
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  onPressed: _zoomIn,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  onPressed: _zoomOut,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
          
          // Formulaire d'ajout de lieu
          if (_showAddPlaceForm && _selectedLocation != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AddPlaceForm(
                    latitude: _selectedLocation!.latitude,
                    longitude: _selectedLocation!.longitude,
                    onSubmit: _addPlace,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
