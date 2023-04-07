import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../config/env.dart';
import 'base_response.dart';
import 'dio_adapter_stub.dart' if (dart.library.io) 'dio_adapter_mobile.dart' if (dart.library.js) 'dio_adapter_web.dart';

_parseAndDecode(String response) {
  // return BaseResponse.fromJson(jsonDecode(response));

  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class BaseDio with DioMixin implements Dio {
  BaseDio() {
    if (kIsWeb) {
      httpClientAdapter = getAdapter();
    } else {
      httpClientAdapter = getAdapter();
    }

    transformer = BackgroundTransformer()..jsonDecodeCallback = parseJson;

    if (!kReleaseMode) {
      interceptors.add(
        LogInterceptor(
          requestBody: kDebugMode ? true : false,
          responseBody: true,
          request: false,
          requestHeader: false,
        ),
      );
    }

    // interceptors.add(
    //   PrettyDioLogger(
    //     requestHeader: kDebugMode ? true : false,
    //     requestBody: kDebugMode ? true : false,
    //     responseBody: kDebugMode ? true : false,
    //     responseHeader: false,
    //     error: kDebugMode ? true : false,
    //     compact: true,
    //     maxWidth: 90,
    //   ),
    // );

    interceptors.add(QueuedInterceptorsWrapper(onRequest: (options, handler) async {
      try {
        //options.headers['authorization'] = 'Bearer $token';
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }

      handler.next(options);
    }, onResponse: (response, handler) {
      handler.next(response);
    }, onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        //  await appService.logout(onboard: true, logoutAnon: false);
      }

      handler.next(error);
    }));
  }

  @override
  BaseOptions get options => BaseOptions(
        baseUrl: kBaseApiUrl!,
        followRedirects: false,
        receiveTimeout: const Duration(seconds: 60),
        connectTimeout: const Duration(seconds: 10),
        contentType: Headers.jsonContentType,
      );
}
