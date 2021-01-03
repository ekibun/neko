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

class Provider {
  static IsolateQjs _engine;
  static Map<String, Object> _providers = {};
  static _methodHandler(String method, List args) {
    switch (method) {
      case "webview":
        return webview(args[0], args[1]);
      case "encode":
        return convert(utf8.encode(args[0]), to: args[1], fatal: args[2]);
      case "decode":
        return utf8.decode(convert(args[0], from: args[1], fatal: args[2]),
            allowMalformed: args[2]);
      case "fetch":
        return Http.fetch(args[0]);
      case "console":
        print(args[1]);
        return;
      default:
        throw Exception("No such method");
    }
  }

  static JsAsyncModuleHandler _moduleHandler = (module) async {
    var modulePath = module == "@init"
        ? "js/init.js"
        // TODO 在这里传递plugin数据
        : module.startsWith("@provider/")
            ? "js/provider/" +
                module.replaceAll(new RegExp(r"^@provider/|.js$"), "") +
                ".js"
            : "js/module/" +
                module.replaceFirst(new RegExp(r".js$"), "") +
                ".js";
    return rootBundle.loadString(modulePath);
  };

  static _ensureEngine() async {
    if (_engine == null) {
      _engine = IsolateQjs(
        methodHandler: _methodHandler,
        moduleHandler: _moduleHandler,
        stackSize: 1024 * 1024,
      );
      await _engine.evaluate(await _moduleHandler("@init"), name: "<init>");
    }
  }

  static reset() async {
    _providers.clear();
    await _engine.close();
    _engine = null;
  }

  static Future<dynamic> _evaluate(String command, String name) async {
    await _ensureEngine();
    return await _engine.evaluate(command, name: name);
  }

  static Future<Map> getProvider(String name) async {
    return _providers[name] ??
        await _evaluate('import("@provider/$name")', "<loadProvider>");
  }
}
