/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-08-28 14:16:07
 * @LastEditors: ekibun
 * @LastEditTime: 2020-09-03 00:18:10
 */

var cookie;
async function getCookie() {
  await fetch("https://www.wenku8.net/login.php?do=submit", {
    method: 'POST',
    body: {
      username: "",
      password: "",
      usecookie: "315360000",
      action: "login"
    }
  })
  cookie = rsp.headers("set-cookie").toArray().map((v) => v.split(';')[0]).join(";");
}

export default class {
  async search (key) {
    await fetch("https://www.wenku8.net/modules/article/search.php?searchtype=articlename&searchkey=" + key)
  }
}