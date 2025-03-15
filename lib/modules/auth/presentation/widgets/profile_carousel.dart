import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/user_model.dart';
import 'profile_item.dart';

/// A widget that displays a horizontal carousel of profile items
class ProfileCarousel extends StatefulWidget {
  final List<User> users;
  final String title;
  final Function(User)? onUserSelected;

  const ProfileCarousel({
    Key? key,
    required this.users,
    this.title = "Personnes à suivre",
    this.onUserSelected,
  }) : super(key: key);

  @override
  State<ProfileCarousel> createState() => _ProfileCarouselState();
}

class _ProfileCarouselState extends State<ProfileCarousel> {
  int _hoveredProfileIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle see all action
                },
                child: Text('Voir tout'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 130,
          child: widget.users.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: widget.users.length,
                  itemBuilder: (context, index) {
                    final user = widget.users[index];
                    return MouseRegion(
                      onEnter: (_) => setState(() => _hoveredProfileIndex = index),
                      onExit: (_) => setState(() => _hoveredProfileIndex = -1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        transform: Matrix4.identity()
                          ..translate(0.0, _hoveredProfileIndex == index ? -8.0 : 0.0),
                        child: ProfileItem(
                          user: user,
                          isHovered: _hoveredProfileIndex == index,
                          onTap: widget.onUserSelected != null 
                              ? () => widget.onUserSelected!(user)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'Aucun utilisateur trouvé',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 14,
        ),
      ),
    );
  }
} 