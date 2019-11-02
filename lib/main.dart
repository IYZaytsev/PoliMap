import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:location/location.dart';
import 'package:loading/loading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController mapController;

  LatLng _center = LatLng(0, 0);

  void _onMapCreated(GoogleMapController controller) {
    print(_center);
    mapController = controller;
  }

  Future<LatLng> _getLocation() async {
    LocationData currentLocation;

    var location = new Location();
    try {
      currentLocation = await location.getLocation();

      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      return LatLng(currentLocation.latitude, currentLocation.longitude);
    } on Exception {
      currentLocation = null;
    }
    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  Widget initializeMap(LatLng _center) {
    return new GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Duke_Hack'),
            backgroundColor: Colors.green[700],
          ),
          body: FutureBuilder<LatLng>(
            future: _getLocation(),
            builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text("Tap to Start");
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Container(
                      color: Colors.lightBlue,
                      child: Center(
                        child: Loading(
                            indicator: BallBeatIndicator(), size: 100.0),
                      ));
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  return new GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: snapshot.data,
                        zoom: 11.0,
                      ));
              }
              return null; // unreachable
            },
          )),
    );
  }
}
