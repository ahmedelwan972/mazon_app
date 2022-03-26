import 'dart:async';
import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static late Response response;

  static void init1() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveTimeout: 120000,
        connectTimeout: 120000,
        receiveDataWhenStatusError: true,
        validateStatus: (status) => true,
        followRedirects: true,
      ),
    );
  }

  static Future<Response> getData(
      {
        required String url,
        Map<String, dynamic>? query,
        String? token,
        String lang = 'en',
      }) async {

    

      dio.options.headers =
    {
      'lang' : lang,
      'Authorization':token ,
      'Content-Type': 'application/json'
    };
      return response = await dio.get(url, queryParameters: query);

  }

  static Future<Response> postData({
    required String url,
    required Map<String , dynamic> data,
    String? token,
    String lang ='en',


  }) async {

    dio.options.headers =
    {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'lang': lang,
      'Authorization':token ,
    };

    return response = await dio.post(url, data: data,);
  }

  static Future<Response> putData({
    required String url,
    required Map<String , dynamic> data,
    String? token,
    String lang = 'en',


  }) async {
    dio.options.headers =
    {
      'lang' : lang,
      'Authorization':token ,
      'Content-Type': 'application/json'
    };
    return response = await dio.put(url, data: data);
  }
}
