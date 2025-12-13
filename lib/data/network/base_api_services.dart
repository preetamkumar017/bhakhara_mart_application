import 'dart:io';

abstract class BaseApiServices {

  Future<dynamic> getApi(String url);
  Future<dynamic> postApi(String url, Map<String, dynamic> body);
  Future<dynamic> putApi(String url, Map<String, dynamic> body);
  Future<dynamic> deleteApi(String url, Map<String, dynamic> body);
  Future<dynamic> patchApi(String url, Map<String, dynamic> body);
  Future<dynamic> uploadApi(String url, Map<String, dynamic> body, List<File> files);
  Future<dynamic> downloadApi(String url);
  Future<dynamic> downloadFile(String url, String path);
  Future<dynamic> downloadImage(String url, String path);
  Future<dynamic> downloadPdf(String url, String path);

}