import 'dart:convert';
import 'package:jukebox_app/support/utils/StringUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String id;
  String name;
  String email;
  String password;
  String birthday;

  User({this.id, this.name, this.email, this.password, this.birthday});

  User.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.name = map['name'];
    this.email = map['email'];
    this.password = map['password'];
    this.birthday = map['birthday'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['_id'] = this.id;
    map['name'] = this.name;
    map['email'] = this.email;
    map['password'] = this.password;
    map['birthday'] = this.birthday;
    return map;
  }

  void store() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = json.encode(toMap());
    prefs.setString(StringUtils.KEY_PREFS_USERS, user);
  }

  static Future<User> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString(StringUtils.KEY_PREFS_USERS);
    if(user == null || user.isEmpty) { return null; }
    Map userMap = json.decode(user);
    return User.fromMap(userMap);
  }

  static void clean() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(StringUtils.KEY_PREFS_USERS, '');
  }

  @override
  String toString() {
    return 'Users{_id: $id, name: $name, email: $email, password: $password, birthday: $birthday}';
  }
}