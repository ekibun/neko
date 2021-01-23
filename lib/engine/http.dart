/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-08-28 00:08:53
 * @LastEditors: ekibun
 * @LastEditTime: 2020-08-28 17:37:28
 */
import 'dart:typed_data';

import 'package:dio/dio.dart';

class Http {
  static Dio _dio;
  static get dio => (() {
        if (_dio == null) {
          _dio = Dio(
            BaseOptions(
              validateStatus: (status) => true,
            ),
          );
          _dio.interceptors
              .add(LogInterceptor(requestHeader: false, responseHeader: false));
        }
        return _dio;
      })();

  static Map wrapReq(dynamic req) {
    return req is Map
        ? req
        : {
            "url": req.toString(),
          };
  }

  static _wrapBody(body) {
    if (body is List<int>) return Stream.fromIterable(body.map((e) => [e]));
    if (body is Map && body["__js_proto__"] == "FormData") {
      // FormData
      var formData = FormData();
      for (var formItem in body["__items__"]) {
        var name = formItem["name"];
        var value = formItem["value"];

        if (value is Map && value["data"] is Int8List) {
          var fileName = formItem["fileName"];
          var contentValue = value["data"];
          var contentType = value["type"];
          formData.files.add(MapEntry(
              name,
              MultipartFile.fromBytes(
                contentValue,
                filename: fileName,
                contentType: contentType,
              )));
        } else {
          formData.fields.add(MapEntry(name, value.toString()));
        }
      }
      return formData;
    }
    return body;
  }

  static Future<dynamic> fetch(Map req) async {
    var reqBody = _wrapBody(req["body"]);
    Response rsp = await (dio.request(
      req["url"],
      data: reqBody,
      options: Options(
          method: req["method"],
          headers: Map.from(req["headers"]),
          responseType: ResponseType.bytes,
          followRedirects: req["redirect"] == "follow"),
    ));
    return {
      "url": rsp.isRedirect ? rsp.realUri.toString() : req["url"],
      "headers": rsp.headers.map,
      "ok": rsp.statusCode >= 200 && rsp.statusCode < 300,
      "redirected": rsp.isRedirect,
      "redirects": List.from(rsp.redirects?.map((redirect) => {
            "statusCode": redirect.statusCode,
            "method": redirect.method,
            "location": redirect.location.toString()
          })),
      "status": rsp.statusCode,
      "statusText": rsp.statusMessage,
      "body": rsp.data
    };
  }
}
