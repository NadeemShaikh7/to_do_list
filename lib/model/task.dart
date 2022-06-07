class Task {
  String? id;
  String? title;
  String? description;
  String? date;

  Task(
      {this.id,
      required this.title,
      required this.description,
      required this.date});
  //
  // Task.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   title = json['title'];
  //   description = json['description'];
  //   d

  static fromJson(Map<String, dynamic> json) => Task(
      id: json['id'],
      description: json['description'],
      title: json['title'],
      date: json['date']);

  // static fromJson(Map<String, dynamic> data) {}ate = json['date'];
  // }

  // static fromJson(Map<String, dynamic> json) =>

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['date'] = date;
    return data;
  }
}
