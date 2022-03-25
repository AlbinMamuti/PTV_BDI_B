import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ptv_app/src/custom/CustomColors.dart';
import 'package:ptv_app/src/util/dataBase.dart';
import 'package:ptv_app/src/util/types/types.dart';

class CustomDashBoard extends StatefulWidget {
  User user;
  CustomDashBoard({Key? key, required this.user}) : super(key: key);

  @override
  State<CustomDashBoard> createState() => _CustomDashBoardState(user: user);
}

class _CustomDashBoardState extends State<CustomDashBoard> {
  User user;
  //Fetched Data
  _CustomDashBoardState({required this.user}) {
    //Fetch Data !!
  }
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.15,
      minChildSize: 0.08,
      maxChildSize: 0.35,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          clipBehavior: Clip.hardEdge,
          child: Container(
            color: CustomColors.darkLiver,
            child: Column(
              children: [
                //createRowWithByc(),
                createRows(),
              ],
            ),
          ),
        );
      },
    );
  }

  Container createRow(String first, String second, Color sec) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'first',
              style: GoogleFonts.inter(
                textStyle: TextStyle(color: CustomColors.snow),
              ),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'second',
              style: GoogleFonts.inter(
                textStyle: TextStyle(color: sec),
              ),
            ),
          )
        ],
      ),
    );
  }

  Column createRows() {
    int len = 3;
    Column ret = Column(
      children: [],
    );
    for (int i = 0; i < len - 1; i++) {
      ret.children.add(Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'From',
              style: GoogleFonts.inter(
                textStyle: TextStyle(color: CustomColors.snow),
              ),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'To',
              style: GoogleFonts.inter(
                textStyle: TextStyle(color: CustomColors.snow),
              ),
            ),
          ),
        ],
      ));
    }
    return Column();
  }
}
