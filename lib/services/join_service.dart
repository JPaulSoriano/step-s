// Join a room
import 'dart:convert';
import 'package:step/constants.dart';
import 'package:step/models/response_model.dart';
import 'package:http/http.dart' as http;
import 'user_service.dart';

Future<ApiResponse> joinRoom(String roomKey) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(joinRoomURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'key': roomKey,
    });

    // check response status code
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['join'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['error'];
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
