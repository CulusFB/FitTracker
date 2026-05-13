import 'package:fit_tracker/DB/data_manager.dart';
import 'package:fit_tracker/DB/models/muscle_group.dart';
import 'package:fit_tracker/src/home/screen/list_activity_screen.dart';
import 'package:flutter/material.dart';

class NewActivityScreen extends StatefulWidget {
  const NewActivityScreen({super.key});
  @override
  State<NewActivityScreen> createState() => _NewActivityScreen();
}

class _NewActivityScreen extends State<NewActivityScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  String search = '';
  List<MuscleGroup> poolMuscleGroup = DataManager().muscleGroups;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: SearchBar(
              elevation: WidgetStatePropertyAll(0),
              leading: Icon(Icons.search),
              hintText: 'Поиск',
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              }),
        ),
        TabBar.secondary(controller: _tabController, tabs: <Widget>[
          Tab(
            text: "Упражнения",
          ),
          Tab(text: "Программы")
        ]),
        Expanded(
          child: TabBarView(controller: _tabController, children: [
            ListActivityScreen(poolMuscleGroup: poolMuscleGroup),
            Column(
              children: [Text('test2')],
            )
          ]),
        ),
      ],
    );
  }
}
