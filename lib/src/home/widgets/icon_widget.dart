import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class IconWidget extends StatefulWidget {
  const IconWidget({super.key, required this.muscleGroupId});
  final int muscleGroupId;
  @override
  State<IconWidget> createState() => IconWidgetState();
}

class IconWidgetState extends State<IconWidget> with TickerProviderStateMixin {
  late String pathTheme;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    pathTheme = brightness == Brightness.dark ? 'dark' : 'white';
    return SizedBox(
        width: 50,
        height: 50,
        child: FutureBuilder<String>(
            future: rootBundle
                .loadString('assets/icons/MuscleGroup/$pathTheme/${widget.muscleGroupId}.svg'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SvgPicture.string(
                  snapshot.data!,
                );
              } else {
                if (kDebugMode) {
                  print("Ошибка при загрузке SVG: ${snapshot.error}");
                }
                return Icon(Icons.abc);
              }
            }));
  }
}
