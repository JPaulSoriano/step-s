import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:step/constants.dart';
import 'package:step/models/response_model.dart';
import 'package:step/models/user_model.dart';
import 'package:step/screens/join_screen.dart';
import 'package:step/screens/login_screen.dart';
import 'package:step/screens/notification_screen.dart';
import 'package:step/screens/profile_screen.dart';
import 'package:step/screens/room_screen.dart';
import 'package:step/services/notification_service.dart';
import 'package:step/services/user_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  User? user;
  int notificationsCount = 0;

  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  Future<void> _loadNotificationsCount() async {
    final data = await getNotifications();
    setState(() {
      notificationsCount = data['notifications_count'];
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    _loadNotificationsCount();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('STEP S'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsScreen()),
                  );
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$notificationsCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('${user?.name}'),
              accountEmail: Text('${user?.email}'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: user?.avatar != null
                    ? CachedNetworkImageProvider(user!.avatar!)
                    : null,
                child: user?.avatar == null
                    ? Text(
                        '${user?.name?[1]}',
                        style: TextStyle(fontSize: 40.0),
                      )
                    : null,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Rooms'),
              onTap: () {
                setState(() {
                  currentIndex = 0;
                  _loadNotificationsCount();
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                setState(() {
                  currentIndex = 1;
                  _loadNotificationsCount();
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => Login()),
                          (route) => false)
                    });
              },
            ),
          ],
        ),
      ),
      body: currentIndex == 0 ? RoomScreen() : Profile(user: user),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => JoinRoomForm()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
