import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:step/constants.dart';
import 'package:step/models/response_model.dart';
import 'package:step/models/room_model.dart';
import 'package:step/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getRooms() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(roomsURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        List<dynamic> rooms = jsonDecode(response.body)['rooms'];

        // Loop through each room and subscribe to its key topic
        rooms.forEach((room) {
          String key = room['key'];
          FirebaseMessaging.instance.subscribeToTopic(key);
        });

        // Map each room to a Room object and return the list
        apiResponse.data = rooms.map((p) => Room.fromJson(p)).toList();
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
