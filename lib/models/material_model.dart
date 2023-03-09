class Materials {
  int? id;
  String? title;
  String? description;
  String? url;

  Materials({
    this.id,
    this.title,
    this.description,
    this.url,
  });

  factory Materials.fromJson(Map<String, dynamic> json) {
    return Materials(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
    );
  }
}
