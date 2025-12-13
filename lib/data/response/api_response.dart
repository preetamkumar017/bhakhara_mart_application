
import 'package:bhakharamart/data/response/status.dart';

class ApiResponse<T> {
  Status? status;
  T? data;
  String message;

  ApiResponse(this.status, this.data, this.message);

  ApiResponse.loading() : this(Status.LOADING, null, "");
  ApiResponse.success(T data) : this(Status.SUCCESS, data, "");
  ApiResponse.error(String message) : this(Status.ERROR, null, message);

 @override
  String toString() {
    // TODO: implement toString
    return "Status: $status, Data: $data, Message: $message";

  }


}