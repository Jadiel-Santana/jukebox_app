import 'dart:async';

import 'package:dio/dio.dart';
import 'package:jukebox_app/domains/model/HashModel.dart';
import 'package:jukebox_app/domains/model/User.dart';
import 'package:jukebox_app/support/utils/StringUtils.dart';

User userLogged;
HashModel hashUsed;

class AuthService {
  Dio dio = Dio();
  //static const URL_BASE = 'https://crudcrud.com/api/88bace3519fc40c8b173f76ccb519b3c/users';
  final URL_BASE = 'https://crudcrud.com/api/${hashUsed.hash}/users';

  Future<List<User>> fetch() async {
    final _url = URL_BASE;
    var response = await dio.get(_url).timeout(Duration(seconds: 30));
    var res = response.data as List;
    return res.map<User>((map) => User.fromMap(map)).toList();
  }

  Future<String> signIn(String email, String password) async {
    try {
      List<User> _users = await this.fetch();
      var _user = _users.firstWhere((element) => element.email.startsWith(email) && element.password.startsWith(password), orElse: () => null);
      if(_user != null) {
        _user.store();
        userLogged = _user;
        return StringUtils.OK;
      } else {
        return StringUtils.ERROR_USER_NOT_EXISTS;
      }
    } on TimeoutException catch (_) {
      return StringUtils.ERROR_NOT_INTERNET;
    } catch(_) {
      return StringUtils.ERROR_SIGNIN_FAILED;
    }
  }

  Future<String> signUp(User user) async {
    try {
      String _endpoint = URL_BASE;
      var response = await dio.post(_endpoint, data: {'name': user.name, 'email': user.email, 'password': user.password, 'birthday': user.birthday}).timeout(Duration(seconds: 30));
      if(response.statusCode == 200 || response.statusCode == 201) {
        final user = User.fromMap(response.data);
        user.store();
        userLogged = user;
        return StringUtils.OK;
      } else {
        return StringUtils.ERROR_SIGNUP_FAILED;
      }
    } on TimeoutException catch (_) {
      return StringUtils.ERROR_NOT_INTERNET;
    } catch(_) {
      return StringUtils.ERROR_SIGNUP_FAILED;
    }
  }

  Future<String> update(User user) async {
    try {
      String _endpoint = '$URL_BASE/${user.id}';
      var response = await dio.put(_endpoint, data: {'name': user.name, 'email': user.email, 'password': user.password, 'birthday': user.birthday}).timeout(Duration(seconds: 30));
      if(response.statusCode == 200 || response.statusCode == 201) {
        return StringUtils.OK;
      } else {
        return StringUtils.ERROR_UPDATE_FAILED;
      }
    } on TimeoutException catch (_) {
      return StringUtils.ERROR_NOT_INTERNET;
    } catch(_) {
      return StringUtils.ERROR_UPDATE_FAILED;
    }
  }

  Future<String> delete(String id) async {
    try {
      String _endpoint = '$URL_BASE/$id';
      var response = await dio.delete(_endpoint).timeout(Duration(seconds: 30));
      if(response.statusCode == 200 || response.statusCode == 201) {
        return StringUtils.OK;
      } else {
        return StringUtils.ERROR_DELETE_FAILED;
      }
    } on TimeoutException catch (_) {
      return StringUtils.ERROR_NOT_INTERNET;
    } catch(_) {
      return StringUtils.ERROR_DELETE_FAILED;
    }
  }

  Future<String> changePassword(String email, String newPassword) async {
    try {
      List<User> _users = await this.fetch();
      User _user = _users.firstWhere((element) => element.email.startsWith(email), orElse: () => null);
      if(_user != null) {
        String _endpoint = '$URL_BASE/${_user.id}';
        var response = await dio.put(_endpoint, data: {'name': _user.name, 'email': _user.email, 'password': newPassword, 'birthday': _user.birthday}).timeout(Duration(seconds: 30));
        if(response.statusCode == 200 || response.statusCode == 201) {
          return StringUtils.OK;
        } else {
          return StringUtils.ERROR_UPDATE_FAILED;
        }
      } else {
        return StringUtils.ERROR_USER_NOT_EXISTS;
      }
    } on TimeoutException catch (_) {
      return StringUtils.ERROR_NOT_INTERNET;
    } catch(_) {
      return StringUtils.ERROR_UPDATE_FAILED;
    }
  }

  Future<bool> exists(String email, String password) async {
    try {
      List<User> _users = await this.fetch();
      int exist = _users.where((element) => element.email.startsWith(email) && element.password.startsWith(password)).toList().length;
      return (exist >= 1) ? true : false;
    } on TimeoutException catch (_) {
      return true;
    } catch(_) {
      return true;
    }
  }

  Future<void> signOut() async {
    User.clean();
    HashModel.clean();
    userLogged = null;
    hashUsed = await HashModel.get();
  }

}