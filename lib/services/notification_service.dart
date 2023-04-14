import 'package:http/http.dart' as http;
import 'package:step/constants.dart';
import 'dart:convert';
import 'package:step/services/user_service.dart';

Future<Map<String, dynamic>> getNotifications() async {
  String token = await getToken();
  final response = await http.get(Uri.parse(NotificationURL), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });
  final Map<String, dynamic> body = jsonDecode(response.body);
  return body;
}

Future<void> read() async {
  String token = await getToken();
  final response = await http.get(Uri.parse(ReadURL), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });
  if (response.statusCode == 200) {
    print('Notifications marked as read');
  } else {
    print('Failed to mark notifications as read');
  }
}
