import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/place_model.dart';
import '../../domain/repositories/place_repository.dart';
import 'package:auth/setup_locator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class PlaceDetailsPage extends StatefulWidget {
  final String placeId;
  final Place? place; // Optional place object if already loaded

  const PlaceDetailsPage({
    Key? key,
    required this.placeId,
    this.place,
  }) : super(key: key);

  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  late Future<Place> _placeFuture;
  late final PlaceRepository _placeRepository;

  @override
  void initState() {
    super.initState();
    _placeRepository = sl<PlaceRepository>();
    _placeFuture = widget.place != null 
        ? Future.value(widget.place)
        : _placeRepository.getPlaceById(widget.placeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Place>(
        future: _placeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (snapshot.hasData) {
            return _buildPlaceDetails(snapshot.data!);
          } else {
            return _buildErrorState('Aucune information disponible');
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Chargement des détails...',
            style: TextStyle(
              color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur lors du chargement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Retour'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceDetails(Place place) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return CustomScrollView(
      slivers: [
        // App Bar with image
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              place.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                _buildPlaceImage(place),
                // Gradient overlay for better text visibility
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.7, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // Share functionality
              },
              tooltip: 'Partager',
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {
                // Bookmark functionality
              },
              tooltip: 'Sauvegarder',
            ),
          ],
        ),
        
        // Content
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating and category
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rating
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                place.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${place.reviewsCount} avis)',
                          style: TextStyle(
                            color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                          ),
                        ),
                      ],
                    ),
                    
                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        place.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      place.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              
              // Tags
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tags',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: place.tags.map((tag) => _buildTagChip(tag)).toList(),
                    ),
                  ],
                ),
              ),
              
              // Location
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Localisation',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(place.location.latitude, place.location.longitude),
                        zoom: 15.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 40.0,
                              height: 40.0,
                              point: LatLng(place.location.latitude, place.location.longitude),
                              builder: (ctx) => Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                  ],
                ),
              ),
              
              // Date information
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ajouté le: ${_formatDate(place.createdAt)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                      ),
                    ),
                    Text(
                      'Mis à jour: ${_formatDate(place.updatedAt)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to directions
                        },
                        icon: const Icon(Icons.directions),
                        label: const Text('Itinéraire'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Add review
                        },
                        icon: const Icon(Icons.rate_review),
                        label: const Text('Avis'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildPlaceImage(Place place) {
    // For now, use a placeholder image based on category
    IconData iconData;
    Color backgroundColor;
    
    switch (place.category) {
      case 'Restaurant':
        iconData = Icons.restaurant;
        backgroundColor = Colors.orange.shade200;
        break;
      case 'Café':
        iconData = Icons.coffee;
        backgroundColor = Colors.brown.shade200;
        break;
      case 'Bar':
        iconData = Icons.local_bar;
        backgroundColor = Colors.purple.shade200;
        break;
      default:
        iconData = Icons.place;
        backgroundColor = Colors.blue.shade200;
    }
    
    return Container(
      color: backgroundColor,
      child: Center(
        child: Icon(
          iconData,
          size: 80,
          color: Colors.white,
        ),
      ),
    );
  }
  
  Widget _buildTagChip(String tag) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark 
            ? AppTheme.darkAccentColor.withOpacity(0.2) 
            : AppTheme.accentColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '#$tag',
        style: TextStyle(
          color: isDark ? AppTheme.darkAccentColor : AppTheme.accentColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
} 