import 'user_model.dart';

class Room {
  int? id;
  String? name;
  String? section;
  String? key;
  User? user;

  Room({
    this.id,
    this.name,
    this.section,
    this.key,
    this.user,
  });

// map json to post model

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      section: json['section'],
      key: json['key'],
      user: User(
        id: json['teacher']['id'],
        name: json['teacher']['full_name'],
      ),
    );
  }
}
