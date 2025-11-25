import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? myLocation;
  BitmapDescriptor? customIcon;

  @override
  void initState() {
    super.initState();
    loadCustomMarker();
    getUserLocation();
  }

  void loadCustomMarker() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/custom_pin.png',
    );
  }

  void getUserLocation() async {
    Location location = Location();
    await location.requestPermission();
    var data = await location.getLocation();

    setState(() {
      myLocation = LatLng(data.latitude!, data.longitude!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: myLocation!,
                zoom: 16,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('me'),
                  position: myLocation!,
                  icon: customIcon ?? BitmapDescriptor.defaultMarker,
                ),
              },
            ),
    );
  }
}