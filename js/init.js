/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-08-27 17:25:56
 * @LastEditors: ekibun
 * @LastEditTime: 2020-08-29 21:50:56
 */
(async () => {
  const _dart = this.dart;

  const CryptoJS = (await import("crypto")).default;

  class FormData {
    constructor(data){
      const _data = data || {}
      this.__js_proto__ = "FormData";
      this.__items__ = Object.keys(_data).map((k)=>({
        name: k,
        value: _data[k].filename ? _data[k].value : _data[k],
        filename: _data[k].filename
      }));
    }

    append(name, value, filename){
      this.__items__.append({ name, value, filename })
    }

    delete(name){
      const index  = this.__items__.findIndex((v) => v.name === name);
      if (index < 0) return;
      this.__items__.splice(index, 1);
    }

    entries() {
      return function* () {
        for(var item in __items__)
          yield [item.name, item.value, item.filename];
      };
    }

    get(name) {
      return this.__items__.find((v) => v.name === name);
    }

    getAll(name) {
      var ret = [];
      for(var item in __items__)
        if(item.name === name) ret.append(item.value);
      return value;
    }

    has(name) {
      return this.__items__.find((v) => v.name === name) !== null;
    }

    keys() {
      return function* () {
        for(var item in __items__)
          yield item.name;
      };
    }

    set(name, value, filename) {
      const index  = this.__items__.findIndex((v) => v.name === name);
      if (index < 0) this.append(name, value, filename);
      this.splice(index, 1, { name, value, filename });
    }

    values() {
      return function* () {
        for(var item in __items__)
          yield item.value;
      };
    }
  };

  const _TextEncoder = this.TextEncoder;
  const _TextDecoder = this.TextDecoder;

  class Response {
    constructor(response){
      response = response || {};
      this.headers = response.headers;
      this.ok = response.ok;
      this.redirected = response.redirected;
      this.status = response.status;
      this.statusText = response.statusText;
      this.url = response.url;
      this.body = response.body;
      this.redirects = response.redirects || [];
      // TODO `type`, `useFinalURL`, `bodyUsed`
    }

    clone() {
      return new Response(this) 
    }

    async arrayBuffer() {
      return this.body;
    }

    async text(utfLabel) {
      return new _TextDecoder(utfLabel || "utf-8").decode(this.body);
    }

    async json(utfLabel) {
      return JSON.parse(await this.text(utfLabel));
    }
  }

  class Request {
    constructor(input, init){
      const options = init || {};
      const request = typeof input === "string" ? {url: input} : input;
      this.url = request.url;
      this.method = options.method || request.method || "GET";
      this.headers = options.headers || request.headers || {};
      this.body = options.body || request.body;
      this.redirect = options.redirect || request.redirect || "follow";
      // TODO `mode`, `credentials`, `cache`, `referrer`, `referrerPolicy`, `integrity`, `redirect`
    }
  }

  const encodeURI_hex = (encoder, c) => [...new Uint8Array(encoder.encode(c))]
    .map(v => "%" + v.toString(16))
    .join("").toUpperCase();

  const globalProperties = {
    CryptoJS,
    TextEncoder: _TextEncoder,
    TextDecoder: _TextDecoder,
    Request,
    Response,
    FormData,
    fetch: async (input, init) => {
      const response = await _dart("fetch", new Request(input, init));
      return new Response(response);
    },
    webview: async (url, options) => {
      return _dart("webview", url, options || {});
    },
    encodeURI: (uri, encoding) => {
      const encoder = new _TextEncoder(encoding || "utf-8");
      return `${uri}`.replace(/[^a-zA-Z0-9-_.!~*'();/?:@&=+$,#]/g, (c) => encodeURI_hex(encoder, c));
    },
    encodeURIComponent: (uri, encoding) => {
      const encoder = new _TextEncoder(encoding || "utf-8");
      return `${uri}`.replace(/[^a-zA-Z0-9-_.!~*'()]/g, (c) => encodeURI_hex(encoder, c));
    }
  }

  Object.defineProperties(this, Object.assign({}, 
    ...Object.keys(globalProperties).map((key)=>({
      [key]:{
        value: globalProperties[key], 
        writable: false
      }}))));
  delete this.dart;
})();
