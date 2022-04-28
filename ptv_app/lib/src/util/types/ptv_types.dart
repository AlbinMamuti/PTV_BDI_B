import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class DriversFBClass {
  int CurrentOrdersAmount;
  int DistanceTravelled;
  String Email;
  int Flag;
  LatLng Location;
  int MoneyEarned;
  String Name;
  RouteFBClass NewRoute;
  List<String> Orders;
  int Priority;
  RouteFBClass Route;
  DriversFBClass({
    required this.CurrentOrdersAmount,
    required this.DistanceTravelled,
    required this.Email,
    required this.Flag,
    required this.Location,
    required this.MoneyEarned,
    required this.Name,
    required this.Route,
    required this.Orders,
    required this.NewRoute,
    required this.Priority,
  });
  DriversFBClass.fromJson(Map<String, Object?> json)
      : this(
          CurrentOrdersAmount: json['CurrentOrdersAmount']! as int,
          DistanceTravelled: json['DistanceTravelled']! as int,
          Email: json['Email']! as String,
          Flag: json["Flag"]! as int,
          Location: LatLng((json["Location"]! as GeoPoint).latitude,
              (json["Location"]! as GeoPoint).longitude),
          MoneyEarned: json["MoneyEarned"]! as int,
          Name: json["Name"]! as String,
          NewRoute: RouteFBClass.fromJson(
              jsonDecode(json["NewRoute"]! as String) as Map<String, dynamic>),
          Orders:
              (json["Orders"]! as List).map((ell) => ell.toString()).toList(),
          Priority: json["Priority"]! as int,
          Route: RouteFBClass.fromJson(
              jsonDecode(json["NewRoute"]! as String) as Map<String, dynamic>),
        );
  Map<String, Object?> toJson() {
    var temp = {
      'NOT YET IMPLEMENTED': 0,
    };
    return temp;
  }
}

class RouteFBClass {
  String id;
  List<LocationPTV> locations; //not yet implemented
  List<dynamic> vehicles; //not yet implemented
  List<dynamic> drivers; //not yet implemented
  List<TransportsPTV> transports; //not yet implemented
  Map<String, dynamic> planningHorizon; //not yet implemented
  List<RoutesInfoClass> routes; //not yet implemented
  List<dynamic> unplannedVehicleIds; //not yet implemented
  List<dynamic> unplannedTransportIds; //not yet implemented
  RouteFBClass({
    required this.id,
    required this.locations,
    required this.vehicles,
    required this.drivers,
    required this.transports,
    required this.planningHorizon,
    required this.routes,
    required this.unplannedVehicleIds,
    required this.unplannedTransportIds,
  });

  RouteFBClass.fromJson(Map<String, Object?> json)
      : this(
          id: json["id"]! as String,
          locations: (json["locations"]! as List)
              .map((ell) => LocationPTV.fromJson((ell as Map<String, dynamic>)))
              .toList(),
          vehicles: json["vehicles"]! as List<dynamic>,
          drivers: json["drivers"]! as List<dynamic>,
          transports: (json["transports"]! as List)
              .map((ell) =>
                  TransportsPTV.fromJson((ell as Map<String, dynamic>)))
              .toList(),
          planningHorizon: json["planningHorizon"]! as Map<String, dynamic>,
          routes: (json["routes"]! as List)
              .map((ell) =>
                  RoutesInfoClass.fromJson((ell as Map<String, dynamic>)))
              .toList(),
          unplannedTransportIds:
              json["unplannedTransportIds"]! as List<dynamic>,
          unplannedVehicleIds: json["unplannedVehicleIds"]! as List<dynamic>,
        );

  Map<String, Object?> toJson() {
    var temp = {
      'NOT YET IMPLEMENTED': 0,
    };
    return temp;
  }
}

class TransportsPTV {
  String id;
  String pickupLocationId;
  int pickupServiceTime;
  String deliveryLocationId;
  int deliveryServiceTime;
  int priority;
  TransportsPTV({
    required this.id,
    required this.pickupLocationId,
    required this.pickupServiceTime,
    required this.deliveryLocationId,
    required this.deliveryServiceTime,
    required this.priority,
  });

  TransportsPTV.fromJson(Map<String, Object?> json)
      : this(
          id: json["id"]! as String,
          pickupLocationId: json["pickupLocationId"]! as String,
          pickupServiceTime: json["pickupServiceTime"]! as int,
          deliveryLocationId: json["deliveryLocationId"]! as String,
          deliveryServiceTime: json["deliveryServiceTime"]! as int,
          priority: json["priority"]! as int,
        );

