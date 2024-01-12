class User {
  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.photo,
  });
  late final int id;
  late String name;
  late final String phone;
  late String photo;

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['phone'] = phone;
    _data['photo'] = photo;
    return _data;
  }
}