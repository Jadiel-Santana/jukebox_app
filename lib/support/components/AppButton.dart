import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String id;
  final String title;
  final Color color;
  final IconData icon;
  final double size;
  final Function onPressed;

  AppButton({this.id, this.title, this.color, this.icon, this.size, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.size != null ? this.size : MediaQuery.of(context).size.width/2.5,
      child: FloatingActionButton.extended(
        heroTag: this.id,
        label: Text(this.title,),
        icon: Icon(this.icon, size: 20,),
        backgroundColor: this.color,
        onPressed: this.onPressed,
      ),
    );
  }
}