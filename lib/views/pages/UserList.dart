
import 'package:flutter/material.dart';
import 'package:jukebox_app/domains/bloc/AuthBloc.dart';
import 'package:jukebox_app/domains/model/HashModel.dart';
import 'package:jukebox_app/domains/model/User.dart';
import 'package:jukebox_app/domains/service/AuthService.dart';
import 'package:jukebox_app/support/components/CircularProgress.dart';
import 'package:jukebox_app/support/components/EmptyPage.dart';
import 'package:jukebox_app/support/components/ErrorPage.dart';
import 'package:jukebox_app/support/components/Toolbar.dart';
import 'package:jukebox_app/support/utils/AppColors.dart';
import 'package:jukebox_app/support/utils/Navigation.dart';
import 'package:jukebox_app/views/components/HashDialog.dart';
import 'package:jukebox_app/views/components/UserCardListItem.dart';
import 'package:jukebox_app/views/pages/SignIn.dart';
import 'package:jukebox_app/views/pages/UserForm.dart';

class UserList extends StatefulWidget { @override _UserListState createState() => _UserListState(); }

class _UserListState extends State<UserList> {
  final _authBloc = AuthBloc();
  int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _authBloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: Toolbar(
        title: 'Jukebox',
        iconActionVisible: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
        child: StreamBuilder<List<User>>(
          stream: _authBloc.stream,
          builder: (context, snapshot) {
            if(snapshot.hasError) {
              return ErrorPage(message: snapshot.error);
            }
            return (!snapshot.hasData) ? CircularProgress() :
            (snapshot.data.isEmpty) ? EmptyPage(message: 'Nenhum usuário\nencontrado',) :
            ListView.builder(
              shrinkWrap: false,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => UserCardListItem(user: snapshot.data[index],),
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'btnAdd',
        backgroundColor: Theme.of(context).buttonColor,
        child: Icon(Icons.add),
        onPressed: () => next(context, UserForm()),
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('Alterar Hash', style: TextStyle(fontSize: 14),)),
          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('', style: TextStyle(fontSize: 14))),
          BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), title: Text('Sair do app', style: TextStyle(fontSize: 14))),
        ],
        currentIndex: selectedIndex,
        fixedColor: AppColors.blueDark,
        onTap: onItemTapped,
      ),

    );
  }

  void onItemTapped(int index) {
    if (index == 0) { _hashDialog(); }
    if (index == 2) { _authBloc.signOut(); next(context, SignIn(), replacement: true); }
    setState(() => selectedIndex = index);
  }

  _hashDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext buildContext) => HashDialog(
        onPressed: (String hash) {
          back(buildContext);
          var _hash = HashModel(hash: hash);
          _hash.store();
          hashUsed = _hash;
        },),);
  }

  @override
  void dispose() {
    super.dispose();
    _authBloc.dispose();
  }
}