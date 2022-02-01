import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:rider_app/core/geo_provider/geo_provider.dart';
import 'package:rider_app/core/geo_provider/geo_states.dart';
import 'package:rider_app/core/services.dart';
import 'package:rider_app/helper/constants.dart';
import 'package:rider_app/view/screens/search_destnation_screen.dart';
import 'package:rider_app/view/widgets/colorized_animated_text.dart';
import 'package:rider_app/view/widgets/custom_bottom_sheet.dart';
import 'package:rider_app/view/widgets/custom_home_button.dart';
import 'package:rider_app/view/widgets/custom_text.dart';
import 'package:rider_app/view/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String screenId = "/HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final Completer<GoogleMapController> _googleMapController = Completer();

  late Future _getCurrentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser = Services.getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    print("Home Screen Rebuilt");
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyDrawer(),
      body: FutureBuilder(
        future: _getCurrentUser,
        builder: (context, asyncSnapshot) {
          if (currentUserData == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Stack(
              children: [
                /// The map
                BlocBuilder<GeoProvider, GeoStates>(
                  builder: (context, geoState) {
                    print("From Provider");
                    GeoProvider geoProvider =
                        BlocProvider.of<GeoProvider>(context);
                    return GoogleMap(
                      mapType: MapType.normal,
                      polylines: geoProvider.polyLineSet,
                      markers: geoProvider.markersSet,
                      circles: geoProvider.circlesSet,
                      initialCameraPosition: geoProvider.cameraInitialPosition,
                      onMapCreated: (GoogleMapController controller) {
                        _googleMapController.complete(controller);
                        geoProvider.setMapController(controller);
                        geoProvider.locateCurrentPosition();
                      },
                      padding: EdgeInsets.only(
                        bottom: 325.0.h,
                      ),
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    );
                  },
                ),

                /// Open Drawer Button
                CustomHomeButton(
                  topMargin: 42.0.h,
                  icon: Icons.menu,
                  onTap: () {
                    Services.getCurrentUserData();
                    _scaffoldKey.currentState!.openDrawer();
                  },
                ),

                /// Cancel Trip Button
                BlocBuilder<GeoProvider, GeoStates>(
                  builder: (context, geoState) {
                    GeoProvider _geoProvider =
                        BlocProvider.of<GeoProvider>(context);
                    return CustomHomeButton(
                      topMargin: 100.0.h,
                      icon: Icons.cancel,
                      onTap: () {
                        _geoProvider.resetApp();
                      },
                    );
                  },
                ),

                ///Bottom Sheets
                BlocBuilder<GeoProvider, GeoStates>(
                  builder: (context, geoState) {
                    GeoProvider _geoProvider =
                        BlocProvider.of<GeoProvider>(context);
                    if (geoState is GeoGetDirectionSuccessState) {
                      ///Bottom Sheet For Requesting A Driver (Ride Details Container)
                      return CustomBottomSheet(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  minVerticalPadding: 0.0,
                                  leading: SizedBox(
                                    height: 62.0.h,
                                    width: 62.0.w,
                                    child: Image.asset(
                                      "assets/images/taxi.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: CustomText(
                                    text: "Car",
                                    fontSize: 20.0.sp,
                                  ),
                                  subtitle: CustomText(
                                    text: _geoProvider.tripDistance,
                                    color: Colors.grey,
                                    fontSize: 18.0.sp,
                                  ),
                                ),
                              ),
                              CustomText(
                                text: "\$${_geoProvider.tripCost}",
                                fontSize: 20.0.sp,
                                color: Colors.grey,
                              )
                            ],
                          ),
                          SizedBox(height: 12.0.h),
                          Row(
                            children: [
                              Icon(
                                Icons.money,
                                size: 24.0.sp,
                              ),
                              SizedBox(width: 12.0.w),
                              CustomText(text: "Cash", fontSize: 16.0.sp),
                              SizedBox(width: 12.0.w),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 20.0.sp,
                              ),
                            ],
                          ),
                          SizedBox(height: 12.0.h),
                          BlocBuilder<GeoProvider, GeoStates>(
                              builder: (context, geoState) {
                            GeoProvider _geoProvider =
                                BlocProvider.of<GeoProvider>(context);
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: primaryColor,
                                padding: EdgeInsets.all(8.0.sp),
                                alignment: Alignment.center,
                              ),
                              onPressed: () {
                                _geoProvider.requestDriver();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: "Request",
                                    alignment: Alignment.center,
                                    color: Colors.white,
                                    fontSize: 24.0.sp,
                                  ),
                                  Icon(
                                    Icons.directions_car,
                                    size: 28.0.sp,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            );
                          })
                        ],
                      );
                    } else if (geoState is GeoRequestDriverLoadingState) {
                      return CustomBottomSheet(
                        children: [
                          ColorizedAnimatedText(),
                          SizedBox(height: 12.0.h),
                          BlocBuilder<GeoProvider, GeoStates>(
                              builder: (context, geoState) {
                            GeoProvider _geoProvider =
                                BlocProvider.of<GeoProvider>(context);
                            return InkWell(
                              onTap: () {
                                _geoProvider.resetApp();
                              },
                              child: Container(
                                height: 70.0.h,
                                width: 70.0.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0.w,
                                  ),
                                  borderRadius: BorderRadius.circular(28.0.r),
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 42.0.sp,
                                ),
                              ),
                            );
                          }),
                          SizedBox(height: 12.0.h),
                          CustomText(
                            text: "Cancel the ride",
                            fontSize: 16.0.sp,
                            alignment: Alignment.center,
                          )
                        ],
                      );
                    } else {
                      ///Bottom Sheet For Pickup And DropOff locations (Search Container)
                      return CustomBottomSheet(
                        children: [
                          CustomText(
                            text: "Hi there,",
                            fontSize: 16.0.sp,
                          ),
                          CustomText(
                            text: "Where to?",
                            fontSize: 24.0.sp,
                          ),
                          SizedBox(height: 12.0.h),
                          Container(
                            padding: EdgeInsets.all(8.0.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0.r),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: BlocBuilder<GeoProvider, GeoStates>(
                                builder: (context, geoState) {
                              GeoProvider _geoProvider =
                                  BlocProvider.of<GeoProvider>(context);
                              return InkWell(
                                onTap: () async {
                                  var response =
                                      await Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    SearchDestinationScreen.screenId,
                                    (route) => true,
                                  );

                                  if (response == "ObtainedDetails") {
                                    await _geoProvider
                                        .getDestinationDirections(context);
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      size: 24.0.sp,
                                      color: primaryColor,
                                    ),
                                    SizedBox(width: 8.0.w),
                                    CustomText(
                                      text: "Search Drop Off",
                                      fontSize: 16.0.sp,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 12.0.h),
                          ListTile(
                            onTap: () {},
                            contentPadding: EdgeInsets.zero,
                            minVerticalPadding: 0.0,
                            leading: Icon(
                              Icons.home,
                              size: 28.0.sp,
                            ),
                            title: BlocBuilder<GeoProvider, GeoStates>(
                              builder: (context, geoState) {
                                final GeoProvider _geoProvider =
                                    BlocProvider.of<GeoProvider>(context,
                                        listen: true);
                                return CustomText(
                                  text: _geoProvider.pickUpLocation == null
                                      ? ""
                                      : _geoProvider
                                          .pickUpLocation!.formattedAddress!,
                                  fontSize: 16.0.sp,
                                );
                              },
                            ),
                            subtitle: CustomText(
                              text: "Your Living Home Address",
                              fontSize: 12.0.sp,
                              color: Colors.grey,
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                          ),
                          ListTile(
                            onTap: () {},
                            contentPadding: EdgeInsets.zero,
                            minVerticalPadding: 0.0,
                            leading: Icon(
                              Icons.work,
                              size: 28.0.sp,
                            ),
                            title: CustomText(
                              text: "Add Work",
                              fontSize: 16.0.sp,
                            ),
                            subtitle: CustomText(
                              text: "Your Office Address",
                              fontSize: 12.0.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                )
              ],
            );
          }
        },
      ),
    );
  }
}
