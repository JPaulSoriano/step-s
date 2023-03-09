class Assignment {
  int? id;
  String? title;
  int? points;
  int? submission;
  String? due;
  String? instructions;
  String? url;
  String? file;

  Assignment({
    this.id,
    this.title,
    this.points,
    this.submission,
    this.due,
    this.instructions,
    this.url,
    this.file,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      title: json['title'],
      points: json['points'],
      submission: json['allowed_submission'],
      due: json['due_date'],
      instructions: json['instructions'],
      url: json['url'],
      file: json['file'],
    );
  }
}
