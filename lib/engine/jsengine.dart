/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-08-27 17:24:16
 * @LastEditors: ekibun
 * @LastEditTime: 2020-08-28 17:09:30
 */
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:neko/engine/http.dart';

import 'webview.dart';

class JsEngine {
  static FlutterJs _engine;
  static JsMethodHandler _methodHandler = (method, args) async {
    switch (method) {
      case "webview":
        return await webview(args[0], args[1]);
      case "decode":
        return Encoding.getByName(args[0]).decode(args[1]);
      case "encode":
        return Encoding.getByName(args[0]).encode(args[1]);
      case "fetch":
        return await Http.fetch(args[0]);
      default:
        return JsMethodHandlerNotImplement();
    }
  };
  static JsModuleHandler _moduleHandler = (module) async {
    var modulePath = module == "@init" ? "js/init.js" 
        // TODO 在这里传递plugin数据
        : module.startsWith("@plugin/") ? "js/plugin/" + module.replaceAll(new RegExp(r"^@plugin/|.js$"), "") + ".js"
        : "js/module/" + module.replaceFirst(new RegExp(r".js$"), "") + ".js";
    return rootBundle.loadString(modulePath);
  };
  static _ensureEngine() async {
    if (_engine == null) {
      _engine = FlutterJs();
    }
    if (_engine.pointer == null) {
      await _engine.setMethodHandler(_methodHandler);
      await _engine.setModuleHandler(_moduleHandler);
      await _engine.evaluate(await _moduleHandler("@init"), "<init>");
    }
  }

  static recreate() async {
    if (_engine == null) return;
    return await _engine.destroy();
  }

  static Future<dynamic> evaluate(String command, String name) async {
    await _ensureEngine();
    return await _engine.evaluate(command, name);
  }
}
