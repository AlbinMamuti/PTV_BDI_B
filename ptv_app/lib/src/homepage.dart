import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ptv_app/src/util/dataBase.dart';
import 'package:ptv_app/src/widgets/appBar/ptvAppBar.dart';
import 'package:ptv_app/src/widgets/maps/ptv_map.dart';
import 'package:ptv_app/src/widgets/slidingPanels/panelDashboard.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController? scrollController;
  PanelController panelController = PanelController();
  void slidePanelShow() {
    panelController.open();
    if (scrollController != null) {
      scrollController?.animateTo(-500,
          duration: Duration(seconds: 1), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PtvAppBar(),
      body: StreamBuilder(
        stream: getDataDatabase.getDriverStream(widget.user),
        builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData)
            return SlidingUpPanel(
                controller: panelController,
                body: PtvMap(
                  data: snapshot.data.data(),
                  user: widget.user,
                  slidePanelShow: slidePanelShow,
                ),
                parallaxEnabled: true,
                parallaxOffset: 0.6,
                panelBuilder: (controller) {
                  scrollController = controller;
                  return PTV_Dashboard_PanelWidget(
                    user: widget.user,
                    controller: controller,
                    data: snapshot.data.data(),
                  );
                });
          else
            return CircularProgressIndicator();
        },
      ),
    );
  }
}
