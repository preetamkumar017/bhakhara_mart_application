import 'dart:convert';
import 'dart:io';

import 'package:bhakharamart/data/network/base_api_services.dart';
import 'package:http/http.dart' as http;

import '../app_exception.dart';

class NetworkApiServices extends BaseApiServices{


  @override
  Future<dynamic> getApi(String url) async {
    dynamic responseJson;
    try{
      final response = await http.get(Uri.parse(url)).timeout(
          const Duration(seconds: 10));

      responseJson = returnResponse(response);

    }on SocketException{
      throw InternetErrorException("");
    }
    return responseJson;
  }

  @override
  Future<dynamic> patchApi(String url, Map<String, dynamic> body) {
    // TODO: implement patchApi
    throw UnimplementedError();
  }

  @override
  Future<dynamic> postApi(String url, Map<String, dynamic> body) {
    // TODO: implement postApi
    throw UnimplementedError();
  }

  @override
  Future<dynamic> putApi(String url, Map<String, dynamic> body) {
    // TODO: implement putApi
    throw UnimplementedError();
  }
  @override
  Future<dynamic> deleteApi(String url, Map<String, dynamic> body) {
    // TODO: implement deleteApi
    throw UnimplementedError();
  }

  @override
  Future<dynamic> downloadApi(String url) {
    // TODO: implement downloadApi
    throw UnimplementedError();
  }

  @override
  Future<dynamic> downloadFile(String url, String path) {
    // TODO: implement downloadFile
    throw UnimplementedError();
  }

  @override
  Future<dynamic> downloadImage(String url, String path) {
    // TODO: implement downloadImage
    throw UnimplementedError();
  }

  @override
  Future<dynamic> downloadPdf(String url, String path) {
    // TODO: implement downloadPdf
    throw UnimplementedError();
  }


  @override
  Future<dynamic> uploadApi(String url, Map<String, dynamic> body, List<File> files) {
    // TODO: implement uploadApi
    throw UnimplementedError();
  }

}


dynamic returnResponse(http.Response response) async {
  switch(response.statusCode){
    case 200:
      dynamic responseJson = jsonDecode(response.body.toString());
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorizedException(response.body.toString());
    case 404:
      throw NotFoundException(response.body.toString());
    case 500:
      throw ServerException(response.body.toString());
      
    default:
      throw FetchDataException("Error occurred while communicating with server with status code ${response.statusCode}");
  }

}
