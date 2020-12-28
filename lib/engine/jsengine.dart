/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-08-27 17:24:16
 * @LastEditors: ekibun
 * @LastEditTime: 2020-08-28 17:09:30
 */
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_qjs/isolate.dart';
import 'package:neko/engine/http.dart';
import 'package:flutter_iconv/flutter_iconv.dart';
import 'webview.dart';

class JsEngine {
  static IsolateQjs _engine;
  static _methodHandler(String method, List args) {
    switch (method) {
      case "webview":
        return webview(args[0], args[1]);
      case "encode":
        return convert(utf8.encode(args[0]), to: args[1], fatal: args[2]);
      case "decode":
        return utf8.decode(convert(args[0], from: args[1], fatal: args[2]), allowMalformed: args[2]);
      case "fetch":
        return Http.fetch(args[0]);
      default:
        throw Exception("No such method");
    }
  }

  static JsAsyncModuleHandler _moduleHandler = (module) async {
    var modulePath = module == "@init"
        ? "js/init.js"
        // TODO 在这里传递plugin数据
        : module.startsWith("@plugin/")
            ? "js/plugin/" +
                module.replaceAll(new RegExp(r"^@plugin/|.js$"), "") +
                ".js"
            : "js/module/" +
                module.replaceFirst(new RegExp(r".js$"), "") +
                ".js";
    return rootBundle.loadString(modulePath);
  };

  static _ensureEngine() async {
    if (_engine == null) {
      _engine = IsolateQjs(_methodHandler);
      _engine.setModuleHandler(_moduleHandler);
      await _engine.evaluate(await _moduleHandler("@init"), name: "<init>");
    }
  }

  static recreate() async {
    await _engine.close();
    _engine = null;
  }

  static Future<dynamic> evaluate(String command, String name) async {
    await _ensureEngine();
    return await _engine.evaluate(command, name: name);
  }
}
