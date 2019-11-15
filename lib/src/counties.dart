import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';


part 'counties.g.dart';

@JsonSerializable()
class Geometry{

  Geometry({
    this.coordinates,
    this.type,
  });
    factory Geometry.fromJson(Map<String, dynamic> json) =>
    _$GeometryFromJson(json);
    Map<String, dynamic> toJson() => _$GeometryToJson(this);


    final List<List<double>> coordinates;
    final String type;

}
@JsonSerializable()
class Properties{

     Properties({
    this.county,
  });
    factory Properties.fromJson(Map<String, dynamic> json) =>
    _$PropertiesFromJson(json);
    Map<String, dynamic> toJson() => _$PropertiesToJson(this);
    final String county;

}
@JsonSerializable()
class Feature{

    Feature({
    this.geometry,
    this.properties,
    this.type,
  });
    factory Feature.fromJson(Map<String, dynamic> json) =>
    _$FeatureFromJson(json);
    Map<String, dynamic> toJson() => _$FeatureToJson(this);
    
    final Geometry geometry;
    final Properties properties;
    final String type;
}

@JsonSerializable()
class Features {

Features({this.features,});

  factory Features.fromJson(Map<String, dynamic> json) =>
    _$FeaturesFromJson(json);
Map<String, dynamic> toJson() => _$FeaturesToJson(this);

final List<Feature> features;

}

Future<String> _loadMapAsset() async {
  return await rootBundle.loadString('assets/GeoObs.json');
}

class Counties{
  Features results;
  getMapmarkers()async{
  String stringJson = await _loadMapAsset();
  var jsonData = json.decode(stringJson);
  results = new Features.fromJson(jsonData);
  print("loading done printing length of files ..................................................................................................................................");
  print(results.features.length);
  }

}
