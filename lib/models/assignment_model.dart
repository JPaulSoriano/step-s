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
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    var students = json['students'] as List<dynamic>;
    var score = students.isNotEmpty ? students[0]['student']['score'] : 0;
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
    );
  }
}
