import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:step/services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Map<String, dynamic>? _notificationsData;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final data = await getNotifications();
    setState(() {
      _notificationsData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_notificationsData == null) {
      return Center(child: CircularProgressIndicator());
    }

    final notificationsCount = _notificationsData?['notifications_count'];
    final notifications = _notificationsData?['notifications'];

    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        title: new Text(
          'Notifications',
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (BuildContext context, int index) {
          final notification = notifications[index];
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey),
                    child: Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification['data']['type'],
                          style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          notification['data']['title'],
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          'Due: ${DateFormat.yMMMMd().format(DateTime.parse(
                            notification['data']['due_date'],
                          ))}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
