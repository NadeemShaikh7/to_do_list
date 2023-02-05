class User {
  String? userName;
  String? email;
  String? userID;
  String? imageUrl;

  User({this.userName, this.email, this.userID, this.imageUrl});

  static fromJson(Map<String, dynamic> json) => User(
      userName: json['userName'],
      email: json['email'],
      userID: json['userID'],
      imageUrl: json['imageUrl']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['email'] = email;
    data['userID'] = userID;
    data['imageUrl'] = imageUrl;
    return data;
  }
}
