import 'dart:convert';
import 'package:jukebox_app/support/utils/StringUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HashModel {
  String hash;

  HashModel({this.hash});

  HashModel.fromMap(Map<String, dynamic> map) {
    this.hash = map['hash'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['hash'] = this.hash;
    return map;
  }

  void store() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String hash = json.encode(toMap());
    prefs.setString(StringUtils.KEY_PREFS_HASH, hash);
  }

  static Future<HashModel> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String hash = prefs.getString(StringUtils.KEY_PREFS_HASH);
    if(hash == null || hash.isEmpty) { return HashModel(hash: StringUtils.HASH_DEFAULT); }
    Map hashMap = json.decode(hash);
    return HashModel.fromMap(hashMap);
  }

  static void clean() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(StringUtils.KEY_PREFS_HASH, '');
  }

  @override
  String toString() {
    return 'Hash{hash: $hash}';
  }
}