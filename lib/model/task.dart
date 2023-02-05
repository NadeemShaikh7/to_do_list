class Task {
  String? id;
  String? title;
  String? description;
  String? date;
  bool? done;
  String? type;

  Task(
      {this.id,
      required this.title,
      required this.description,
      required this.date,
      required this.done,
      required this.type});

  static fromJson(Map<String, dynamic> json) => Task(
      id: json['id'],
      description: json['description'],
      title: json['title'],
      done: json['done'],
      date: json['date'],
      type: json['type']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['date'] = date;
    data['done'] = done;
    data['type'] = type;
    return data;
  }
}
