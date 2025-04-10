import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/home/screen/NewActivityScreen.dart';
import 'package:fit_tracker/src/themes/FilledButtonTheme.dart';
import 'package:fit_tracker/src/themes/ThemeDark.dart';
import 'package:fit_tracker/src/themes/ThemeLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});
  @override
  State<Homescreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<Homescreen> with TickerProviderStateMixin {
  final _controller = AdvancedCalendarController.today();
  final events = <DateTime>[
    DateTime.now(),
    DateTime(2022, 10, 10),
  ];
  @override
  void initState() {
    super.initState();
  }

  bool isDark() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Theme(
                data: isDark()
                    ? createDarkTheme(Theme.of(context).textTheme)
                        .copyWith(primaryColor: Colors.lightBlueAccent)
                    : createLightTheme(Theme.of(context).textTheme).copyWith(),
                child: AdvancedCalendar(
                  innerDot: true,
                  startWeekDay: 1,
                  controller: _controller,
                  events: events,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: FilledButton(
                  style: FilledButtonStyle(),
                  onPressed: () => {
                        showModalBottomSheet(
                            useSafeArea: true,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return NewActivityScreen();
                            })
                      },
                  child: Text(S.of(context).add_activity)),
            )
          ],
        ),
      ),
    );
  }
}
