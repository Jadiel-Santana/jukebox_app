import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jukebox_app/support/utils/AppColors.dart';
import 'file:///C:/Projetos/Flutter/jukebox_app/lib/views/pages/LoadPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jukebox',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: AppColors.greyBackground,
        buttonColor: AppColors.blueDark,
        brightness: Brightness.dark,
        primarySwatch: AppColors.indigo,
        cursorColor: AppColors.blueDark,
        fontFamily: 'Montserrat',
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.blueDark,
        ),
      ),
      home: LoadPage(),
    );
  }
}