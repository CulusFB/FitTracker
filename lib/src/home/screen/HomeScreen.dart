import 'package:fit_tracker/generated/l10n.dart';
import 'package:fit_tracker/src/home/screen/NewActivityScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});
  @override
  State<Homescreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<Homescreen> with TickerProviderStateMixin {
  late List<DateTime> _dates;
  final _controller = AdvancedCalendarController.today();
  final events = <DateTime>[
    DateTime.now(),
    DateTime(2022, 10, 10),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dates = [DateTime.now()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AdvancedCalendar(
                innerDot: true,
                startWeekDay: 1,
                controller: _controller,
                events: events,
              ),
            ),
            ElevatedButton(
                onPressed: () => {
                      showModalBottomSheet(
                          useSafeArea: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return NewActivityScreen();
                          })
                    },
                child: Text(S.of(context).add_activity))
          ],
        ),
      ),
    );
  }
}
