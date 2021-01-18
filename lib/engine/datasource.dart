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
import 'package:xpath_parse/xpath_selector.dart';
import 'webview.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class DataSource {
  static IsolateQjs _engine;
  static List<DataSourceInfo> _infos = [];
  static Map<String, Object> _dataSource = {};

  static _methodHandler(String method, List args) {
    switch (method) {
      case "list_length":
        return (args[0] as List).length;
      case "list_get":
        return (args[0] as List)[args[1]];
      case "css":
        return parser.parse(args[0]).documentElement;
      case "css_query":
        return (args[0] as dom.Element).querySelector(args[1]);
      case "css_query_all":
        return (args[0] as dom.Element).querySelectorAll(args[1]);
      case "css_attr":
        if (args.length == 3) {
          return (args[0] as dom.Element).attributes[args[1]] = args[2];
        }
        return (args[0] as dom.Element).attributes[args[1]];
      case "css_text":
        if (args.length == 2) {
          return (args[0] as dom.Element).text = args[1];
        }
        return (args[0] as dom.Element).text;
      case "css_html":
        if (args.length == 2) {
          return (args[0] as dom.Element).innerHtml = args[1];
        }
        return (args[0] as dom.Element).innerHtml;
      case "css_outer_html":
        return (args[0] as dom.Element).outerHtml;
      case "css_remove":
        return (args[0] as dom.Element).remove();
      case "webview":
        return webview(args[0], args[1]);
      case "encode":
        return convert(utf8.encode(args[0]), to: args[1], fatal: args[2]);
      case "decode":
        return utf8.decode(convert(args[0], from: args[1], fatal: args[2]),
            allowMalformed: args[2]);
      case "xpath":
        return XPath.source(args[0]);
      case "xpath_query":
        return (args[0] as XPath).query(args[1]).list();
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
            : "js/module/" + module.replaceFirst(new RegExp(r".js$"), "") + ".js";
    return rootBundle.loadString(modulePath);
  };

  static _ensureInfos() async {
    if (_infos == null)
      _infos = [
        DataSourceInfo(
          "bgm.tv",
          searchSupport: [],
          code: await rootBundle.loadString("js/provider/bgm.tv.js"),
        ),
      ];
  }

  static _ensureEngine() async {
    await _ensureInfos();
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
    _dataSource.clear();
    await _engine.close();
    _engine = null;
  }

  static Future<dynamic> _evaluate(String command, String name) async {
    await _ensureEngine();
    return await _engine.evaluate(command, name: name);
  }

  static Future<Map> getProvider(String name) async {
    return _dataSource[name] ??
        await _evaluate('import("@provider/$name")', "<loadProvider>");
  }
}

class DataSourceInfo {
  String site;
  List<int> searchSupport;
  String code;

  DataSourceInfo(
    this.site, {
    this.searchSupport = const [],
    this.code = "",
  });
}
