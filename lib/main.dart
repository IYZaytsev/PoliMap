import "dart:core";
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:location/location.dart';
import 'package:loading/loading.dart';
import 'src/counties.dart' as counties;
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;



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
  Set<Polygon> pset = Set();
  List  something = ['Alamance', 'Alexander', 'Alleghany', 'Anson', 'Ashe', 'Avery', 'Beaufort', 'Bertie', 'Bladen', 'Brunswick', 'Buncombe', 'Burke', 'Cabarrus', 'Caldwell', 'Camden', 'Carteret', 'Caswell', 'Catawba', 'Chatham', 'Cherokee', 'Chowan', 'Clay', 'Cleveland', 'Columbus', 'Craven', 'Cumberland', 'Currituck', 'Dare', 'Davidson', 'Davie', 'Duplin', 'Durham', 'Edgecombe', 'Forsyth', 'Franklin', 'Gaston', 'Gates', 'Graham', 'Granville', 'Greene', 'Guilford', 'Halifax', 'Harnett', 'Haywood', 'Henderson', 'Hertford', 'Hoke', 'Hyde', 'Iredell', 'Jackson', 'Johnston', 'Jones', 'Lee', 'Lenoir', 'Lincoln', 'McDowell', 'Macon', 'Madison', 'Martin', 'Mecklenburg', 'Mitchell', 'Montgomery', 'Moore', 'Nash', 'New_Hanover', 'Northampton', 'Onslow', 'Orange', 'Pamlico', 'Pasquotank', 'Pender', 'Perquimans', 'Person', 'Pitt', 'Polk', 'Randolph', 'Richmond', 'Robeson', 'Rockingham', 'Rowan', 'Rutherford', 'Sampson', 'Scotland', 'Stanly', 'Stokes', 'Surry', 'Swain', 'Transylvania', 'Tyrrell', 'Union', 'Vance', 'Wake', 'Warren', 'Washington', 'Watauga', 'Wayne', 'Wilkes', 'Wilson', 'Yadkin', 'Yancey'];
  
  void _onMapCreated(GoogleMapController controller) {
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
        title: Text('PoliMap'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder<LatLng>(
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
                      polygons: Set<Polygon>.of(<Polygon>[
                        /* Polygon(
                            polygonId: PolygonId('area'),
                            points: meklenburg,
                            geodesic: true,
                            strokeColor: Colors.blue,
                            fillColor: Colors.lightBlue.withOpacity(0.1),
                            visible: true)
                            */
                      ]),
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: snapshot.data,
                        zoom: 11.0,
                      ));
              }
              return null; // unreachable
            },
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: FloatingActionButton(
                    onPressed: () {
                      counties.Counties countiesJson = new counties.Counties();
                      print("wowowowoowowowowowo");
                      countiesJson.getMapmarkers();
                    },
                  ))),
        ],
      ),
    ));
  }
}


