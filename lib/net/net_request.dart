import 'package:dio/dio.dart';

//泛型类保证程序不会因为类型而无法运行
class ComResponse<T> {
  int code;
  String msg;
  T data;
  ComResponse({this.code, this.msg, this.data});
}

class NetRequest {
  var dio = Dio();
  Future<ComResponse<T>> requestData<T>(String path,
      {Map<String, dynamic> queryParameters,
      dynamic data,
      String method = "get"}) async {
    try {
      Response response = method == "get"
          ? await dio.get(path, queryParameters: queryParameters)
          : await dio.post(path, data: data);
      return ComResponse(
        code: response.data['code'],
        msg: response.data['msg'],
        data: response.data['data'],
      );
    } on DioError catch (e) {
      print(e.message);
      String message = e.message;
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        message = "connection Timeout";
      } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
        message = "Receive Timeout";
      } else if (e.type == DioErrorType.RESPONSE) {
        message = "404 server not fount ${e.response.statusCode}";
      }
      return Future.error(message);
    }
  }
}
