import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/home/screen/home_screen.dart';
import 'package:fit_tracker/src/themes/theme_dark.dart';
import 'package:fit_tracker/src/themes/theme_light.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MaterialContextApp extends StatefulWidget {
  const MaterialContextApp({super.key});
  @override
  State<MaterialContextApp> createState() => _MaterialContextApp();
  static State<MaterialContextApp>? of(BuildContext context) =>
      context.findAncestorStateOfType<_MaterialContextApp>();
}

class _MaterialContextApp extends State<MaterialContextApp> {
  @override
  void initState() {
    super.initState();
    DataManager dataManager = DataManager();
    dataManager.init();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
        title: 'Fit Tracker',
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: createLightTheme(textTheme),
        darkTheme: createDarkTheme(textTheme),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        showSemanticsDebugger: false,
        home: Homescreen());
  }
}
