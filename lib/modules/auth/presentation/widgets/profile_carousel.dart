import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'profile_item.dart';

/// A widget that displays a horizontal carousel of profile items
class ProfileCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> profiles;
  final String title;

  const ProfileCarousel({
    Key? key,
    required this.profiles,
    this.title = "Personnes à suivre",
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
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: widget.profiles.length,
            itemBuilder: (context, index) {
              final profile = widget.profiles[index];
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
                    name: profile["name"],
                    tag: profile["tag"],
                    icon: profile["image"],
                    isHovered: _hoveredProfileIndex == index,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 