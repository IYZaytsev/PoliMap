// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Geometry _$GeometryFromJson(Map<String, dynamic> json) {
  return Geometry(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List)
          ?.map(
              (e) => (e as List)?.map((e) => (e as num)?.toDouble())?.toList())
          ?.toList());
}

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates
    };

Properties _$PropertiesFromJson(Map<String, dynamic> json) {
  return Properties(county: json['county'] as String);
}

Map<String, dynamic> _$PropertiesToJson(Properties instance) =>
    <String, dynamic>{'county': instance.county};

Feature _$FeatureFromJson(Map<String, dynamic> json) {
  return Feature(
      type: json['type'] as String,
      geometry: json['geometry'] == null
          ? null
          : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      properties: json['properties'] == null
          ? null
          : Properties.fromJson(json['properties'] as Map<String, dynamic>));
}

Map<String, dynamic> _$FeatureToJson(Feature instance) => <String, dynamic>{
      'type': instance.type,
      'geometry': instance.geometry,
      'properties': instance.properties
    };

Features _$FeaturesFromJson(Map<String, dynamic> json) {
  return Features(
      features: (json['features'] as List)
          ?.map((e) =>
              e == null ? null : Feature.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$FeaturesToJson(Features instance) =>
    <String, dynamic>{'features': instance.features};
