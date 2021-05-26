import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:logging/logging.dart';

class ApiClient {
  final hostname = "http://kwartz.herokuapp.com";
  final _logger = Logger("ApiClient");

  dynamic get({@required String path}) async {
    final url = "$hostname$path";
    _logger.info("Sending request to $url");
    final response = await http.get(url);
    _logResponse(response);

    return json.decode(response.body);
  }

  Future<Map<String, Object>> post({
    @required String path,
    Map<String, Object> body,
  }) async {
    String serializedContent = json.encode(body);
    final url = "$hostname$path";

    _logger.info("Sending request to $url with content: $serializedContent");
    final response = await http.post(
      url,
      headers: _requestHeaders(),
      body: serializedContent,
    );
    _logResponse(response);

    return json.decode(response.body);
  }

  void _logResponse(response) {
    _logger.info(
        "Received request from ${response.request.url} with status ${response.statusCode} and content: ${response.body}");
  }

  Map<String, String> _requestHeaders() {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
  }
}
