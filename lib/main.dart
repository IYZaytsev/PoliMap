import "dart:core";
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:location/location.dart';
import 'package:loading/loading.dart';
import 'src/counties.dart' as counties;
import 'src/candidates.dart' as candidates;
import 'dart:async' show Future;

void main() => runApp(new MaterialApp(home: new MyApp()));

enum Answer{YES,NO,MAYBE}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double currentZoom = 0;
  LatLng visiableCenter;

  String _answer = "";
  void setAnswer(String value){
    setState(() {
      _answer = value;
    });
  }

Future<Null> _askUser(BuildContext context) async{
  switch(await showDialog(
    context: context,
    child: new SimpleDialog(
      title: Text("test"),
      children: <Widget>[
        new SimpleDialogOption(
          onPressed: (){Navigator.pop(context,Answer.YES);},
          child: const Text("Yes"),
        )
      ],

    )
  ))
  {
    case Answer.YES:
    setAnswer('Yes');
    break;
  }
 

}


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
    visiableCenter = position.target;
    currentZoom = position.zoom;
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
          FutureBuilder<counties.Locations>(
              future: counties.Counties.getMapmarkers(),
              builder: (BuildContext context,
                  AsyncSnapshot<counties.Locations> snapshot) {
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
                    return FutureBuilder<LatLng>(
                      future: _getLocation(),
                      builder: (BuildContext context,
                          AsyncSnapshot<LatLng> snapshot) {
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
                  child: FloatingActionButton(
                    onPressed: () {
                    _askUser(context);
                    },
                  ))),
        ],
      ),
    ));
  }
}
