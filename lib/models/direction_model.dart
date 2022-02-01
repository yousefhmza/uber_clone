class DirectionModel {
  String? encodedPoints;
  String? distanceText;
  int? distanceValue;
  String? durationText;
  int? durationValue;

  DirectionModel({
    this.encodedPoints,
    this.distanceText,
    this.distanceValue,
    this.durationText,
    this.durationValue,
  });

  DirectionModel.fromJson(Map<String, dynamic> json){
    encodedPoints = json["routes"][0]["overview_polyline"]["points"];
    distanceText = json["routes"][0]["legs"][0]["distance"]["text"];
    distanceValue = json["routes"][0]["legs"][0]["distance"]["value"];
    durationText = json["routes"][0]["legs"][0]["duration"]["text"];
    durationValue = json["routes"][0]["legs"][0]["duration"]["value"];
  }
}
