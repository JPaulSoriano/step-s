import 'package:flutter/material.dart';
import 'package:step/constants.dart';
import 'package:step/models/response_model.dart';
import 'package:step/models/user_model.dart';
import 'package:step/screens/join_screen.dart';
import 'package:step/screens/login_screen.dart';
import 'package:step/screens/notification_screen.dart';
import 'package:step/screens/profile_screen.dart';
import 'package:step/screens/room_screen.dart';
import 'package:step/services/user_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  User? user;

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

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('STEP S'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JoinRoomForm(),
                  ));
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
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
                backgroundImage:
                    user?.avatar != null ? NetworkImage(user!.avatar!) : null,
                child: user?.avatar == null
                    ? Text(
                        '${user?.name?[0]}',
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
    );
  }
}
