import 'package:google_maps_flutter/google_maps_flutter.dart';
import "dart:math" as math;
class MapMath{

  bool rayCrossesSegment(LatLng point, LatLng a, LatLng b) {
    const double infinity = 1.0 / 0.0;
    var px = point.longitude,
        py = point.latitude,
        ax = a.longitude,
        ay = a.latitude,
        bx = b.longitude,
        by = b.latitude;

    if (ay > by) {
      ax = b.longitude;
      ay = b.latitude;
      bx = a.longitude;
      by = a.latitude;
    }
    if (px < 0) {
      px += 360;
    }
    if (ax < 0) {
      ax += 360;
    }
    if (bx < 0) {
      bx += 360;
    }

    if (py == ay || py == by) py += 0.00000001;
    if ((py > by || py < ay) || (px > math.max(ax, bx))) return false;
    if (px < math.min(ax, bx)) return true;

    var red = (ax != bx) ? ((by - ay) / (bx - ax)) : infinity;
    var blue = (ax != px) ? ((py - ay) / (px - ax)) : infinity;
    return (blue >= red);
  }

  bool doesContain(LatLng point, List<LatLng> bounds) {
    var crossings = 0;

    for (int i = 0; i < bounds.length; i++) {
      var a = bounds[i];
      var j = i + 1;
      if (j >= bounds.length) {
        j = 0;
      }
      var b = bounds[j];
      if (rayCrossesSegment(point, a, b)) {
        crossings++;
      }
    }
    return (crossings % 2 == 1);
  }
}