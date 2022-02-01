import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_app/helper/constants.dart';

import 'package:rider_app/helper/http_helper.dart';
import 'package:rider_app/models/direction_model.dart';
import 'package:rider_app/models/user_model.dart';

class Services {
  // this function returns the directions for any location
  static Future<DirectionModel?> getDirections(
    LatLng pickupLocation,
    LatLng dropOffLocation,
  ) async {
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?destination=${dropOffLocation.latitude},${dropOffLocation.longitude}&origin=${pickupLocation.latitude},${pickupLocation.longitude}&key=$mapKey";

    var response = await HttpHelper.getData(url);

    if (response != "Failed") {
      // made the instance from direction model directly because can't use static with normal instances
      return DirectionModel.fromJson(response);
    }
  }

  static Polyline createPolyline({
    required String id,
    required List<LatLng> coordinates,
  }) {
    Polyline polyline = Polyline(
      polylineId: PolylineId(id),
      color: Colors.red,
      width: 5,
      endCap: Cap.roundCap,
      startCap: Cap.roundCap,
      points: coordinates,
      geodesic: true,
      jointType: JointType.round,
    );

    return polyline;
  }

  static LatLngBounds createLatLngBounds({
    required LatLng pickUpLatLng,
    required LatLng dropOffLatLng,
  }) {
    late LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
        northeast: LatLng(dropOffLatLng.longitude, pickUpLatLng.longitude),
      );
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
        northeast: LatLng(pickUpLatLng.longitude, dropOffLatLng.longitude),
      );
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    return latLngBounds;
  }

  static Circle createCircle({
    required String id,
    required Color fillColor,
    required LatLng center,
  }) {
    Circle circle = Circle(
      circleId: CircleId(id),
      fillColor: fillColor,
      center: center,
      radius: 12.0.r,
      strokeWidth: 4,
      strokeColor: fillColor,
    );

    return circle;
  }

  static int calculateFares(DirectionModel directionModel) {
    double durationFares = (directionModel.durationValue! / 60) * 0.2;
    double distanceFares = (directionModel.distanceValue! / 1000) * 0.2;
    double totalFares = distanceFares + durationFares;
    int totalCost = totalFares.truncate();
    return totalCost;
  }

  static Future<void> getCurrentUserData() async {
    final FirebaseAuth firebaseAuthRef = FirebaseAuth.instance;
    final DatabaseReference usersRef =
        FirebaseDatabase.instance.reference().child(fireBaseUsersPath);

    final user = await usersRef.child(firebaseAuthRef.currentUser!.uid).get();

    currentUserData = UserModel.fromJson(user.value);
  }
}
