import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart';
//
part 'location.g.dart';


@JsonSerializable()
class LatLng {
  LatLng({required this.lat,required this.lng});
  factory LatLng.fromJson(Map<String,dynamic> json) => _$LatLngFromJson(json);
  Map<String,dynamic> toJson() => _$LatLngToJson(this);

  final double lat;
  final double lng;
}

@JsonSerializable()
class Place{
  final String name;
  final double lat;
  final double lng;
  final int num;
  Place({required this.name,required this.lat,required this.lng,required this.num});

  factory Place.fromJson(Map<String,dynamic> json)=> _$PlaceFromJson(json);
  Map<String,dynamic> toJson() => _$PlaceToJson(this);
}
@JsonSerializable()
class Locations {
  Locations({required this.places});
  factory Locations.fromJson(Map<String,dynamic> json) => _$LocationsFromJson(json);
  Map<String,dynamic> toJson() => _$LocationsToJson(this);

  final List<Place> places;
}

Future<Locations> getGoogleOffices() async {
  const googleLocationsURL = 'https://4face.net/4face_appdated/app/main/nowon/test.json';
//  TODO: ここを弊社ファイルに変更する
  try{
    final response = await http.get(Uri.parse(googleLocationsURL));
    if(response.statusCode == 200){
      return Locations.fromJson(json.decode(response.body));
    }
  }catch(e){
    if (kDebugMode) {
      print(e);
    }
  }
  
  return Locations.fromJson(
    json.decode(await rootBundle.loadString('https://about.google/static/data/locations.json'))
  );

}

