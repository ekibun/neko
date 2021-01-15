import cheerio from 'cheerio';

function resolveUrl(url) {
  const _url = url?.replace(/^https?:/, '') ?? '';
  if (!_url) return;
  if (_url.startsWith('//')) return 'https:' + _url;
  else if (_url.startsWith('/')) return 'https://bgm.tv' + _url;
  else return 'https://bgm.tv/' + _url;
}

function parseImageUrl(imgDom) {
  return resolveUrl(imgDom.attr('src')
    ?? imgDom.attr('data-cfsrc')
    ?? /background-image:url\('([^']*)'\)/.exec(imgDom.attr('style'))?.splice(1, 1)
  );
}

export const search = async (key, page) => {
  const rsp = await fetch(`https://bgm.tv/subject_search/${encodeURIComponent(key)}?page=${page}`, {
    headers: {
      'cookie': `chii_searchDateLine=${(new Date().getTime() / 1000 | 0) - 10}`
    }
  });
  const $ = cheerio.load(await rsp.text());
  return $('.item').toArray().map(item => {
    const itemDom = $(item);
    const id = Number(itemDom.attr('id').split('_').pop());
    if (Number.isNaN(id)) return;
    const imgDom = itemDom.find('img')?.first();
    return {
      id: id,
      name: itemDom.find('h3 a').first()?.text(),
      image: {
        url: imgDom && parseImageUrl($(imgDom)).replace(/\/[lcmgs]\//, '/m/'),
      },
      summary: itemDom.find(".info").first()?.text()?.replace(/^[\n ]/, '')
    };
  }).filter(v => v);
}