import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:logging/logging.dart';

class ApiClient {
  final String hostname = "http://10.0.2.2:8000";
  final log = Logger("ApiClient");

  Future<Map<String, Object>> post({
    @required String path,
    Map<String, Object> body,
  }) async {
    String serializedContent = json.encode(body);
    var url = "$hostname$path";

    log.fine("Sending request to $url with content: $serializedContent");
    var response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: serializedContent,
    );

    return json.decode(response.body);
  }
}
