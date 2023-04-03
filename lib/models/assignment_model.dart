class Assignment {
  int? id;
  String? title;
  int? points;
  int? submission;
  String? due;
  String? instructions;
  String? url;
  String? file;
  int? score;
  List<StudentAssignment>? studentAssignments;

  Assignment({
    this.id,
    this.title,
    this.points,
    this.submission,
    this.due,
    this.instructions,
    this.url,
    this.file,
    this.score,
    this.studentAssignments,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    var students = json['students'] as List<dynamic>;
    var score = students.isNotEmpty ? students[0]['student']['score'] : 0;
    List<StudentAssignment>? studentAssignments =
        (json['student_assignments'] as List<dynamic>)
            .map((e) => StudentAssignment.fromJson(e))
            .toList();
    return Assignment(
      id: json['id'],
      title: json['title'],
      points: json['points'],
      submission: json['allowed_submission'],
      due: json['due_date'],
      instructions: json['instructions'],
      url: json['url'],
      file: json['file'],
      score: score,
      studentAssignments: studentAssignments,
    );
  }
}

class StudentAssignment {
  String? file;
  String? created_at;
  StudentAssignment({
    this.file,
    this.created_at,
  });
  factory StudentAssignment.fromJson(Map<String, dynamic> json) {
    return StudentAssignment(
      file: json['file'],
      created_at: json['created_at'],
    );
  }
}
