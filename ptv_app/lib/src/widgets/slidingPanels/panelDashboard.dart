import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ptv_app/src/custom/CustomColors.dart';
import 'package:ptv_app/src/util/types/ptv_types.dart';
import 'package:timelines/timelines.dart';
import 'package:ptv_app/src/util/dataBase.dart';

class PTV_Dashboard_PanelWidget extends StatefulWidget {
  final ScrollController controller;
  final DriversFBClass data;
  final User user;
  PTV_Dashboard_PanelWidget({
    Key? key,
    required this.controller,
    required this.data,
    required this.user,
  }) : super(key: key);

  @override
  State<PTV_Dashboard_PanelWidget> createState() =>
      _PTV_Dashboard_PanelWidgetState();
}

class _PTV_Dashboard_PanelWidgetState extends State<PTV_Dashboard_PanelWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.darkDarkLiver,
      child: ListView(
        controller: widget.controller,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        children: buildDashBoard(),
      ),
    );
  }

  List<Widget> buildDashBoard() {
    List<Widget> returnList = [];
    returnList.addAll([
      buildUserDetail(),
      Divider(
        height: 40,
        color: CustomColors.snow,
      ),
      buildStats(),
      Divider(
        height: 40,
        color: CustomColors.snow,
      ),
      SizedBox(height: 20),
      widget.data.Flag == 0 ? createPopUpOrder() : Container(),
      widget.data.Flag == 0 ? SizedBox(height: 20) : Container(),
      buildRoutes(),
    ]);

    return returnList;
  }

  Widget createPopUpOrder() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomColors.snow,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'Neuer Auftrag!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.snow),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'Neuen Auftrag aufnhemne?',
              style: TextStyle(fontSize: 18, color: CustomColors.snow),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  getDataDatabase.sendCancel(widget.user);
                },
                style: ElevatedButton.styleFrom(
                  primary: CustomColors.vermillion,
                  textStyle: TextStyle(fontSize: 15, color: CustomColors.snow),
                ),
                child: Text(
                  'Decline',
                  style: TextStyle(
                    color: CustomColors.snow,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  getDataDatabase.sendOk(widget.user);
                },
                style: ElevatedButton.styleFrom(
                  primary: CustomColors.pastelGreen,
                  textStyle: TextStyle(fontSize: 15, color: CustomColors.snow),
                ),
                child: Text(
                  'Accept',
                  style: TextStyle(
                    color: CustomColors.snow,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildRoutes() {
    TextStyle headings = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: CustomColors.darkDarkLiver,
    );
    TextStyle h2 = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: CustomColors.darkDarkLiver,
    );
    TextStyle p = TextStyle(
      fontSize: 16,
      color: CustomColors.darkDarkLiver,
    );
    RouteFBClass route = widget.data.Route;
    return FixedTimeline.tileBuilder(
      theme: TimelineThemeData(
        nodePosition: 0,
        color: CustomColors.snow,
      ),
      builder: TimelineTileBuilder.connectedFromStyle(
        contentsAlign: ContentsAlign.basic,
        oppositeContentsBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        contentsBuilder: (context, index) => Card(
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 40),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 32),
              child: Column(
                children: [
                  Text('${route.locations[index].id} ', style: headings),
                  Divider(height: 16, color: CustomColors.darkDarkLiver),
                  Text('${route.locations[index].type}', style: h2),
                  SizedBox(height: 12),
                  Text('Comments about the Order', style: p),
                ],
              )),
        ),
        connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
        indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
        itemCount: route.locations.length,
      ),
    );
  }

  Widget buildStats() {
    TextStyle headings = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: CustomColors.snow,
    );
    TextStyle p = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: CustomColors.snow,
    );

    return Row(
      children: [
        Column(
          children: [
            Text(
              'KM',
              style: headings,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '${(widget.data.DistanceTravelled / 1000).floor()}',
              style: p,
            ),
          ],
        ),
        Spacer(),
        Column(
          children: [
            Text(
              'Orders',
              style: headings,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '${widget.data.CurrentOrdersAmount}',
              style: p,
            ),
          ],
        ),
        Spacer(),
        Column(
          children: [
            Text(
              'Earnings',
              style: headings,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '${widget.data.MoneyEarned} CHF',
              style: p,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildUserDetail() {
    return Container(
      height: 65,
      child: Row(
        children: [
          Icon(
            Icons.pedal_bike_outlined,
            color: CustomColors.snow,
            size: 30,
          ),
          Spacer(),
          Text(
            'Dashboard: ${widget.data.Name}',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CustomColors.snow),
          )
        ],
      ),
    );
  }
}
