import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/DB/models/workout.dart';
import 'package:fit_tracker/src/home/screen/new_activity_screen.dart';
import 'package:fit_tracker/src/home/screen/settings_screen.dart';
import 'package:fit_tracker/src/home/widgets/tile_selected_activity.dart';
import 'package:fit_tracker/src/themes/filled_button_theme.dart';
import 'package:fit_tracker/src/themes/theme_dark.dart';
import 'package:fit_tracker/src/themes/theme_light.dart';
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

  _HomeScreen();

  @override
  void initState() {
    _initLateVarible();
    super.initState();
  }

  void _initLateVarible() {
    workouts = DataManager().workouts;
    _controller = DataManager().calendarController;
    workoutCalendar(_controller.value);
    _controller.addListener(() => calendarListener());
  }

  void calendarListener() {
    workoutCalendar(_controller.value);
  }

  void workoutCalendar(DateTime date) async {
    events = await DataManager().dateWorkouts();
    DateTime updateDate = DateTime(date.year, date.month, date.day);
    workouts = await DataManager().getWorkoutDay(updateDate);
    setState(() {});
  }

  bool isDark() {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
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
              child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final firstWorkout = workouts[oldIndex];
                    workouts.removeAt(oldIndex);
                    workouts.insert(newIndex, firstWorkout);
                    for (var i = 0; i < workouts.length; i++) {
                      workouts[i].position = i;
                    }
                    DataManager().swapWorkoutPosition(workouts);
                    setState(() {});
                  },
                  children: workouts
                      .map((workout) => TileSelectedActivity(
                          workout: workout,
                          key: ValueKey(workout.id),
                          poolActivity: DataManager()
                              .poolActivities
                              .firstWhere((el) => el.id == workout.poolActivityId),
                          onChange: () {}))
                      .toList()),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  IconButton.filledTonal(
                      onPressed: () => {
                            showModalBottomSheet(
                                context: context,
                                useSafeArea: true,
                                isScrollControlled: true,
                                builder: (context) {
                                  return SettingsScreen();
                                }).whenComplete(() {
                              _initLateVarible();
                            })
                          },
                      icon: Icon(Icons.settings),
                      iconSize: 35),
                  SizedBox(
                    width: 120,
                    child: IconButton.filled(
                      iconSize: 35,
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
                      icon: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
