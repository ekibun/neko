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
    const typeInt = /subject_type_(\d)/.exec(itemDom.find('.ico_subject_type')?.attr("class"))?.pop();
    return {
      id: id,
      name: itemDom.find('h3 a').first()?.text(),
      image: {
        url: imgDom && parseImageUrl($(imgDom)).replace(/\/[lcmgs]\//, '/m/'),
      },
      summary: itemDom.find(".info").first()?.text()?.replace(/^[\n ]/, ''),
      type: typeInt == 1 ? "book" : typeInt == 2 || typeInt == 6 ? "video" : typeInt == 3 ? "music" : undefined,
    };
  }).filter(v => v);
}