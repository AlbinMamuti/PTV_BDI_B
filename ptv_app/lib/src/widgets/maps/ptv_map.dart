import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ptv_app/.env.dart';
import 'package:ptv_app/customIcons/my_flutter_app_icons.dart';
import 'package:ptv_app/src/custom/CustomColors.dart';
import 'package:ptv_app/src/util/locationUtils.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ptv_app/src/util/polyLinesUtils.dart';
import 'package:ptv_app/src/util/types/ptv_types.dart';
import 'package:ptv_app/src/widgets/buttons/fabMenu.dart';
import 'package:ptv_app/src/widgets/markers/positionMarker.dart';

class PtvMap extends StatefulWidget {
  final DriversFBClass data;
  final User user;

  ///Callback Functions
  // callBack for moving slidePanel up
  final Function slidePanelShow;
  PtvMap(
      {Key? key,
      required this.data,
      required this.user,
      required this.slidePanelShow})
      : super(key: key);

  @override
  State<PtvMap> createState() => _PtvMapState();
}

class _PtvMapState extends State<PtvMap> with SingleTickerProviderStateMixin {
  ///Location
  late LocationUtils location;
  late PolyLinesUtils polyLinesClass;
  late Stream<Position> locationSubscription;
  List<Polyline>? polylines;
  Position? activePosition;

  void eventHandler(Position event) {
    print('${event.latitude}, ${event.longitude}');
    setState(() {
      activePosition = event;
      markers = createMarker();
    });
  }

  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  ///Location
  ///
  bool isPlaying = false;

  ///Map Controllers and Markers
  MapController mapController = MapController();
  List<Marker> markers = [];

  ///Map Controllers and Markers
  @override
  void initState() {
    super.initState();
    location = LocationUtils();
    locationSubscription = location.getPositionStream();
    locationSubscription.listen(eventHandler);
    polyLinesClass = PolyLinesUtils(
        wayPoints: widget.data.Route.locations
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList());
    polyLinesClass.callerCreatePolyLines().then((result) {
      polylines = result;
    });
  }

  @override
  void didUpdateWidget(PtvMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    markers = createMarker();
  }

  @override
  Widget build(BuildContext context) {
    return (activePosition == null)
        ? CircularProgressIndicator()
        : Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(
                        activePosition!.latitude, activePosition!.longitude),
                    zoom: 15.0,
                    onTap: (_) => _popupLayerController.hideAllPopups(),
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          "https://api.myptv.com/rastermaps/v1/image-tiles/{z}/{x}/{y}?style=silica&apiKey=$ptvApiKey",
                    ),
                    MarkerLayerOptions(markers: markers),
                    (polylines != null)
                        ? PolylineLayerOptions(
                            polylines: polylines!,
                          )
                        : MarkerLayerOptions(),
                  ],
                  mapController: mapController,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                  height: 220,
                  child: Column(
                    children: [
                      Container(
                        height: 56,
                        child: ExpandableFab(
                            slidePanelShow: widget.slidePanelShow),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 70,
                        child: FloatingActionButton(
                          backgroundColor: CustomColors.darkDarkLiver,
                          onPressed: () {
                            if (activePosition != null) {
                              mapController.move(
                                  LatLng(activePosition!.latitude,
                                      activePosition!.longitude),
                                  mapController.zoom);
                            }
                          },
                          child: Icon(Icons.center_focus_weak_rounded,
                              color: CustomColors.snow, size: 32),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  List<Marker> createMarker() {
    List<Marker> ret = [];
    ret.add(
      Marker(
        point: LatLng(activePosition!.latitude, activePosition!.longitude),
        width: 30,
        height: 30,
        builder: (ctx) => PositionMarker(),
      ),
    );
    ret.addAll(widget.data.Route.locations
        .map(
          (e) => Marker(
            point: LatLng(e.latitude, e.longitude),
            width: 60,
            height: 60,
            builder: (ctx) => Icon(MyFlutterApp.map_marker_alt,
                color: CustomColors.vermillion, size: 30),
          ),
        )
        .toList());
    return ret;
  }
}
