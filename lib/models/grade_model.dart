class Grade {
  String? roomName;
  final double? prelimGrade;
  final double? midtermGrade;
  final double? finalsGrade;
  final String schoolYear;
  final int semester;
  Grade({
    this.roomName,
    this.prelimGrade,
    this.midtermGrade,
    this.finalsGrade,
    required this.schoolYear,
    required this.semester,
  });
  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      roomName: json['room_name'],
      prelimGrade: (json['prelim_grade'] as num?)?.toDouble(),
      midtermGrade: (json['midterm_grade'] as num?)?.toDouble(),
      finalsGrade: (json['finals_grade'] as num?)?.toDouble(),
      schoolYear: json['school_year'],
      semester: int.parse(json['semester']),
    );
  }
}
