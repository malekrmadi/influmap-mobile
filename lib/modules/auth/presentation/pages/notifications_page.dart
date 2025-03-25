import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      type: NotificationType.like,
      message: 'Jean Dupont a aimé votre post sur Le Café des Artistes',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      type: NotificationType.comment,
      message: 'Marie Martin a commenté sur votre post: "J\'adore cet endroit !"',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      type: NotificationType.follow,
      message: 'Pierre Durand a commencé à vous suivre',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      type: NotificationType.newPlace,
      message: 'Un nouveau restaurant a ouvert près de chez vous: La Table Ronde',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      type: NotificationType.badge,
      message: 'Félicitations! Vous avez obtenu le badge "Aventurier"',
      time: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    NotificationItem(
      id: '6',
      type: NotificationType.system,
      message: 'Bienvenue sur InfluMap! Découvrez les lieux tendances près de chez vous',
      time: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
    ),
  ];

  void _markAsRead(String id) {
    setState(() {
      for (var i = 0; i < _notifications.length; i++) {
        if (_notifications[i].id == id) {
          _notifications[i] = _notifications[i].copyWith(isRead: true);
          break;
        }
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var i = 0; i < _notifications.length; i++) {
        if (!_notifications[i].isRead) {
          _notifications[i] = _notifications[i].copyWith(isRead: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(unreadCount),
          Expanded(
            child: _notifications.isEmpty
                ? _buildEmptyState()
                : _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int unreadCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.getColor(
          context,
          Colors.grey.shade100,
          Colors.grey.shade900,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vous avez $unreadCount notification${unreadCount != 1 ? 's' : ''} non lue${unreadCount != 1 ? 's' : ''}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
                ),
              ),
              Text(
                'Restez informé des dernières activités',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                ),
              ),
            ],
          ),
          if (unreadCount > 0)
            TextButton.icon(
              onPressed: _markAllAsRead,
              icon: const Icon(Icons.done_all, size: 16),
              label: const Text('Tout marquer comme lu'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune notification',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vous serez notifié des nouvelles activités',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.separated(
      itemCount: _notifications.length,
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return InkWell(
      onTap: () => _markAsRead(notification.id),
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

enum NotificationType {
  like,
  comment,
  follow,
  newPlace,
  badge,
  system,
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String message;
  final DateTime time;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.message,
    required this.time,
    required this.isRead,
  });

  NotificationItem copyWith({
    String? id,
    NotificationType? type,
    String? message,
    DateTime? time,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      type: type ?? this.type,
      message: message ?? this.message,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
    );
  }
} 