import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:rider_app/helper/components.dart';

class HttpHelper {
  static Future<dynamic> getData(String urlLink) async {
    Uri url = Uri.parse(urlLink);
    try {
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        String responseBody = response.body;
        var decodedData = jsonDecode(responseBody);
        return decodedData;
      } else {
        showToast(
          "Failed, Please check your internet connection.",
          error: true,
        );
        return "Failed";
      }
    } catch (e) {
      showToast("Failed, Please check your internet connection.", error: true);
      return "Failed";
    }
  }
}
