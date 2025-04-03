import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';
import '../../domain/models/place_model.dart';

class AddPlaceForm extends StatefulWidget {
  final double latitude;
  final double longitude;
  final Function(Place) onSubmit;

  const AddPlaceForm({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<AddPlaceForm> createState() => _AddPlaceFormState();
}

class _AddPlaceFormState extends State<AddPlaceForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _tagController = TextEditingController();
  List<String> _tags = [];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    if (_tagController.text.trim().isNotEmpty) {
      setState(() {
        _tags.add(_tagController.text.trim());
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final place = Place(
        id: now.millisecondsSinceEpoch.toString(), // ID temporaire
        name: _nameController.text,
        description: _descriptionController.text,
        category: _categoryController.text,
        location: Location(
          latitude: widget.latitude,
          longitude: widget.longitude,
        ),
        rating: 0.0, // Valeur par défaut
        reviewsCount: 0, // Valeur par défaut
        tags: _tags,
        createdAt: now,
        updatedAt: now,
      );
      widget.onSubmit(place);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Ajouter un nouveau lieu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(
                context,
                AppTheme.textPrimary,
                AppTheme.darkTextPrimary,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Nom du lieu
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nom du lieu',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un nom';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Description
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer une description';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Catégorie
          TextFormField(
            controller: _categoryController,
            decoration: InputDecoration(
              labelText: 'Catégorie',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer une catégorie';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Tags
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _tagController,
                  decoration: InputDecoration(
                    labelText: 'Ajouter un tag',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onFieldSubmitted: (_) => _addTag(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _addTag,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          if (_tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags.map((tag) => Chip(
                label: Text(tag),
                onDeleted: () => _removeTag(tag),
                deleteIcon: const Icon(Icons.close, size: 16),
              )).toList(),
            ),
          ],
          const SizedBox(height: 24),
          
          // Bouton de soumission
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Ajouter le lieu'),
          ),
        ],
      ),
    );
  }
} 