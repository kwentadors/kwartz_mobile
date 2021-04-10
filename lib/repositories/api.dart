import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:logging/logging.dart';

class ApiClient {
  final String hostname = "http://10.0.2.2:8000";
  final log = Logger("ApiClient");

  dynamic get({@required String path}) async {
    var response = await http.get("$hostname$path");

    return json.decode(response.body);
  }

  Future<Map<String, Object>> post({
    @required String path,
    Map<String, Object> body,
  }) async {
    String serializedContent = json.encode(body);
    var url = "$hostname$path";

    log.info("Sending request to $url with content: $serializedContent");
    var response = await http.post(
      url,
      headers: _requestHeaders(),
      body: serializedContent,
    );
    log.info(
        "Received request from $url with status ${response.statusCode} and content: ${response.body}");

    return json.decode(response.body);
  }

  Map<String, String> _requestHeaders() {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
  }
}
