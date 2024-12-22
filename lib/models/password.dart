class Password {
  int? id;
  String title;
  String? fullname;
  String username;
  String password;

  Password({
    this.id,
    required this.title,
    this.fullname,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'fullname': fullname,
      'username': username,
      'password': password,
    };
  }

  factory Password.fromMap(Map<String, dynamic> map) {
    return Password(
      id: map['id'],
      title: map['title'],
      fullname: map['fullname'] as String?,
      username: map['username'],
      password: map['password'],
    );
  }
}
