import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jukebox_app/domains/model/User.dart';
import 'package:jukebox_app/support/utils/StringUtils.dart';

User userLogged;

class AuthService {
  Dio dio = Dio();

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
      String _endpoint = 'https://crudcrud.com/api/410f86fe392044ea9cb4e8fd55610fa1/all';
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


  // Future<String> updateUser(User user) async {
  //   try {
  //     String _endpoint = 'https://crudcrud.com/api/410f86fe392044ea9cb4e8fd55610fa1/all/${user.id}';
  //     var response = await dio.put(_endpoint, data: {'name': user.name, 'email': user.email, 'password': user.password, 'birthday': user.birthday}).timeout(Duration(seconds: 30));
  //     if(response.statusCode == 200 || response.statusCode == 201) {
  //       final user = User.fromMap(response.data);
  //       user.store();
  //       userLogged = user;
  //       return StringUtils.OK;
  //     } else {
  //       return StringUtils.ERROR_UPDATE_FAILED;
  //     }
  //   } on TimeoutException catch (_) {
  //     return StringUtils.ERROR_NOT_INTERNET;
  //   } catch(_) {
  //     return StringUtils.ERROR_UPDATE_FAILED;
  //   }
  // }

  Future<String> changePassword(String email, String newPassword) async {
    try {
      List<User> _users = await this.fetch();
      User _user = _users.firstWhere((element) => element.email.startsWith(email), orElse: () => null);
      if(_user != null) {
        String _endpoint = 'https://crudcrud.com/api/410f86fe392044ea9cb4e8fd55610fa1/all/${_user.id}';
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

  Future<List<User>> fetch() async {
    final _url = 'https://crudcrud.com/api/410f86fe392044ea9cb4e8fd55610fa1/all';
    var response = await dio.get(_url).timeout(Duration(seconds: 30));
    var res = response.data as List;
    return res.map<User>((map) => User.fromMap(map)).toList();
  }

  Future<void> signOut() async {
    User.clean();
    userLogged = null;
  }

}