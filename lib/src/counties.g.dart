// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatLng $LatLngFromJson(Map<String, dynamic> json) {
  return LatLng(
    lat: (json['lat'] as num)?.toDouble(),
    lng: (json['lng'] as num)?.toDouble(),
  );
}

Map<String, dynamic> $LatLngToJson(LatLng instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

County $CountyFromJson(Map<String, dynamic> json) {
  return County(
    countyName: json['countyName'] as String,
    coordinates: (json['coordinates'] as List)
        ?.map((e) =>
            e == null ? null : LatLng.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> $CountyToJson(County instance) => <String, dynamic>{
      'countyName': instance.countyName,
      'coordinates': instance.coordinates,
    };

Locations $LocationsFromJson(Map<String, dynamic> json) {
  return Locations(
    counties: (json['counties'] as List)
        ?.map((e) =>
            e == null ? null : County.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> $LocationsToJson(Locations instance) => <String, dynamic>{
      'counties': instance.counties,
    };
