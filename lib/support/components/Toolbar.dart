import 'package:flutter/material.dart';
import 'package:jukebox_app/support/utils/AppColors.dart';
import 'package:jukebox_app/support/utils/Navigation.dart';

class Toolbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData icon;
  final bool iconActionVisible;
  final VoidCallback onPressed;
  final List<Widget> actions;

  Toolbar({this.title, this.icon = Icons.keyboard_backspace, this.iconActionVisible = true, this.onPressed, this.actions});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        brightness: Theme.of(context).brightness,
        title: Text(this.title, style: TextStyle(color: AppColors.white, fontSize: 18),),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: this.iconActionVisible ? IconButton(icon: Icon(Icons.keyboard_backspace), onPressed: () => back(context),) : null,
        actions: this.actions,
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}