import 'dart:convert';
import 'dart:io';
import 'package:step/constants.dart';
import 'package:step/models/assignment_model.dart';
import 'package:step/models/response_model.dart';
import 'package:step/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getAssignments(int roomId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$roomsURL/$roomId/assignments'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['assignments']
            .map((p) => Assignment.fromJson(p))
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
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e);
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> submitAssignment(File? file, int assignmentId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    if (file == null) {
      apiResponse.error = 'Please attach a file before submitting.';
      return apiResponse;
    }

    String token = await getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${SubmitAssignmentURL}/$assignmentId/submit'),
    );

    request.fields['assignment_id'] = assignmentId.toString();
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: file.path.split('/').last,
      ),
    );
    request.headers.addAll(
      {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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
