import 'dart:async';

import 'package:jukebox_app/domains/model/User.dart';
import 'package:jukebox_app/domains/service/AuthService.dart';
import 'package:jukebox_app/support/utils/Network.dart';
import 'package:jukebox_app/support/utils/StringUtils.dart';

class AuthBloc {
  final _ctrlLoading = StreamController<bool>();
  Stream<bool> get stream => _ctrlLoading.stream;

  Future<String> signIn(String email, String password) async {
    if(await isNetworkOn()) {
      _ctrlLoading.add(true);
      String ret = await AuthService().signIn(email, password);
      _ctrlLoading.add(false);
      return ret;
    } else {
      return StringUtils.ERROR_NOT_INTERNET;
    }
  }

  Future<String> signUp(User user) async {
    String ret = '';
    if(await isNetworkOn()) {
      _ctrlLoading.add(true);
      if(!await AuthService().exists(user.email, user.password)) {
        ret = await AuthService().signUp(user);
      } else {
        ret = StringUtils.ERROR_USER_EXISTS;
      }
      _ctrlLoading.add(false);
      return ret;
    } else {
      return StringUtils.ERROR_NOT_INTERNET;
    }
  }

  Future<String> changePassword(String email, String newPassword) async {
    if(await isNetworkOn()) {
      _ctrlLoading.add(true);
      String ret = await AuthService().changePassword(email, newPassword);
      _ctrlLoading.add(false);
      return ret;
    } else {
      return StringUtils.ERROR_NOT_INTERNET;
    }
  }

  Future<void> signOut() async => await AuthService().signOut();

  void dispose() => _ctrlLoading.close();
}