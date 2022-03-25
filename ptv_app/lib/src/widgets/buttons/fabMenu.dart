import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ptv_app/src/custom/CustomColors.dart';

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
  }) : super(key: key);

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = false;
  }

  void _toggle() {
    setState(() {
      _open = !_open;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      direction: SpeedDialDirection.down,
      overlayColor: CustomColors.snow.withAlpha(0),
      activeForegroundColor: CustomColors.snow,
      activeBackgroundColor: CustomColors.darkDarkLiver,
      foregroundColor: CustomColors.snow,
      backgroundColor: CustomColors.darkDarkLiver,
      animatedIcon: AnimatedIcons.menu_arrow,
      children: [
        SpeedDialChild(
          child: Icon(Icons.route),
          label: 'Routen Info',
        ),
        SpeedDialChild(child: Icon(Icons.share), label: 'Share'),
        SpeedDialChild(child: Icon(Icons.arrow_upward), label: 'Routen Info'),
      ],
    );
  }
}
