import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';

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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.transparent
              : AppTheme.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: _getNotificationColor(notification.type).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: _getNotificationColor(notification.type),
                size: 20,
              ),
            ),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                      color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(notification.time),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                    ),
                  ),
                ],
              ),
            ),
            
            // Mark as read
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Icons.favorite;
      case NotificationType.comment:
        return Icons.comment;
      case NotificationType.follow:
        return Icons.person_add;
      case NotificationType.newPlace:
        return Icons.place;
      case NotificationType.badge:
        return Icons.emoji_events;
      case NotificationType.system:
        return Icons.notifications;
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
    
    if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays != 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours != 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes != 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }
} 