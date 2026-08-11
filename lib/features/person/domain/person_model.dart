class Person {
  final int _id;
  final String name;
  final String birthday;
  final bool gender; //0 pour  homme et 1 pour femme
  final String face;

  Person(
    this._id, {
    required this.name,
    required this.birthday,
    required this.gender,
    required this.face,
  });
  int get id => _id;
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      json['id'],
      name: json['name'],
      birthday: json['birthday'],
      gender: json['gender'],
      face: json['face'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': name,
      'birthday': birthday,
      'gender': gender,
      'face': face,
    };
  }
}
