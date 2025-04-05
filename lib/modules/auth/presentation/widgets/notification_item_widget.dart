import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

enum NotificationType {
  like,
  comment,
  follow,
  newPlace,
  badge,
  system,
}

class NotificationModel {
  final String id;
  final NotificationType type;
  final String message;
  final DateTime time;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.message,
    required this.time,
    required this.isRead,
  });

  NotificationModel copyWith({
    String? id,
    NotificationType? type,
    String? message,
    DateTime? time,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      message: message ?? this.message,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationItemWidget({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extraire le nom d'utilisateur du message (première partie avant "a")
    final messageParts = notification.message.split(' a ');
    final username = messageParts.isNotEmpty ? messageParts[0] : '';
    final remainingMessage = messageParts.length > 1 ? 'a ${messageParts.sublist(1).join(' a ')}' : notification.message;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar/Icon avec effet d'animation
            _buildNotificationAvatar(),
            
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête avec type de notification
                  _buildNotificationHeader(context),
                  
                  const SizedBox(height: 8),
                  
                  // Message principal
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' $remainingMessage',
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Footer avec temps et indicateur lu/non lu
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(notification.time),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                        ),
                      ),
                      const Spacer(),
                      if (!notification.isRead)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getNotificationColor(notification.type).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Nouveau',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getNotificationColor(notification.type),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getNotificationColor(notification.type).withOpacity(0.7),
                _getNotificationColor(notification.type),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _getNotificationColor(notification.type).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: Colors.white,
            size: 24,
          ),
        ),
        // Badge indicating notification type
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: _getNotificationColor(notification.type),
                width: 1.5,
              ),
            ),
            child: Icon(
              _getSecondaryIcon(notification.type),
              color: _getNotificationColor(notification.type),
              size: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _getNotificationColor(notification.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _getNotificationTypeName(notification.type),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: _getNotificationColor(notification.type),
            ),
          ),
        ),
        const Spacer(),
        if (!notification.isRead)
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getNotificationColor(notification.type),
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  String _getNotificationTypeName(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return 'J\'aime';
      case NotificationType.comment:
        return 'Commentaire';
      case NotificationType.follow:
        return 'Abonnement';
      case NotificationType.newPlace:
        return 'Nouveau lieu';
      case NotificationType.badge:
        return 'Badge';
      case NotificationType.system:
        return 'Système';
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Icons.favorite;
      case NotificationType.comment:
        return Icons.chat_bubble;
      case NotificationType.follow:
        return Icons.person;
      case NotificationType.newPlace:
        return Icons.place;
      case NotificationType.badge:
        return Icons.emoji_events;
      case NotificationType.system:
        return Icons.notifications;
    }
  }

  IconData _getSecondaryIcon(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Icons.thumb_up;
      case NotificationType.comment:
        return Icons.comment;
      case NotificationType.follow:
        return Icons.person_add;
      case NotificationType.newPlace:
        return Icons.restaurant;
      case NotificationType.badge:
        return Icons.star;
      case NotificationType.system:
        return Icons.info;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Colors.redAccent;
      case NotificationType.comment:
        return Colors.blueAccent;
      case NotificationType.follow:
        return Colors.green;
      case NotificationType.newPlace:
        return Colors.orangeAccent;
      case NotificationType.badge:
        return Colors.purple;
      case NotificationType.system:
        return AppTheme.primaryColor;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 7) {
      // Format as date for older notifications
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } else if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays != 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes}min';
    } else {
      return 'À l\'instant';
    }
  }
} 