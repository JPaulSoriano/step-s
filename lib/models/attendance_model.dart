class Attendance {
  int? id;
  String? date;
  String? description;
  String? edate;
  String? etime;

  Attendance({
    this.id,
    this.date,
    this.description,
    this.edate,
    this.etime,
  });

  // map json to comment model
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      date: json['attendance_date'],
      description: json['description'],
      edate: json['expiry_date'],
      etime: json['expiry_time'],
    );
  }
}
