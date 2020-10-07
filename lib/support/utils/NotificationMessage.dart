import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:jukebox_app/support/utils/AppColors.dart';

class NotificationMessage {
  NotificationMessage._();

  static NotificationMessage _instance;

  static NotificationMessage get instance {
    return _instance ??= NotificationMessage._();
  }


  /// Responsavel para enviar notificações do tipo warning
  /// @param BuildContext context
  /// @param String message
  /// @returns Flushbar.
  warning(BuildContext context, String message) {
    Flushbar(
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      message: '$message',
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: Icon(Icons.warning, color: AppColors.white),
      duration: Duration(seconds: 3),
      backgroundColor: AppColors.orange,
    )..show(context);
  }


  /// Responsavel para enviar notificações do tipo sucesso
  /// @param BuildContext context
  /// @param String message
  /// @returns Flushbar.
  success(BuildContext context, String message) {
    Flushbar(
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      message: '$message',
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: Icon(Icons.check, color: AppColors.white),
      duration: Duration(seconds: 3),
      backgroundColor: AppColors.green,
    )..show(context);
  }
}