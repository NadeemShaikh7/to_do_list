class UserPoJo {
  String? userName;
  String? email;
  String? userID;
  String? imageUrl;

  UserPoJo({this.userName, this.email, this.userID, this.imageUrl});

  static fromJson(Map<String, dynamic> json) => UserPoJo(
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
