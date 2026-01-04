import 'dart:convert';
import 'dart:io';

import 'package:bhakharamart/data/network/base_api_services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../app_exception.dart';

class NetworkApiServices extends BaseApiServices {

  // =========================
  // GET
  // =========================
  @override
  Future<dynamic> getApi(String url) async {
    dynamic responseJson;
    try {
      final response = await http
          .get(
        Uri.parse(url),
        headers: _defaultHeaders(),
      )
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetErrorException("No Internet Connection");
    }
    return responseJson;
  }

  // =========================
  // POST  ✅ (MOST IMPORTANT)
  // =========================
  @override
  Future<dynamic> postApi(String url, Map<String, dynamic> body) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
        Uri.parse(url),
        headers: _defaultHeaders(),
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 10));

      print('Response body: ${response.body}');

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetErrorException("No Internet Connection");
    }
    return responseJson;
  }

  // =========================
  // PUT
  // =========================
  @override
  Future<dynamic> putApi(String url, Map<String, dynamic> body) async {
    dynamic responseJson;
    try {
      final response = await http
          .put(
        Uri.parse(url),
        headers: _defaultHeaders(),
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetErrorException("No Internet Connection");
    }
    return responseJson;
  }

  // =========================
  // PATCH
  // =========================
  @override
  Future<dynamic> patchApi(String url, Map<String, dynamic> body) async {
    dynamic responseJson;
    try {
      final response = await http
          .patch(
        Uri.parse(url),
        headers: _defaultHeaders(),
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetErrorException("No Internet Connection");
    }
    return responseJson;
  }

  // =========================
  // DELETE
  // =========================
  @override
  Future<dynamic> deleteApi(String url, Map<String, dynamic> body) async {
    dynamic responseJson;
    try {
      final response = await http
          .delete(
        Uri.parse(url),
        headers: _defaultHeaders(),
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetErrorException("No Internet Connection");
    }
    return responseJson;
  }

  // =========================
  // DOWNLOAD (NOT USED YET)
  // =========================
  @override
  Future<dynamic> downloadApi(String url) async {
    throw UnimplementedError("downloadApi not implemented yet");
  }

  @override
  Future<dynamic> downloadFile(String url, String path) async {
    throw UnimplementedError("downloadFile not implemented yet");
  }

  @override
  Future<dynamic> downloadImage(String url, String path) async {
    throw UnimplementedError("downloadImage not implemented yet");
  }

  @override
  Future<dynamic> downloadPdf(String url, String path) async {
    throw UnimplementedError("downloadPdf not implemented yet");
  }

  // =========================
  // UPLOAD (MULTIPART – FUTURE)
  // =========================
  @override
  Future<dynamic> uploadApi(
      String url, Map<String, dynamic> body, List<File> files) async {
    throw UnimplementedError("uploadApi not implemented yet");
  }

  // =========================
  // HEADERS (CENTRAL PLACE)
  // =========================
  Map<String, String> _defaultHeaders() {
    // Get token from storage
    final box = GetStorage();
    final token = box.read('token') ?? box.read('access_token');
    print('Token: $token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}

// =========================
// RESPONSE HANDLER
// =========================
dynamic returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
    case 201:
      return jsonDecode(response.body);

    case 400:
      throw BadRequestException(response.body);

    case 401:
    case 403:
      throw UnauthorizedException(response.body);

    case 404:
      throw NotFoundException(response.body);

    case 500:
      throw ServerException(response.body);

    default:
      throw FetchDataException(
        "Error occurred with status code ${response.statusCode}",
      );
  }
}
