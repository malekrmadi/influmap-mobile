import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';
import '../widgets/notification_item_widget.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  List<NotificationModel> get _unreadNotifications => 
      _notifications.where((n) => !n.isRead).toList();

  List<NotificationModel> get _readNotifications => 
      _notifications.where((n) => n.isRead).toList();

  @override
  Widget build(BuildContext context) {
    int unreadCount = _unreadNotifications.length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(unreadCount),
          SliverToBoxAdapter(
            child: _buildTabBar(),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Toutes les notifications
                _notifications.isEmpty
                    ? _buildEmptyState()
                    : _buildNotificationsList(_notifications),
                
                // Notifications non lues
                _unreadNotifications.isEmpty
                    ? _buildEmptyUnreadState()
                    : _buildNotificationsList(_unreadNotifications),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(int unreadCount) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Notifications',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          children: [
            // Gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.7),
                    AppTheme.primaryColor,
                  ],
                ),
              ),
            ),
            // Content
            Positioned(
              left: 20,
              bottom: 60,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.notifications_active,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '$unreadCount notification${unreadCount != 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Text(
                          'Restez informé des activités',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (unreadCount > 0)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: _markAllAsRead,
                        icon: const Icon(Icons.done_all, color: Colors.white),
                        tooltip: 'Tout marquer comme lu',
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.getColor(
        context,
        Colors.white,
        Colors.grey.shade900,
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppTheme.primaryColor,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: AppTheme.getColor(
          context,
          AppTheme.textSecondary,
          AppTheme.darkTextSecondary,
        ),
        tabs: [
          const Tab(
            icon: Icon(Icons.notifications),
            text: 'Toutes',
          ),
          Tab(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_active),
                if (_unreadNotifications.isNotEmpty)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${_unreadNotifications.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            text: 'Non lues',
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
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 40,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucune notification',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Vous serez notifié des nouvelles activités importantes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyUnreadState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.done_all,
              size: 40,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Tout est à jour',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Vous avez lu toutes vos notifications',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationModel> notifications) {
    return ListView.builder(
      itemCount: notifications.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Card(
            elevation: 0,
            color: notification.isRead
                ? AppTheme.getColor(context, Colors.grey.shade50, Colors.grey.shade800)
                : AppTheme.getColor(context, Colors.white, Colors.grey.shade900),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: notification.isRead
                    ? Colors.transparent
                    : AppTheme.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: NotificationItemWidget(
              notification: notification,
              onTap: () => _markAsRead(notification.id),
            ),
          ),
        );
      },
    );
  }
} 