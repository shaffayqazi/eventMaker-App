// ignore_for_file: file_names, unused_local_variable, must_be_immutable, prefer_final_fields, unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/media.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DirectionPage extends StatefulWidget {
  final String? etitle;
  LatLng? lastLatLng;
  DirectionPage({Key? key, this.lastLatLng, this.etitle}) : super(key: key);

  @override
  State<DirectionPage> createState() => _DirectionPageState();
}

class _DirectionPageState extends State<DirectionPage> {
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  bool isLoading = false;
  CameraPosition? _kGooglePlex;
  late ColorNotifire notifire;

  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();

    if (widget.lastLatLng != null) {
      getCurrentMap(widget.lastLatLng!);
    }
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    markers = <Marker>{
      Marker(
        draggable: true,
        visible: true,
        markerId: MarkerId(widget.lastLatLng.toString()),
        position: widget.lastLatLng!,
        icon: pinLocationIcon = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 1000),
            'image/mapPin.png'),
        infoWindow: InfoWindow(title: widget.etitle.toString()),
      )
    };
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  Set<Marker> markers = {};
  BitmapDescriptor? pinLocationIcon;

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      body: Column(
        children: [
          SizedBox(height: height / 20),
          Row(
            children: [
              SizedBox(width: width / 40),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: notifire.getdarkscolor),
                    SizedBox(width: width / 80),
                    SizedBox(
                      width: Get.width * 0.80,
                      child: Text(
                        "Event Venue",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Gilroy Medium',
                            color: notifire.getdarkscolor),
                      ),
                    ),
                  ],
                ),
              ),
              // const Spacer(),
              // Icon(Icons.more_vert, color: notifire.getdarkscolor),
              // SizedBox(width: width / 20),
            ],
          ),
          SizedBox(height: Get.height * 0.02),
          Ink(
            height: Get.height * 0.90,
            child: GoogleMap(
              mapType: MapType.normal,
              markers: markers,
              scrollGesturesEnabled: true,
              liteModeEnabled: false,
              initialCameraPosition: _kGooglePlex ??
                  CameraPosition(target: widget.lastLatLng!, zoom: 18),
              onMapCreated: (GoogleMapController controller) {
                setState(() {});
                _controller.complete(controller);
                // setState(() {
                //   _markers.add(Marker(
                //     markerId: MarkerId(widget.lastLatLng.toString()),
                //     position: widget.lastLatLng!,
                //     icon: pinLocationIcon!,
                //   ));
                // });
              },
              onTap: (latLag) {
                setCustomMapPin();
                // markone();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getCurrentMap(LatLng latLng) async {
    setCustomMapPin();

    _kGooglePlex = CameraPosition(target: latLng, zoom: 18);
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 18.0)));
    setState(() {});

    getAddressFromLatLong(latLng);
  }

  Future<void> getAddressFromLatLong(LatLng latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      // controller.text = place.name.toString();
      // addressController.text = place.thoroughfare.toString();
      // landmarkController.text = place.subLocality.toString();
      // cityController.text = place.locality.toString();
      // stateController.text = place.administrativeArea.toString();
      // codeController.text = place.postalCode.toString();
      String country = place.country.toString();
      setState(() {});
    }
  }
}
