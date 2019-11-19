import "dart:core";
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:location/location.dart';
import 'package:loading/loading.dart';
import 'src/counties.dart' as counties;
import 'src/candidates.dart' as candidates;
import 'dart:async' show Future;
import 'package:async/async.dart';

void main() => runApp(new MaterialApp(home: new MyApp()));

enum Answer { YES, NO, MAYBE }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double currentZoom = 0;
  LatLng visiableCenter;
  String govScope = "";
  String _answer = "";
  void setAnswer(String value) {
    setState(() {
      _answer = value;
    });
  }

  Future<Null> _askUser(BuildContext context) async {
    switch (await showDialog(
        context: context,
        child: new SimpleDialog(
          title: Text("test"),
          children: <Widget>[
            new SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Answer.YES);
              },
              child: const Text("Yes"),
            )
          ],
        ))) {
      case Answer.YES:
        setAnswer('Yes');
        break;
    }
  }

  final AsyncMemoizer _memoizer = AsyncMemoizer();
  final AsyncMemoizer _memoizer2 = AsyncMemoizer();
  GoogleMapController mapController;
  LatLng _center = LatLng(0, 0);
  Set<Polygon> pset = Set();
  List<LatLng> points = [];
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

  void _onGeoChanged(CameraPosition position) {
    setState(() {
      visiableCenter = position.target;
      currentZoom = position.zoom;
      if (currentZoom > 11) {
        setState(() {
          govScope = "City";
        });
      }

      if (currentZoom > 9  && currentZoom < 11) {
        setState(() {
          govScope = "County";
        });
      }

      if (currentZoom < 9) {
        setState(() {
          govScope = "State";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("PoliMap"),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder(
              future: this._getMapMarkerMemorize(),
              builder: (BuildContext context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Container(
                        color: Colors.lightBlue,
                        child: Center(
                          child: Loading(
                              indicator: BallBeatIndicator(), size: 100.0),
                        ));
                  case ConnectionState.done:
                    for (final location in snapshot.data.counties) {
                      List<LatLng> points = [];
                      for (final p in location.coordinates) {
                        points.add(LatLng(p.lat, p.lng));
                      }
                      Polygon polyGon = Polygon(
                          polygonId: PolygonId(location.countyName),
                          points: points,
                          geodesic: true,
                          strokeColor: Colors.blue,
                          fillColor: Colors.lightBlue.withOpacity(0.1),
                          visible: true);
                      pset.add(polyGon);
                    }
                    return FutureBuilder(
                      future: this._getLocationMemorize(),
                      builder: (BuildContext context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Text("Tap to Start");
                          case ConnectionState.active:
                          case ConnectionState.waiting:
                            return Container(
                                color: Colors.lightBlue,
                                child: Center(
                                  child: Loading(
                                      indicator: BallBeatIndicator(),
                                      size: 100.0),
                                ));
                          case ConnectionState.done:
                            if (snapshot.hasError)
                              return Text('Error: ${snapshot.error}');
                            return new GoogleMap(
                              onMapCreated: _onMapCreated,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              polygons: pset,
                              initialCameraPosition: CameraPosition(
                                target: snapshot.data,
                                zoom: 11.0,
                              ),
                              onCameraMove: _onGeoChanged,
                            );
                        }
                        return null; // unreachable
                      },
                    );
                }
              }),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      width: 400.0,
                      height: 100.0,
                      child: new MaterialButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Colors.blue,
                        child: Text(
                          govScope,
                          textScaleFactor: 5,
                        ),
                        onPressed: () {
                          _askUser(context);
                        },
                      )))),
        ],
      ),
    ));
  }

  _getLocationMemorize() {
    return this._memoizer.runOnce(() async {
      LatLng intialPosition = await _getLocation();
      return intialPosition;
    });
  }

  _getMapMarkerMemorize() {
    return this._memoizer2.runOnce(() async {
      counties.Locations countyLines = await counties.Counties.getMapmarkers();
      return countyLines;
    });
  }
}
