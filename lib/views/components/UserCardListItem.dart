import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:jukebox_app/domains/bloc/AuthBloc.dart';
import 'package:jukebox_app/domains/model/User.dart';
import 'package:jukebox_app/support/utils/AppColors.dart';
import 'package:jukebox_app/support/utils/Navigation.dart';
import 'package:jukebox_app/support/utils/NotificationMessage.dart';
import 'package:jukebox_app/support/utils/StringUtils.dart';
import 'package:jukebox_app/views/components/AppDialog.dart';
import 'package:jukebox_app/views/pages/UserForm.dart';
import 'package:jukebox_app/views/pages/UserList.dart';

class UserCardListItem extends StatefulWidget {
  final User user;
  UserCardListItem({this.user});
  @override _UserCardListItemState createState() => _UserCardListItemState();
}

class _UserCardListItemState extends State<UserCardListItem> {
  User get user => widget.user;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text(StringUtils.capitalize(user.name), overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 14)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 4),
                  Text(user.email, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 13)),
                  SizedBox(height: 4),
                  Text(user.birthday, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 13)),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    child: Icon(Icons.edit, color: AppColors.green,),
                    onTap: () => next(context, UserForm(user: user)),
                  ),
                  GestureDetector(
                    child: Icon(Icons.delete, color: AppColors.redAccent),
                    onTap: _deleteDialog,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _deleteDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AppDialog(
          onPressed: (value) async {
            if(value == 2) {
              String _result = await AuthBloc().delete(user.id);
              if(_result.startsWith(StringUtils.OK)){
                NotificationMessage.instance.success(buildContext, 'Usuário excluído com sucesso.');
                next(buildContext, UserList(), replacement: true);
              } else {
                NotificationMessage.instance.warning(buildContext, _result);
              }
            }
            else if(value == 1) { back(buildContext); }
          }
        );
      });
  }
}