import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_app/core/geo_provider/geo_provider.dart';
import 'package:rider_app/core/geo_provider/geo_states.dart';
import 'package:rider_app/helper/constants.dart';
import 'package:rider_app/view/widgets/custom_text.dart';

class SearchDestinationScreen extends StatelessWidget {
  SearchDestinationScreen({Key? key}) : super(key: key);

  static const String screenId = "/SearchDestinationScreen";

  final TextEditingController pickUpController = TextEditingController();
  final TextEditingController dropOffController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("Search Screen Rebuilt");
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 42.0.h,
            horizontal: 16.0.w,
          ),
          child: Column(
            children: [
              /// set drop off
              Container(
                height: 175.0.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    /// title
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 24.0.sp,
                          ),
                        ),
                        SizedBox(width: 105.0.w),
                        CustomText(
                          text: "Set drop off",
                          fontSize: 18.0.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0.h),

                    ///drop off
                    BlocBuilder<GeoProvider, GeoStates>(
                      builder: (context, geoState) {
                        GeoProvider _geoProvider =
                            BlocProvider.of<GeoProvider>(context, listen: true);
                        String from =
                            _geoProvider.pickUpLocation!.formattedAddress != null
                                ? _geoProvider.pickUpLocation!.formattedAddress!
                                : "";
                        pickUpController.text = from;
                        return SearchField(
                          image: "assets/images/pickicon.png",
                          controller: pickUpController,
                          hintText: "From",
                        );
                      },
                    ),
                    SizedBox(height: 16.0.h),

                    /// destination
                    BlocBuilder<GeoProvider, GeoStates>(
                        builder: (context, geoState) {
                      GeoProvider _geoProvider =
                          BlocProvider.of<GeoProvider>(context);
                      return SearchField(
                        image: "assets/images/desticon.png",
                        controller: dropOffController,
                        hintText: "Where to?",
                        onChanged: (value) {
                          if (value.length % 2 == 0) {
                            _geoProvider.getDestinationBySearch(value);
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),

              /// list of predictions
              Expanded(
                child: BlocBuilder<GeoProvider, GeoStates>(
                  builder: (context, geoState) {
                    GeoProvider _geoProvider =
                        BlocProvider.of<GeoProvider>(context, listen: true);
                    return _geoProvider.searchedPlacesModel != null
                        ? ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) =>
                                PredictionItem(index: index),
                            separatorBuilder: (context, index) =>
                                const Divider(color: Colors.black38),
                            itemCount: _geoProvider
                                .searchedPlacesModel!.predictions.length,
                          )
                        : const SizedBox();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final String image;
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const SearchField({
    Key? key,
    required this.image,
    required this.controller,
    required this.hintText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(image, height: 28.0.h),
        SizedBox(width: 12.0.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(6.0.w),
            height: 52.0.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.0.r),
            ),
            child: TextFormField(
              controller: controller,
              cursorColor: primaryColor,
              decoration: InputDecoration(
                filled: true,
                isDense: true,
                fillColor: Colors.grey.shade100,
                border: InputBorder.none,
                hintText: hintText,
              ),
              onChanged: onChanged,
            ),
          ),
        )
      ],
    );
  }
}

class PredictionItem extends StatelessWidget {
  int index;

  PredictionItem({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return BlocBuilder<GeoProvider, GeoStates>(
      builder: (context, geoState) {
        GeoProvider _geoProvider =
            BlocProvider.of<GeoProvider>(context, listen: true);
        return ListTile(
          onTap: () {
            _geoProvider.getDestinationDetails(
               ctx,
              _geoProvider.searchedPlacesModel!.predictions[index].placeId!,
            );
          },
          contentPadding: EdgeInsets.zero,
          dense: true,
          horizontalTitleGap: 0.0,
          leading: Icon(
            Icons.add_location,
            size: 32.0.sp,
          ),
          title: CustomText(
            text:
                _geoProvider.searchedPlacesModel!.predictions[index].mainText!,
            fontSize: 18.0.sp,
          ),
          subtitle: CustomText(
            text: _geoProvider
                .searchedPlacesModel!.predictions[index].secondaryText!,
            fontSize: 14.0.sp,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
