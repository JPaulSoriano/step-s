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
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RoomDetailScreen(
                                  room: room,
                                )));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${room.user!.name}'),
                            Text('${room.name}'),
                            Text('${room.section}'),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}
