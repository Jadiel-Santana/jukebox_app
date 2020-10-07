import 'package:flutter/material.dart';

Future next(BuildContext context, Widget page, {bool replacement = false}) {
  if(replacement) {
    back(context);
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
  }

  return Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

bool back<T extends Object>(BuildContext context, [ T result ]) {
  if(Navigator.canPop(context)) {
    Navigator.pop(context);
    return true;
  }
  return false;
}