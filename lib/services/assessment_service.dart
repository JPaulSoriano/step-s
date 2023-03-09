// Get room assessments
import 'dart:convert';
import 'package:step/constants.dart';
import 'package:step/models/assessment_model.dart';
import 'package:step/models/response_model.dart';
import 'package:step/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getAssessments(int roomId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$roomsURL/$roomId/assessments'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['assessments']
            .map((p) => Assessment.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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
