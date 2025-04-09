import 'package:fit_tracker/src/home/screen/ActivityScreen.dart';
import 'package:flutter/material.dart';

class NewActivityScreen extends StatefulWidget {
  const NewActivityScreen({super.key});
  @override
  State<NewActivityScreen> createState() => _NewActivityScreen();
}

class _NewActivityScreen extends State<NewActivityScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          SearchBar(),
          TabBar.secondary(controller: _tabController, tabs: <Widget>[
            Tab(
              text: "Упражнения",
            ),
            Tab(text: "Программы")
          ]),
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              ActivityScreen(),
              Column(
                children: [Text('test2')],
              )
            ]),
          )
        ],
      ),
    );
  }
}
