
export async function search(key, page) {
  const rsp = await fetch(`https://www.acfun.cn/search?keyword=${encodeURIComponent(key)}&type=bgm&quickViewId=bangumi-list&reqID=1&ajaxpipe=1&pCursor=${page}`);
  const json = (await rsp.text()).replace('/*<!-- fetch-stream -->*/', '');
  return HtmlParser(JSON.parse(json).html)
    .queryAll('[data-exposure-log]')
    .map(item => {
      const data = JSON.parse(item.attr('data-exposure-log'));
      const imgData = item.query('img');
      return {
        id: data.album_id,
        name: imgData.attr('alt'),
        image: {
          url: imgData.attr('src'),
        },
        summary: item.query('.bangumi__main__intro')?.text(),
        type: 'video',
      };
    });
}

export async function getSubjectInfo(subject) {
  const rsp = await fetch(`https://m.acfun.cn/v/?ab=${subject.id}`, {
    headers: {
      "user-agent": "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.96 Mobile Safari/537.36 Edg/88.0.705.50",
    }
  });
  const doc = HtmlParser(await rsp.text());
  subject.name = doc.query('.drama-title')?.text() ?? subject.name;
  subject.summary = doc.query('.drama-desc')?.text() ?? subject.summary;
  subject.eps = doc.queryAll('li.episodes-item').map(item => {
    const id = item.attr('item-id');
    return {
      id: id,
      name: item.text(),
      img: item.attr('data-img'),
      url: `https://m.acfun.cn/v/?ab=${subject.id}_${id}`,
    };
  });
  return subject;
}

export async function getEpisode(episode) {
  return webview(episode.url, {
    ua: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36",
    onRequest: ({ url }) => {
      if (url.includes("m3u8")) return true;
      return false;
    }
  });
}
