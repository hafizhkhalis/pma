class User {
  int? id;
  String? fullname;
  String username;
  String password;
  User(
      {this.id, this.fullname, required this.username, required this.password});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullname: map['fullname'],
      username: map['username'],
      password: map['password'],
    );
  }
}
