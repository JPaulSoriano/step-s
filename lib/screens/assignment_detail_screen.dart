import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:step/constants.dart';
import 'package:step/models/assignment_model.dart';
import 'package:step/models/response_model.dart';
import 'package:step/screens/login_screen.dart';
import 'package:step/services/assignment_service.dart';
import 'package:step/services/user_service.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final Assignment assignment;
  const AssignmentDetailScreen({Key? key, required this.assignment})
      : super(key: key);

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  File? file;

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });
    }
  }

  void _submitAssignment() async {
    ApiResponse response =
        await submitAssignment(file, widget.assignment.id ?? 0);
    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.data}'),
        ),
      );
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${response.error} The file must be a file of type: doc, docx, pdf, ppt, pptx, xls, xlsx.')),
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
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                '${widget.assignment.points.toString()} Points',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                'Resubmission Count: ${widget.assignment.submission.toString()}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 12),
              Text(
                '${widget.assignment.instructions!.replaceAll(RegExp('<p>|</p>|<br />'), '')}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 18),
              Divider(),
              SizedBox(height: 18),
              Text(
                'Instructor Attachments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              TextButton(
                onPressed: () {
                  if (widget.assignment.url != null) {
                    downloadFile(widget.assignment.url!);
                  }
                },
                child: Text(widget.assignment.file ?? 'No Attachments'),
              ),
              Divider(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _selectFile,
                  child: Text(file == null
                      ? '+ Your Attachment'
                      : '${file!.path.split('/').last}'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitAssignment,
                  child: Text('Submit'),
                ),
              ),
              SizedBox(height: 18),
              Divider(),
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
                    elevation: 0,
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
              SizedBox(height: 18),
              Divider(),
              SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> downloadFile(String url) async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    try {
      var request = await http.get(Uri.parse(url));
      var bytes = request.bodyBytes;
      String fileName = url.split('/').last;
      String dir = '/storage/emulated/0/Download';
      File file = File('$dir/$fileName');
      await file.writeAsBytes(bytes);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${fileName} Downloaded Successfully'),
      ));
    } catch (e) {
      print(e);
    }
  }
}
