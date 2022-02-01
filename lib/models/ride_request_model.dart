class RideRequestModel {
  final String driverId;
  final String paymentMethod;
  final Map<String, String> pickUpLocationData;
  final Map<String, String> dropOffLocationData;
  final String createdAt;
  final String riderName;
  final String riderPhone;
  final String pickUpAddress;
  final String dropOffAddress;

  RideRequestModel({
    required this.driverId,
    required this.paymentMethod,
    required this.pickUpLocationData,
    required this.dropOffLocationData,
    required this.createdAt,
    required this.riderName,
    required this.riderPhone,
    required this.pickUpAddress,
    required this.dropOffAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      "driver_id": driverId,
      "payment_method": paymentMethod,
      "pick_up": pickUpLocationData,
      "drop_off": dropOffLocationData,
      "created_at": createdAt,
      "rider_name": riderName,
      "rider_phone": riderPhone,
      "pickup_address": pickUpAddress,
      "dropoff_address": dropOffAddress,
    };
  }
}
