import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';
import '../widgets/notification_item_widget.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      type: NotificationType.like,
      message: 'Jean Dupont a aimé votre post sur Le Café des Artistes',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      type: NotificationType.comment,
      message: 'Marie Martin a commenté sur votre post: "J\'adore cet endroit !"',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationModel(
      id: '3',
      type: NotificationType.follow,
      message: 'Pierre Durand a commencé à vous suivre',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    NotificationModel(
      id: '4',
      type: NotificationType.newPlace,
      message: 'Un nouveau restaurant a ouvert près de chez vous: La Table Ronde',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: '5',
      type: NotificationType.badge,
      message: 'Félicitations! Vous avez obtenu le badge "Aventurier"',
      time: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    NotificationModel(
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
        return NotificationItemWidget(
          notification: notification,
          onTap: () => _markAsRead(notification.id),
        );
      },
    );
  }
} 