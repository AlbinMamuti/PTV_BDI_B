import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ptv_app/src/custom/CustomColors.dart';

class PtvAppBar extends StatefulWidget implements PreferredSizeWidget {
  PtvAppBar({
    Key? key,
  })  : preferredSize = Size.fromHeight(kToolbarHeight - 10),
        super(key: key);
  @override
  final Size preferredSize;
  @override
  State<PtvAppBar> createState() => _PtvAppBarState();
}

class _PtvAppBarState extends State<PtvAppBar> {
  String _formatDate = DateFormat.MMMEd('de_CH').format(DateTime.now());

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      foregroundColor: CustomColors.snow,
      backgroundColor: CustomColors.darkDarkLiver,
      title: Text(_formatDate),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.change_circle_outlined))
      ],
    );
  }
}
