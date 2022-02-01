import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:rider_app/core/geo_provider/geo_states.dart';
import 'package:rider_app/core/services.dart';
import 'package:rider_app/helper/components.dart';
import 'package:rider_app/helper/constants.dart';
import 'package:rider_app/helper/http_helper.dart';
import 'package:rider_app/models/address_model.dart';
import 'package:rider_app/models/ride_request_model.dart';
import 'package:rider_app/models/searched_places_model.dart';

class GeoProvider extends Cubit<GeoStates> {
  GeoProvider() : super(GeoInitialState());

  CameraPosition cameraInitialPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  late GoogleMapController _newMapController;

  GoogleMapController get newMapController => _newMapController;

  void setMapController(GoogleMapController controller) {
    _newMapController = controller;
    emit(GeoSetControllerState());
  }

  late Position currentPosition;

  AddressModel? pickUpLocation;
  SearchedPlacesModel? searchedPlacesModel;
  AddressModel? dropOffLocation;

  List<LatLng> polyLineCoordinates = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  int tripCost = 0;
  String tripDistance = "";

  final DatabaseReference rideRequestRef = FirebaseDatabase.instance
      .reference()
      .child(fireBaseRideRequestPath)
      .push();

  // this function helps finding current position on the map including latitude amd longitude
  Future<void> locateCurrentPosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showToast("Location Permissions Are Denied", error: true);
        }
      } else {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        currentPosition = position;

        LatLng latLngPosition = LatLng(position.latitude, position.longitude);
        CameraPosition newCamPosition = CameraPosition(
          target: latLngPosition,
          zoom: 14.0,
        );

        await _newMapController
            .animateCamera(CameraUpdate.newCameraPosition(newCamPosition));

        await getCurrentPositionAddress(position);
        emit(GeoGetLocationSuccessState());
      }
    } catch (e) {
      print(e.toString());
      showToast(e.toString(), error: true);
      emit(GeoGetLocationFailureState());
    }
  }

  // this function makes reverse geocoding changing latlang to readable string address
  // we used it in home screen to show a readable current location
  Future<void> getCurrentPositionAddress(Position pos) async {
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${pos.latitude},${pos.longitude}&key=$mapKey";
    var response = await HttpHelper.getData(url);
    if (response != "Failed") {
      pickUpLocation = AddressModel.fromJson(response["results"][0]);
    }
    emit(GeoGetLocationAddressSuccessState());
  }

  // this function makes search on nearby places based on user input using places api
  // we used it in search destination screen to show predictions
  Future<void> getDestinationBySearch(String input) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&location=${currentPosition.latitude}%2C${currentPosition.longitude}&radius=1000&types=establishment&key=$mapKey";
    var response = await HttpHelper.getData(url);

    if (response != "Failed") {
      searchedPlacesModel = SearchedPlacesModel.fromJson(response);
    }
    emit(GeoGetDestinationBySearchSuccessState());
  }

  // this function get details for the searched prediction
  // we use it on tapping on the desired location from the list of searched places
  Future<void> getDestinationDetails(
    BuildContext context,
    String placeID,
  ) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$mapKey";
    var response = await HttpHelper.getData(url);

    if (response != "Failed") {
      dropOffLocation = AddressModel.fromJson(response["result"]);
    }

    // close search destination screen
    Navigator.pop(context, "ObtainedDetails");

    emit(GeoGetDestinationBySearchSuccessState());
  }

  // this function gets the directions from pickUpLocation to dropOffLocation based on their values which are previously stored
  Future<void> getDestinationDirections(BuildContext context) async {
    LatLng pickUpLatLng = LatLng(pickUpLocation!.lat!, pickUpLocation!.lng!);
    LatLng dropOffLatLng = LatLng(dropOffLocation!.lat!, dropOffLocation!.lng!);

    var directions = await Services.getDirections(pickUpLatLng, dropOffLatLng);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePoints =
        polylinePoints.decodePolyline(directions!.encodedPoints!);

// create polyline coordinates to pass it to polyline widget that creates it on the map
    polyLineCoordinates.clear();
    if (decodedPolyLinePoints.isNotEmpty) {
      for (var element in decodedPolyLinePoints) {
        polyLineCoordinates.add(
          LatLng(element.latitude, element.longitude),
        );
      }
    }

// create the polyline itself
    polyLineSet.clear();
    Polyline polyLine = Services.createPolyline(
      id: "ysfhmzaPolyline",
      coordinates: polyLineCoordinates,
    );

// pass it to the set that will be passed to GoogleMap widget which shows the map
    polyLineSet.add(polyLine);

// create the bounds of the direction and animate the camera to fit the whole direction
    LatLngBounds latLngBounds = Services.createLatLngBounds(
      pickUpLatLng: pickUpLatLng,
      dropOffLatLng: dropOffLatLng,
    );
    _newMapController.animateCamera(
      CameraUpdate.newLatLngBounds(latLngBounds, 20),
    );

    final Marker pickUpMarker = Marker(
      markerId: const MarkerId("ysfhmzaPickUpMarkerID"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: pickUpLatLng,
      infoWindow: InfoWindow(
        title: pickUpLocation!.formattedAddress,
        snippet: "Pickup Location",
      ),
    );

    final Marker dropOffMarker = Marker(
      markerId: const MarkerId("ysfhmzaDropOffMarkerID"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: dropOffLatLng,
      infoWindow: InfoWindow(
        title: dropOffLocation!.formattedAddress,
        snippet: "Drop off Location",
      ),
    );

    markersSet.add(pickUpMarker);
    markersSet.add(dropOffMarker);

    Circle pickUpCircle = Services.createCircle(
      id: "pickupCircleId",
      fillColor: primaryColor,
      center: pickUpLatLng,
    );

    Circle dropOffCircle = Services.createCircle(
      id: "dropOffCircle",
      fillColor: Colors.red,
      center: dropOffLatLng,
    );

    circlesSet.add(pickUpCircle);
    circlesSet.add(dropOffCircle);

    tripCost = Services.calculateFares(directions);
    tripDistance = directions.distanceText!;

    emit(GeoGetDirectionSuccessState());
  }

  Future<void> requestDriver() async {
    emit(GeoRequestDriverLoadingState());
    final rideRequestModel = RideRequestModel(
      driverId: "waiting",
      paymentMethod: "Cash",
      pickUpLocationData: {
        "latitude": pickUpLocation!.lat!.toString(),
        "longitude": pickUpLocation!.lng!.toString(),
      },
      dropOffLocationData: {
        "latitude": dropOffLocation!.lat!.toString(),
        "longitude": dropOffLocation!.lng!.toString(),
      },
      createdAt: DateTime.now().toString(),
      riderName: currentUserData!.name,
      riderPhone: currentUserData!.phone,
      pickUpAddress: pickUpLocation!.formattedAddress!,
      dropOffAddress: dropOffLocation!.formattedAddress!,
    );

    await rideRequestRef.set(rideRequestModel.toJson());
  }

  void resetApp() async {
    polyLineCoordinates.clear();
    polyLineSet.clear();
    circlesSet.clear();
    markersSet.clear();
    await rideRequestRef.remove();
    await locateCurrentPosition();
    emit(GeoCancelTripState());
  }
}
