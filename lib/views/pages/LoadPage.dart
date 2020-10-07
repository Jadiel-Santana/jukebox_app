import 'package:flutter/material.dart';
import 'package:jukebox_app/domains/model/HashModel.dart';
import 'package:jukebox_app/domains/model/User.dart';
import 'package:jukebox_app/domains/service/AuthService.dart';
import 'package:jukebox_app/support/components/CircularProgress.dart';
import 'package:jukebox_app/support/utils/AppColors.dart';
import 'package:jukebox_app/support/utils/Navigation.dart';
import 'package:jukebox_app/views/pages/SignIn.dart';
import 'package:jukebox_app/views/pages/UserList.dart';

class LoadPage extends StatefulWidget { @override _LoadPageState createState() => _LoadPageState(); }

class _LoadPageState extends State<LoadPage> {

  @override
  void initState() {
    super.initState();
    Future<User> _user = User.get();
    Future<HashModel> _hash = HashModel.get();
    Future.wait([_user, _hash]).then((List futures) {
      User user = futures[0];
      hashUsed = futures[1];
      if(user != null) {
        userLogged = user;
        next(context, UserList(), replacement: true);
      } else {
        next(context, SignIn(), replacement: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.greyBackground,
      child: CircularProgress()
    );
  }
}