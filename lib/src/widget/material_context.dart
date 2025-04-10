import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/home/screen/HomeScreen.dart';
import 'package:fit_tracker/src/themes/ThemeDark.dart';
import 'package:fit_tracker/src/themes/ThemeLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MaterialContextApp extends StatefulWidget {
  const MaterialContextApp({super.key});
  @override
  State<MaterialContextApp> createState() => _MaterialContextApp();
  static _MaterialContextApp? of(BuildContext context) =>
      context.findAncestorStateOfType<_MaterialContextApp>();
}

class _MaterialContextApp extends State<MaterialContextApp> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
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
