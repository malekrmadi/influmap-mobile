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
  List<Place> _filteredPlaces = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';
  bool _showSearchResults = false;
  
  // Position initiale de la carte (Paris)
  final LatLng _parisCenter = LatLng(48.8566, 2.3522);
  
  // État du formulaire d'ajout de lieu
  bool _showAddPlaceForm = false;
  LatLng? _selectedLocation;
  
  // État du zoom
  double _currentZoom = 13.0;

  @override
  void initState() {
    super.initState();
    _placeRepository = sl<PlaceRepository>();
    _loadPlaces();
    
    _mapController.mapEventStream.listen((event) {
      // Mise à jour du niveau de zoom actuel
      if (event is MapEventMoveEnd) {
        setState(() {
          _currentZoom = event.zoom;
        });
      }
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(_parisCenter, 13.0);
    });
    
    // Écoute des changements dans la barre de recherche
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _showSearchResults = _searchQuery.isNotEmpty;
      _filterPlaces();
    });
  }

  void _filterPlaces() {
    if (_searchQuery.isEmpty) {
      _filteredPlaces = [];
    } else {
      _filteredPlaces = _places.where((place) => 
        place.name.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
  }

  void _selectPlaceFromSearch(Place place) {
    setState(() {
      _showSearchResults = false;
      _searchController.text = place.name;
    });
    
    // Centrer la carte sur le lieu sélectionné
    _mapController.move(
      LatLng(place.location.latitude, place.location.longitude),
      15.0 // Zoom plus prononcé pour mieux voir le lieu
    );
  }

  Future<void> _loadPlaces() async {
    try {
      final places = await _placeRepository.getAllPlaces();
      setState(() {
        _places = places;
        _isLoading = false;
        _filterPlaces();
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
      
      // Centrer la carte sur le nouveau lieu
      _mapController.move(
        LatLng(place.location.latitude, place.location.longitude),
        15.0
      );
      
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
    // Fermer les résultats de recherche si ouverts
    setState(() {
      _showSearchResults = false;
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

  // Détermine si les noms des lieux doivent être affichés en fonction du zoom
  bool _shouldShowLabels() {
    return _currentZoom >= 12.0; // Afficher les noms seulement à partir d'un certain niveau de zoom
  }
  
  // Calcule la taille relative des marqueurs en fonction du zoom
  double _getMarkerScale() {
    // La taille augmente avec le zoom, avec un minimum et un maximum
    return 0.6 + (_currentZoom - 10) * 0.1; // Formule simple pour l'échelle
  }

  @override
  Widget build(BuildContext context) {
    final markerScale = _getMarkerScale().clamp(0.7, 1.5); // Limiter l'échelle entre 0.7 et 1.5
    
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
                  width: 140 * markerScale,
                  height: 100 * markerScale,
                  builder: (context) => PlaceMarker(
                    place: place,
                    onTap: () => _navigateToPlaceDetails(place),
                    showLabel: _shouldShowLabels(),
                    scale: markerScale,
                  ),
                )).toList(),
              ),
              // Marqueur de la position sélectionnée
              if (_selectedLocation != null && _showAddPlaceForm)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 40 * markerScale,
                      height: 40 * markerScale,
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_location_alt,
                          color: Colors.white,
                          size: 24 * markerScale,
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
            child: Column(
              children: [
                Container(
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
                      suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _showSearchResults = false;
                              });
                            },
                          )
                        : null,
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
                if (_showSearchResults && _filteredPlaces.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(
                      maxHeight: 200,
                      maxWidth: MediaQuery.of(context).size.width - 32,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredPlaces.length,
                      itemBuilder: (context, index) {
                        final place = _filteredPlaces[index];
                        return ListTile(
                          leading: Icon(
                            _getCategoryIcon(place.category),
                            color: _getCategoryColor(place.category),
                          ),
                          title: Text(place.name),
                          subtitle: Text(place.category),
                          onTap: () => _selectPlaceFromSearch(place),
                        );
                      },
                    ),
                  ),
              ],
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
  
  // Fonctions utilitaires pour les icônes et couleurs des catégories (doublons de PlaceMarker pour simplicité)
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'restaurant':
        return Icons.restaurant;
      case 'café':
        return Icons.coffee;
      case 'bar':
        return Icons.local_bar;
      case 'événement':
        return Icons.event;
      case 'autre':
        return Icons.location_on;
      default:
        return Icons.place;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'restaurant':
        return Colors.orange;
      case 'café':
        return Colors.brown;
      case 'bar':
        return Colors.purple;
      case 'événement':
        return Colors.red;
      case 'autre':
        return Colors.teal;
      default:
        return Colors.blueGrey;
    }
  }
}
