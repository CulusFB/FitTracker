import 'package:fit_tracker/DB/DataManager.dart';
import 'package:fit_tracker/DB/models/Workout.dart';
import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/home/screen/NewActivityScreen.dart';
import 'package:fit_tracker/src/home/widgets/TileSelectedActivity.dart';
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
  late AdvancedCalendarController _controller;
  late List<Workout> workouts;
  List<DateTime> events = <DateTime>[];
  @override
  void initState() {
    workouts = DataManager.instance.workout;
    _controller = DataManager.instance.calendarController;
    workoutCalendar(_controller.value);
    _controller.addListener(() => calendarListener());
    super.initState();
  }

  void calendarListener() {
    workoutCalendar(_controller.value);
  }

  void workoutCalendar(DateTime date) async {
    events = await DataManager.instance.dateWorkouts();
    DateTime update_date = new DateTime(date.year, date.month, date.day);
    workouts = await DataManager.instance.getWorkoutDay(update_date);
    setState(() {});
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
            Theme(
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    children: workouts
                        .map((workout) => TileSelectedActivity(
                            workout: workout,
                            key: Key(workout.id.toString()),
                            poolActivity: DataManager.instance.poolActivity
                                .firstWhere(
                                    (el) => el.id == workout.poolActivityId),
                            onChange: () {}))
                        .toList()),
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
                            }).whenComplete(() {
                          calendarListener();
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
