import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  final String message;
  EmptyPage({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset('assets/images/jukebox.png', width: 90, height: 90,),
              ),
              SizedBox(height: 20,),
              Text(this.message, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
  }
}