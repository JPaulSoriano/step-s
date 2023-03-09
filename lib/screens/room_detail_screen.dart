import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:step/constants.dart';
import 'package:step/models/announcement_model.dart';
import 'package:step/models/assessment_model.dart';
import 'package:step/models/assignment_model.dart';
import 'package:step/models/material_model.dart';
import 'package:step/models/response_model.dart';
import 'package:step/models/room_model.dart';
import 'package:step/screens/assignmen_detail_screen.dart';
import 'package:step/screens/comment_screen.dart';
import 'package:step/screens/login_screen.dart';
import 'package:step/services/announcement_service.dart';
import 'package:step/services/assessment_service.dart';
import 'package:step/services/assignment_service.dart';
import 'package:step/services/material_service.dart';
import 'package:step/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class RoomDetailScreen extends StatefulWidget {
  final Room room;

  RoomDetailScreen({required this.room});

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  List<dynamic> _announcementsList = [];
  List<dynamic> _assessmentsList = [];
  List<dynamic> _materialsList = [];
  List<dynamic> _assignmentsList = [];
  bool _loading = true;
  int userId = 0;
  int _currentIndex = 0;

  // Get Announcements
  Future<void> _getAnnouncements() async {
    userId = await getUserId();
    ApiResponse response = await getAnnouncements(widget.room.id ?? 0);

    if (response.error == null) {
      setState(() {
        _announcementsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
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

  // Get Assessments
  Future<void> _getAssessments() async {
    userId = await getUserId();
    ApiResponse response = await getAssessments(widget.room.id ?? 0);

    if (response.error == null) {
      setState(() {
        _assessmentsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
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

  // Get Materials
  Future<void> _getMaterials() async {
    userId = await getUserId();
    ApiResponse response = await getMaterials(widget.room.id ?? 0);

    if (response.error == null) {
      setState(() {
        _materialsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
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

  // Get Assignments
  Future<void> _getAssignments() async {
    userId = await getUserId();
    ApiResponse response = await getAssignments(widget.room.id ?? 0);

    if (response.error == null) {
      setState(() {
        _assignmentsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
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
    _getAnnouncements();
    _getAssessments();
    _getMaterials();
    _getAssignments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.room.name!,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {},
          ),
        ],
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListTile(
                title: Text(widget.room.section!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.room.section ?? ''),
                    Text(widget.room.user!.name ?? ''),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Assessments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: 'Materials',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildAnnouncements();
      case 1:
        return _buildAssessments();
      case 2:
        return _buildMaterials();
      case 3:
        return _buildAssignments();
      default:
        return Container();
    }
  }

  Widget _buildAnnouncements() {
    return RefreshIndicator(
      onRefresh: () {
        return _getAnnouncements();
      },
      child: ListView.builder(
          itemCount: _announcementsList.length,
          itemBuilder: (BuildContext context, int index) {
            Announcement announcement = _announcementsList[index];
            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentScreen(
                            announcementID: announcement.id,
                          )));
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    image: announcement.user!.avatar != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                '${announcement.user!.avatar}'),
                                            fit: BoxFit.cover)
                                        : null,
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.blueGrey),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${announcement.user!.name}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '${DateFormat.yMMMMd().format(DateTime.parse(announcement.created!))}',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('${announcement.title ?? 'No Title'}'),
                      Text('${announcement.body}')
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildAssessments() {
    return RefreshIndicator(
      onRefresh: () {
        return _getAssessments();
      },
      child: ListView.builder(
          itemCount: _assessmentsList.length,
          itemBuilder: (BuildContext context, int index) {
            Assessment assessment = _assessmentsList[index];
            return Card(
              child: Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${assessment.title ?? 'No Title'}'),
                    Text(
                      'Duration: ${assessment.duration.toString()}',
                    ),
                    Text(
                      'Items: ${assessment.items.toString()}',
                    ),
                    Text(
                      'Start Date: ${assessment.startDate}',
                    ),
                    Text(
                      'End Date: ${assessment.endDate}',
                    ),
                    Text(
                      'Status: ${assessment.status}',
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildMaterials() {
    return RefreshIndicator(
      onRefresh: () {
        return _getMaterials();
      },
      child: ListView.builder(
          itemCount: _materialsList.length,
          itemBuilder: (BuildContext context, int index) {
            Materials material = _materialsList[index];
            return Card(
              child: InkWell(
                onTap: () {
                  _downloadFile(material.url!);
                },
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(material.title!),
                      Text(material.description!),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildAssignments() {
    return RefreshIndicator(
      onRefresh: () {
        return _getAssignments();
      },
      child: ListView.builder(
          itemCount: _assignmentsList.length,
          itemBuilder: (BuildContext context, int index) {
            Assignment assignment = _assignmentsList[index];
            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AssignmentDetailScreen(assignment: assignment),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(assignment.title!),
                      Text(
                          'Due Date: ${DateFormat.yMMMMd().format(DateTime.parse(assignment.due!))}'),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future<void> _downloadFile(String url) async {
    // Check if permission is granted
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      // Request permission
      await Permission.storage.request();
    }

    // Download file
    final response = await http.get(Uri.parse(url));
    final fileName = url.split('/').last;
    final downloadsDir = Directory('/storage/emulated/0/Download');
    await downloadsDir.create(recursive: true);
    final filePath = '${downloadsDir.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File downloaded to ${file.path}'),
      ),
    );
  }
}
