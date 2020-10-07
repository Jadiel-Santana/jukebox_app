import 'package:flutter/material.dart';
import 'package:jukebox_app/support/utils/AppColors.dart';

class ErrorPage extends StatelessWidget {
  final String message;
  ErrorPage({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 200,
      color: Theme.of(context).backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.filter_drama, size: 90, color: AppColors.red,),
          SizedBox(height: 20,),
          Text(this.message, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.red),),
        ],
      ),
    );
  }
}