class SearchedPlacesModel {
  String? status;
  List<PredictionModel> predictions = [];

  SearchedPlacesModel({
    required this.status,
    required this.predictions,
  });

  SearchedPlacesModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    for (var element in json["predictions"]) {
      predictions.add(PredictionModel.fromJson(element));
    }
  }
}

class PredictionModel {
  String? placeId;
  String? mainText;
  String? secondaryText;

  PredictionModel({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
  });

  PredictionModel.fromJson(Map<String, dynamic> json) {
    placeId = json["place_id"];
    mainText = json["structured_formatting"]["main_text"];
    secondaryText = json["structured_formatting"]["secondary_text"];
  }
}
