import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class HtpResponce {
  String url;
  HtpResponce(String url) {
    this.url = url;
  }

  Future<Map> getData() async {
    Response response = await get(url);
    Map<String, String> headers = response.headers;
    String json = response.body;
    Map<String, dynamic> respons = jsonDecode(json);
    return respons;
  }
}
