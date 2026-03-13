import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/DB/models/workout.dart';
import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/home/screen/new_activity_screen.dart';
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
    workouts = DataManager.instance.workouts;
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
    DateTime updateDate = DateTime(date.year, date.month, date.day);
    workouts = await DataManager.instance.getWorkoutDay(updateDate);
    setState(() {});
  }

  bool isDark() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
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
                    DataManager.instance.swapWorkoutPosition(workouts);
                    setState(() {});
                  },
                  children: workouts
                      .map((workout) => TileSelectedActivity(
                          workout: workout,
                          key: ValueKey(workout.id),
                          poolActivity: DataManager.instance.poolActivities
                              .firstWhere(
                                  (el) => el.id == workout.poolActivityId),
                          onChange: () {}))
                      .toList()),
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
