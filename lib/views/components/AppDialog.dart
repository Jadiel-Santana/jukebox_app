import 'package:flutter/material.dart';
import 'package:jukebox_app/support/components/AppButton.dart';
import 'package:jukebox_app/support/utils/AppColors.dart';

class AppDialog extends StatelessWidget {
  final Function(int) onPressed;

  AppDialog({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Container(
        width: 200,
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(child: Icon(Icons.delete, size: 35, color: AppColors.white), radius: 30, backgroundColor: AppColors.red),
            SizedBox(height: 10),
            Text('Deseja excluir este\nusuário?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AppButton(
                  id: 'btnNo',
                  title: 'NÃO',
                  icon: Icons.close,
                  color: AppColors.redAccent,
                  size: 100,
                  onPressed: () => this.onPressed(1),
                ),
                AppButton(
                  id: 'btnYes',
                  title: 'SIM',
                  icon: Icons.close,
                  color: AppColors.green,
                  size: 100,
                  onPressed: () => this.onPressed(2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}