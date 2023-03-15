class Staff {
  int? id;
  String? name;

  Staff({
    this.id,
    this.name,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['employee_name'],
    );
  }
}

class Student {
  int? id;
  String? name;

  Student({
    this.id,
    this.name,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['student_name'],
    );
  }
}

class People {
  Staff? staff;
  Student? student;

  People({
    this.staff,
    this.student,
  });

  factory People.fromJson(Map<String, dynamic> json) {
    Staff? staff;
    Student? student;

    if (json['staff'] != null) {
      staff = Staff.fromJson(json['staff']);
    } else if (json['student'] != null) {
      student = Student.fromJson(json['student']);
    }

    return People(
      staff: staff,
      student: student,
    );
  }
}
