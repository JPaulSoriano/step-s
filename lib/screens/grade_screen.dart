import 'package:flutter/material.dart';
import 'package:step/constants.dart';
import 'package:step/models/grade_model.dart';
import 'package:step/models/response_model.dart';
import 'package:step/screens/login_screen.dart';
import 'package:step/services/grade_service.dart';
import 'package:step/services/user_service.dart';

class GradeScreen extends StatefulWidget {
  @override
  _GradeScreenState createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  List<dynamic> _gradeList = [];
  bool _loading = true;

  Future<void> retrieveGrades() async {
    ApiResponse response = await getGrades();
    if (response.error == null) {
      setState(() {
        _gradeList = response.data as List<dynamic>;
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
    retrieveGrades();
    super.initState();
  }

  // Group grades by school year and semester
  Map<String, List<Grade>> _groupGrades(List<Grade> grades) {
    Map<String, List<Grade>> groupedGrades = {};
    for (var grade in grades) {
      String key = 'SY ${grade.schoolYear} SEM ${grade.semester}';
      if (groupedGrades.containsKey(key)) {
        groupedGrades[key]!.add(grade);
      } else {
        groupedGrades[key] = [grade];
      }
    }
    return groupedGrades;
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () {
              return retrieveGrades();
            },
            child: ListView(
              children: _buildGradeSections(),
            ),
          );
  }

  List<Widget> _buildGradeSections() {
    List<Widget> gradeSections = [];

    // Group grades by school year and semester
    Map<String, List<Grade>> groupedGrades =
        _groupGrades(_gradeList.cast<Grade>());

    // Sort keys (school year and semester)
    var sortedKeys = groupedGrades.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Newest first (descending)

    for (var key in sortedKeys) {
      gradeSections.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(
            key, // Example: SY 2024-2025 SEM 1
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ));

      gradeSections.add(
        _buildGradeTable(groupedGrades[key]!),
      );
    }

    return gradeSections;
  }

  Widget _buildGradeTable(List<Grade> grades) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(2), // Subject column
          1: FlexColumnWidth(1), // Prelim column
          2: FlexColumnWidth(1), // Midterm column
          3: FlexColumnWidth(1), // Finals column
        },
        border: TableBorder.all(color: Colors.grey),
        children: [
          // Table Header
          TableRow(
            decoration: BoxDecoration(color: Colors.grey[300]),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Subject',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Prelim',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Midterm',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Finals',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          // Table Rows
          for (var grade in grades)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(grade.roomName ?? 'N/A'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    grade.prelimGrade != null
                        ? grade.prelimGrade.toString()
                        : '--',
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    grade.midtermGrade != null
                        ? grade.midtermGrade.toString()
                        : '--',
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    grade.finalsGrade != null
                        ? grade.finalsGrade.toString()
                        : '--',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
