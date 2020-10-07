import 'package:flutter/material.dart';
import 'package:jukebox_app/domains/bloc/AuthBloc.dart';
import 'package:jukebox_app/support/components/Toolbar.dart';
import 'package:jukebox_app/support/utils/Navigation.dart';
import 'package:jukebox_app/views/pages/SignIn.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: Toolbar(
        title: 'Jukebox',
        iconActionVisible: false,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              AuthBloc().signOut();
              next(context, SignIn(), replacement: true);
            },
          ),
        ],
      ),
    );
  }
}