  Map<String, Object?> toJson() {
    var temp = {
      'NOT YET IMPLEMENTED': 0,
    };
    return temp;
  }
}

class LocationPTV {
  String id;
  String type;
  double latitude;
  double longitude;
  LocationPTV({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
  });
  Map<String, Object?> toJson() {
    var temp = {
      'NOT YET IMPLEMENTED': 0,
    };
    return temp;
  }

  LocationPTV.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          type: json['type']! as String,
          latitude: json['latitude']! as double,
          longitude: json['longitude']! as double,
        );
}

class RoutesInfoClass {
  String vehicleId;
  List<StoppPTVClass> stops;
  ReportPTVObj report;
  RoutesInfoClass({
    required this.vehicleId,
    required this.stops,
    required this.report,
  });

  RoutesInfoClass.fromJson(Map<String, Object?> json)
      : this(
            vehicleId: json["vehicleId"]! as String,
            stops: (json["stops"]! as List)
                .map((ell) =>
                    StoppPTVClass.fromJson((ell as Map<String, dynamic>)))
                .toList(),
            report: ReportPTVObj.fromJson(
                (json['report'] as Map<String, dynamic>)));
  Map<String, Object?> toJson() {
    var temp = {
      'NOT YET IMPLEMENTED': 0,
    };
    return temp;
  }
}

class StoppPTVClass {
  String locationId;
  String tripId;
  List<String> deliveryIds;
  List<String> pickupIds;
  Map<String, dynamic> reportForWayToStop;
  Map<String, dynamic> reportForStop;
  List<dynamic> eventsOnWayToStop;
  List<dynamic> eventsAtStop;
  List<dynamic> violationsOnWayToStop;
  List<dynamic> violationsAtStop;
  StoppPTVClass({
    required this.locationId,
    required this.tripId,
    required this.deliveryIds,
    required this.pickupIds,
    required this.reportForWayToStop,
    required this.reportForStop,
    required this.eventsOnWayToStop,
    required this.eventsAtStop,
    required this.violationsOnWayToStop,
    required this.violationsAtStop,
  });
  StoppPTVClass.fromJson(Map<String, Object?> json)
      : this(
          locationId: json["locationId"]! as String,
          tripId: json["tripId"]! as String,
          deliveryIds:
              (json["deliveryIds"]! as List).map((e) => e.toString()).toList(),
          pickupIds:
              (json["pickupIds"]! as List).map((e) => e.toString()).toList(),
          reportForWayToStop:
              json["reportForWayToStop"]! as Map<String, dynamic>,
          reportForStop: json["reportForStop"]! as Map<String, dynamic>,
          eventsOnWayToStop: json["eventsOnWayToStop"]! as List<dynamic>,
          eventsAtStop: json["eventsAtStop"]! as List<dynamic>,
          violationsAtStop: json["violationsAtStop"]! as List<dynamic>,
          violationsOnWayToStop:
              json["violationsOnWayToStop"]! as List<dynamic>,
        );
  Map<String, Object?> toJson() {
    var temp = {
      'NOT YET IMPLEMENTED': 0,
    };
    return temp;
  }
}

class ReportPTVObj {
  DateTime startTime;
  DateTime endTime;
  int travelTime;
  int distance;
  int drivingTime;
  int serviceTime;
  int waitingTime;
  int breakTime;
  int restTime;
  ReportPTVObj({
    required this.startTime,
    required this.endTime,
    required this.travelTime,
    required this.distance,
    required this.drivingTime,
    required this.serviceTime,
    required this.waitingTime,
    required this.breakTime,
    required this.restTime,
  });
  ReportPTVObj.fromJson(Map<String, Object?> json)
      : this(
          startTime: DateTime.parse(json['startTime']! as String),
          endTime: DateTime.parse(json['endTime']! as String),
          travelTime: json['travelTime']! as int,
          distance: json['distance']! as int,
          drivingTime: json['drivingTime']! as int,
          serviceTime: json['serviceTime']! as int,
          waitingTime: json['waitingTime']! as int,
          breakTime: json['breakTime']! as int,
          restTime: json['restTime']! as int,
        );
  Map<String, Object?> toJson() {
    var temp = {
      'NOT YET IMPLEMENTED': 0,
    };
    return temp;
  }
}
