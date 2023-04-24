import 'dart:math';
import 'package:flutter/material.dart';
import 'package:step/constants.dart';
import 'package:step/models/response_model.dart';
import 'package:step/models/room_model.dart';
import 'package:step/screens/login_screen.dart';
import 'package:step/screens/room_detail_screen.dart';
import 'package:step/services/room_service.dart';
import 'package:step/services/user_service.dart';

class RoomScreen extends StatefulWidget {
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final List<String> roomImages = [
    'images/b1.jpg',
    'images/b2.jpg',
    'images/b3.jpg',
    'images/b4.jpg',
    'images/b5.jpg',
    'images/b6.jpg',
    'images/b7.jpg',
    'images/b8.jpg',
    'images/b9.jpg',
    'images/b10.jpg',
  ];
  Random random = new Random();

  List<dynamic> _roomList = [];
  int userId = 0;
  bool _loading = true;

  // get all rooms
  Future<void> retrieveRooms() async {
    userId = await getUserId();
    ApiResponse response = await getRooms();
    if (response.error == null) {
      setState(() {
        _roomList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    retrieveRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () {
              return retrieveRooms();
            },
            child: ListView.builder(
              itemCount: _roomList.length,
              itemBuilder: (BuildContext context, int index) {
                Room room = _roomList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RoomDetailScreen(
                              room: room,
                            )));
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 140,
                        margin: EdgeInsets.all(15),
                        child: Image(
                          image: AssetImage(
                              roomImages[random.nextInt(roomImages.length)]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30, left: 30),
                        width: 220,
                        child: Text(
                          '${room.name}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 58, left: 30),
                        child: Text(
                          '${room.section}',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              letterSpacing: 1),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 80, left: 30),
                        child: Text(
                          '${room.user!.name}',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                              letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
