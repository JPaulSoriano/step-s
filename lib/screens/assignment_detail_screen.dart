import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:step/constants.dart';
import 'package:step/models/assignment_model.dart';
import 'package:step/services/user_service.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final Assignment assignment;
  const AssignmentDetailScreen({Key? key, required this.assignment})
      : super(key: key);

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  File? _file;

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitAssignment() async {
    if (_file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please attach a file before submitting.'),
        ),
      );
      return;
    }
    String token = await getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${SubmitAssignmentURL}/${widget.assignment.id}/submit'),
    );

    request.fields['assignment_id'] = widget.assignment.id.toString();
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        _file!.path,
        filename: _file!.path.split('/').last,
      ),
    );
    request.headers.addAll(
        {'Accept': 'application/json', 'Authorization': 'Bearer $token'});

    final response = await request.send();

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          json.decode(await response.stream.bytesToString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonResponse['message']),
        ),
      );
    } else {
      Map<String, dynamic> jsonResponse =
          json.decode(await response.stream.bytesToString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonResponse['message']),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Text(widget.assignment.title?.isEmpty ?? true
            ? 'No Title'
            : widget.assignment.title!),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.assignment.title?.isEmpty ?? true
                    ? 'No Title'
                    : widget.assignment.title!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 8),
              Text(
                'Due ${DateFormat.yMMMMd().format(DateTime.parse(widget.assignment.due!))}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                '${widget.assignment.points.toString()} Points',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'Resubmission Count: ${widget.assignment.submission.toString()}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 12),
              Text(
                '${widget.assignment.instructions!}',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              SizedBox(height: 18),
              Divider(),
              SizedBox(height: 18),
              Text(
                'Attachments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              TextButton(
                onPressed: () {
                  _downloadFile(widget.assignment.url!);
                },
                child: Text(widget.assignment.file!),
              ),
              Divider(),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Work',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    widget.assignment.score != null
                        ? '${widget.assignment.score} / ${widget.assignment.points}'
                        : 'No score recorded yet',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.assignment.studentAssignments?.length,
                itemBuilder: (BuildContext context, int index) {
                  var studentAssignment =
                      widget.assignment.studentAssignments![index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        studentAssignment.file!,
                      ),
                      subtitle: Text(
                        '${DateFormat.yMMMMd().format(DateTime.parse(studentAssignment.created_at!))}',
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _selectFile,
                  child: Text(_file == null
                      ? '+ Add Attachment'
                      : '${_file!.path.split('/').last}'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitAssignment,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _downloadFile(String url) async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final response = await http.get(Uri.parse(url));
    final fileName = url.split('/').last;
    final fileExtension = fileName.split('.').last;
    final fileNameWithoutExtension =
        fileName.substring(0, fileName.length - fileExtension.length - 1);
    final downloadsDir = Directory('/storage/emulated/0/Download');
    await downloadsDir.create(recursive: true);
    var filePath = '${downloadsDir.path}/$fileName';
    var fileNumber = 1;
    while (await File(filePath).exists()) {
      // if file with same name already exists, rename it by adding a number to the filename
      filePath =
          '${downloadsDir.path}/$fileNameWithoutExtension($fileNumber).$fileExtension';
      fileNumber++;
    }
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File downloaded to ${file.path}'),
      ),
    );
  }
}
