// this model for reverse geo coding and place details

class AddressModel {
  String? placeId;
  String? formattedAddress;
  double? lat;
  double? lng;
  List<AddressComponent> components = [];

  AddressModel({
    this.placeId,
    this.formattedAddress,
    this.lat,
    this.lng,
    required this.components,
  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    placeId = json["place_id"];
    formattedAddress = json["formatted_address"];
    lat = json["geometry"]["location"]["lat"];
    lng = json["geometry"]["location"]["lng"];
    for (var element in json["address_components"]) {
      components.add(AddressComponent.fromJson(element));
    }
  }

  Map<String, dynamic> toMap() => {
        "place_id": placeId,
        "formatted_address": formattedAddress,
        "address_components": components,
      };
}

class AddressComponent {
  String? longName;
  String? shortName;
  List<dynamic> types = [];

  AddressComponent({
    this.longName,
    this.shortName,
    required this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: json["types"],
      );

  Map<String, dynamic> toMap() => {
        "long_name": longName,
        "short_name": shortName,
        "types": types,
      };
}
