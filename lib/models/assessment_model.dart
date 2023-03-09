class Assessment {
  int? id;
  String? title;
  int? duration;
  int? items;
  String? startDate;
  String? endDate;
  String? status;

  Assessment({
    this.id,
    this.title,
    this.duration,
    this.items,
    this.startDate,
    this.endDate,
    this.status,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      items: json['items'],
      startDate: json['assessment_dates'][0]['start_date'],
      endDate: json['assessment_dates'][0]['end_date'],
      status: json['status'],
    );
  }
}
