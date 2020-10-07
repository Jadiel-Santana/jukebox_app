import 'package:flutter/material.dart';
import 'package:jukebox_app/domains/model/User.dart';
import 'package:jukebox_app/domains/service/AuthService.dart';
import 'package:jukebox_app/support/components/CircularProgress.dart';
import 'package:jukebox_app/support/utils/AppColors.dart';
import 'package:jukebox_app/support/utils/Navigation.dart';
import 'package:jukebox_app/views/pages/HomePage.dart';
import 'package:jukebox_app/views/pages/SignIn.dart';

class LoadPage extends StatefulWidget { @override _LoadPageState createState() => _LoadPageState(); }

class _LoadPageState extends State<LoadPage> {

  @override
  void initState() {
    super.initState();
    Future _delay = Future.delayed(Duration(milliseconds: 300));
    Future<User> _user = User.get();
    Future.wait([_delay, _user]).then((List futures) {
      User user = futures[1];
      if(user != null) {
        userLogged = user;
        next(context, HomePage(), replacement: true);
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