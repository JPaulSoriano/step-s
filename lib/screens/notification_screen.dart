import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:step/services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> notifications = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadNotifications();

    // Initialize the local notifications plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadNotifications() async {
    final data = await getNotifications();
    final List<dynamic> newNotifications = data['notifications'];

    // Check if there are any new notifications
    if (newNotifications.isNotEmpty &&
        newNotifications.length > notifications.length) {
      // Show a local notification for each new notification
      for (int i = notifications.length; i < newNotifications.length; i++) {
        final notification = newNotifications[i];
        await flutterLocalNotificationsPlugin.show(
            0,
            notification['data']['type'],
            notification['data']['title'],
            const NotificationDetails(
                android: AndroidNotificationDetails(
                    'channel_id', 'channel_name', 'channel_description')),
            payload: 'item x');
      }
    }

    // Update the notifications list
    setState(() {
      notifications = newNotifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (notifications == null) {
      return Center(child: CircularProgressIndicator());
    }

    return WillPopScope(
      onWillPop: () async {
        await read(); // call read() function here
        return true;
      },
      child: Scaffold(
        appBar: new AppBar(
          elevation: 0,
          title: new Text(
            'Notifications',
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return _loadNotifications();
          },
          child: ListView.builder(
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
        ),
      ),
    );
  }
}
