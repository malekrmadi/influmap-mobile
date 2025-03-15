import 'package:flutter/material.dart';
import '../../domain/models/user_model.dart';
import 'user_card.dart';

/// A widget that displays a grid of user cards
class UserGrid extends StatefulWidget {
  final List<User> users;
  final Function(User) onUserSelected;

  const UserGrid({
    Key? key,
    required this.users,
    required this.onUserSelected,
  }) : super(key: key);

  @override
  State<UserGrid> createState() => _UserGridState();
}

class _UserGridState extends State<UserGrid> {
  int _hoveredCardIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: widget.users.isEmpty
          ? _buildEmptyState()
          : GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: widget.users.length,
              itemBuilder: (context, index) {
                final user = widget.users[index];
                return MouseRegion(
                  onEnter: (_) => setState(() => _hoveredCardIndex = index),
                  onExit: (_) => setState(() => _hoveredCardIndex = -1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutQuint,
                    transform: Matrix4.identity()
                      ..translate(0.0, _hoveredCardIndex == index ? -5.0 : 0.0),
                    child: UserCard(
                      user: user,
                      isHovered: _hoveredCardIndex == index,
                      onViewDetails: () => widget.onUserSelected(user),
                    ),
                  ),
                );
              },
            ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun utilisateur trouvé',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
} 