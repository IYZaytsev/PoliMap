import "dart:core";
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

  static List<LatLng> meklenburg = [
    LatLng(35.43838, -80.76369),
    LatLng(35.43751, -80.76328),
    LatLng(35.42732, -80.75836),
    LatLng(35.41224, -80.76369),
    LatLng(35.40018, -80.76418),
    LatLng(35.37848, -80.74142),
    LatLng(35.37197, -80.73273),
    LatLng(35.36152, -80.71772),
    LatLng(35.35295, -80.70459),
    LatLng(35.34677, -80.69359),
    LatLng(35.3265, -80.68647),
    LatLng(35.30323, -80.67884),
    LatLng(35.28827, -80.67381),
    LatLng(35.271, -80.66793),
    LatLng(35.2624, -80.65556),
    LatLng(35.2508, -80.63217),
    LatLng(35.24545, -80.62186),
    LatLng(35.23405, -80.5998),
    LatLng(35.22456, -80.58192),
    LatLng(35.21768, -80.56837),
    LatLng(35.21171, -80.55654),
    LatLng(35.20838, -80.5503),
    LatLng(35.20793, -80.55086),
    LatLng(35.14913, -80.62413),
    LatLng(35.11427, -80.66775),
    LatLng(35.08098, -80.70943),
    LatLng(35.05689, -80.74056),
    LatLng(35.03438, -80.77109),
    LatLng(35.03318, -80.77321),
    LatLng(35.03296, -80.77611),
    LatLng(35.03242, -80.77896),
    LatLng(35.03355, -80.78129),
    LatLng(35.03268, -80.78341),
    LatLng(35.03171, -80.78792),
    LatLng(35.03005, -80.79279),
    LatLng(35.03011, -80.79664),
    LatLng(35.0291, -80.79897),
    LatLng(35.0281, -80.80193),
    LatLng(35.02655, -80.80555),
    LatLng(35.02483, -80.80638),
    LatLng(35.02337, -80.80811),
    LatLng(35.0217, -80.81109),
    LatLng(35.02043, -80.81478),
    LatLng(35.01747, -80.82047),
    LatLng(35.01446, -80.82292),
    LatLng(35.00927, -80.83044),
    LatLng(35.00641, -80.83578),
    LatLng(35.00173, -80.8403),
    LatLng(35.00171, -80.8403),
    LatLng(35.00309, -80.84148),
    LatLng(35.00805, -80.84576),
    LatLng(35.01459, -80.85141),
    LatLng(35.01499, -80.85177),
    LatLng(35.0164, -80.85297),
    LatLng(35.01836, -80.85467),
    LatLng(35.02394, -80.85949),
    LatLng(35.03, -80.86473),
    LatLng(35.03677, -80.87058),
    LatLng(35.04067, -80.87395),
    LatLng(35.0417, -80.87479),
    LatLng(35.0435, -80.87634),
    LatLng(35.04695, -80.87928),
    LatLng(35.05145, -80.88312),
    LatLng(35.05214, -80.88372),
    LatLng(35.05254, -80.88406),
    LatLng(35.05294, -80.8844),
    LatLng(35.05315, -80.88458),
    LatLng(35.05402, -80.88534),
    LatLng(35.05662, -80.88766),
    LatLng(35.06177, -80.89241),
    LatLng(35.06743, -80.89798),
    LatLng(35.07419, -80.90406),
    LatLng(35.0763, -80.90596),
    LatLng(35.07652, -80.9062),
    LatLng(35.07664, -80.90638),
    LatLng(35.07667, -80.90641),
    LatLng(35.0768, -80.90654),
    LatLng(35.08158, -80.91099),
    LatLng(35.09162, -80.9203),
    LatLng(35.10323, -80.93106),
    LatLng(35.1056, -80.93326),
    LatLng(35.10112, -80.94452),
    LatLng(35.09264, -80.95787),
    LatLng(35.07564, -80.98758),
    LatLng(35.06981, -80.99764),
    LatLng(35.06275, -81.0103),
    LatLng(35.05897, -81.0165),
    LatLng(35.05272, -81.0273),
    LatLng(35.04856, -81.03459),
    LatLng(35.05128, -81.04658),
    LatLng(35.06239, -81.05763),
    LatLng(35.07512, -81.05797),
    LatLng(35.08095, -81.0567),
    LatLng(35.08739, -81.05676),
    LatLng(35.09373, -81.05289),
    LatLng(35.10062, -81.04652),
    LatLng(35.10321, -81.03616),
    LatLng(35.11251, -81.03268),
    LatLng(35.12111, -81.03628),
    LatLng(35.12743, -81.04138),
    LatLng(35.13468, -81.05104),
    LatLng(35.14869, -81.03414),
    LatLng(35.14868, -81.03319),
    LatLng(35.15292, -81.00953),
    LatLng(35.17623, -81.00241),
    LatLng(35.17918, -81.00214),
    LatLng(35.20433, -81.00573),
    LatLng(35.22124, -81.01421),
    LatLng(35.24594, -81.00888),
    LatLng(35.25769, -81.01379),
    LatLng(35.26803, -81.01514),
    LatLng(35.28246, -81.00859),
    LatLng(35.29702, -81.00415),
    LatLng(35.30487, -81.00116),
    LatLng(35.31648, -80.99207),
    LatLng(35.33238, -80.98141),
    LatLng(35.34291, -80.98026),
    LatLng(35.35032, -80.97273),
    LatLng(35.34754, -80.96103),
    LatLng(35.35184, -80.94117),
    LatLng(35.35862, -80.92438),
    LatLng(35.36289, -80.92898),
    LatLng(35.36601, -80.94797),
    LatLng(35.37489, -80.95819),
    LatLng(35.36834, -80.96817),
    LatLng(35.36877, -80.98408),
    LatLng(35.38156, -80.98174),
    LatLng(35.38932, -80.96289),
    LatLng(35.40015, -80.95487),
    LatLng(35.40083, -80.95539),
    LatLng(35.40116, -80.95554),
    LatLng(35.40946, -80.95832),
    LatLng(35.41737, -80.95648),
    LatLng(35.42229, -80.95531),
    LatLng(35.42357, -80.95552),
    LatLng(35.4273, -80.95653),
    LatLng(35.42857, -80.95696),
    LatLng(35.43331, -80.95847),
    LatLng(35.43807, -80.95603),
    LatLng(35.44227, -80.95292),
    LatLng(35.44766, -80.95018),
    LatLng(35.44955, -80.94641),
    LatLng(35.45063, -80.94539),
    LatLng(35.45342, -80.94274),
    LatLng(35.45682, -80.94242),
    LatLng(35.45937, -80.94325),
    LatLng(35.46014, -80.94401),
    LatLng(35.46208, -80.94658),
    LatLng(35.46418, -80.94952),
    LatLng(35.46653, -80.95133),
    LatLng(35.47207, -80.95091),
    LatLng(35.47772, -80.94855),
    LatLng(35.48078, -80.94778),
    LatLng(35.48383, -80.94523),
    LatLng(35.48495, -80.94565),
    LatLng(35.48723, -80.94685),
    LatLng(35.4877, -80.94703),
    LatLng(35.49251, -80.9405),
    LatLng(35.49557, -80.93634),
    LatLng(35.50013, -80.93015),
    LatLng(35.50893, -80.91821),
    LatLng(35.51474, -80.91032),
    LatLng(35.51493, -80.91007),
    LatLng(35.5151, -80.90982),
    LatLng(35.5137, -80.89067),
    LatLng(35.5125, -80.8748),
    LatLng(35.51183, -80.86604),
    LatLng(35.5118, -80.86565),
    LatLng(35.51177, -80.8652),
    LatLng(35.51153, -80.86195),
    LatLng(35.51139, -80.86022),
    LatLng(35.51106, -80.85579),
    LatLng(35.51085, -80.85292),
    LatLng(35.5103, -80.84531),
    LatLng(35.50995, -80.84049),
    LatLng(35.50986, -80.83929),
    LatLng(35.50947, -80.83392),
    LatLng(35.50874, -80.82389),
    LatLng(35.50811, -80.81522),
    LatLng(35.50785, -80.8116),
    LatLng(35.5071, -80.80127),
    LatLng(35.50709, -80.79648),
    LatLng(35.50709, -80.78786),
    LatLng(35.50584, -80.78434),
    LatLng(35.48469, -80.78266),
    LatLng(35.47222, -80.77938),
    LatLng(35.46757, -80.77611),
    LatLng(35.464, -80.7741),
    LatLng(35.46094, -80.77371)
  ];
  static PolygonId meck = PolygonId("meck");
  Set<Polygon> pset = Set();
  Polygon pgon = Polygon(
      polygonId: meck,
      points: meklenburg,
      fillColor: Colors.black,
      visible: true);

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
        title: Text('Duke_Hack'),
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
                  print("Length Before Before Before :<(" +
                      pset.length.toString());
                  pset.add(pgon);
                  print("Length of the shit please work :<(" +
                      pset.length.toString());
                  return new GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      polygons: Set<Polygon>.of(<Polygon>[
                        Polygon(
                            polygonId: PolygonId('area'),
                            points: meklenburg,
                            geodesic: true,
                            strokeColor: Colors.blue,
                            fillColor: Colors.lightBlue.withOpacity(0.1),
                            visible: true)
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
                      print("wowowowoowowowowowo");
                    },
                  ))),
        ],
      ),
    ));
  }
}
