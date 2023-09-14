import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:step/services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> notifications = [];
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  @override
  void initState() {
    super.initState();
    checkPermission();
    _loadNotifications();
  }

  void checkPermission() async {
    PermissionStatus permission =
        await NotificationPermissions.getNotificationPermissionStatus();
    setState(() {
      _permissionStatus = permission;
    });
  }

  Future<void> _loadNotifications() async {
    final data = await getNotifications();
    setState(() {
      notifications = data['notifications'];
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
          child: Column(
            children: [
              Center(
                child: _permissionStatus == PermissionStatus.denied
                    ? Column(
                        children: <Widget>[
                          SizedBox(height: 16),
                          Text('Background and Foreground Notification'),
                          Text('Permission is Denied or Disabled'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            child: Text('Allow Permission'),
                            onPressed: () {
                              // Call the requestPermission method when the button is pressed
                              requestPermission();
                            },
                          ),
                        ],
                      )
                    : null,
              ),
              Expanded(
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
                                    notification['data']['title']?.replaceAll(
                                        RegExp('<p>|</p>|<br>'), ''),
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
            ],
          ),
        ),
      ),
    );
  }

  // Define a method to request permission
  void requestPermission() async {
    PermissionStatus permission =
        await NotificationPermissions.requestNotificationPermissions();
    setState(() {
      _permissionStatus = permission;
    });
  }
}
