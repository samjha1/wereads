import 'package:flutter/material.dart';
import 'notification_service.dart';
import 'package:intl/intl.dart';

class NotificationPages extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPages> {
  final NotificationService _notificationService = NotificationService();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() async {
    try {
      final notifications = await _notificationService.fetchNotifications();
      final filteredNotifications = _filterNotificationsFor5Days(notifications);

      setState(() {
        _notifications = filteredNotifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading notifications: $e')),
      );
    }
  }

  List<Map<String, dynamic>> _filterNotificationsFor5Days(List<Map<String, dynamic>> notifications) {
    final currentDate = DateTime.now();

    return notifications.where((notification) {
      final nextDate = DateTime.parse(notification['next_date']);
      return nextDate.isAfter(currentDate) && nextDate.isBefore(currentDate.add(Duration(days: 5)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blue, // Customize as per your theme
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? Center(child: Text('No notifications available'))
          : ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          final nextDate = notification['next_date'];

          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                notification['perticulars'] ?? 'No Title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Next Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(nextDate))}',
              ),
              trailing: Icon(
                Icons.notifications,
                color: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}