import 'package:flutter/material.dart';
import 'package:ptv_app/src/custom/CustomColors.dart';

class PositionMarker extends StatefulWidget {
  PositionMarker({Key? key}) : super(key: key);

  @override
  State<PositionMarker> createState() => _PositionMarkerState();
}

class _PositionMarkerState extends State<PositionMarker>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 6));
    _animationController?.repeat(reverse: true);
    _animation = Tween(begin: 1.0, end: 4.0).animate(_animationController!)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      child: Icon(
        Icons.circle,
        color: CustomColors.locationBlue,
      ),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CustomColors.locationBlue,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 110, 162, 245),
              blurRadius: _animation?.value,
              spreadRadius: _animation?.value,
              blurStyle: BlurStyle.solid,
            ),
          ]),
    );
  }
}
