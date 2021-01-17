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
  ).replace(/\/[lcmgs]\//, '/m/');
}

export async function search(key, page) {
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
    const typeInt = /subject_type_(\d)/.exec(itemDom.find('.ico_subject_type')?.attr('class'))?.pop();
    return {
      id: id,
      name: itemDom.find('h3 a').first()?.text(),
      image: {
        url: imgDom && parseImageUrl($(imgDom)),
      },
      summary: itemDom.find('.info').first()?.text()?.replace(/^[\n ]/, ''),
      type: { 1: 'book', 2: 'video', 3: 'music', 6: 'video' }[typeInt],
    };
  }).filter(v => v);
}

export async function getSubjectInfo(subject) {
  const rsp = await fetch(`https://bgm.tv/subject/${subject.id}`);
  const $ = cheerio.load(await rsp.text());
  const typeText = $('#navMenuNeue .focus').text();
  subject.name = $('.nameSingle> a')?.attr('title') ?? $('.nameSingle> a')?.text() ?? subject.name;
  subject.type = { '动画': 'video', '书籍': 'book', '音乐': 'music', '三次元': 'video' }[typeText] ?? subject.type;
  subject.summary = $('#subject_summary').text() ?? subject.summary;
  subject.image = parseImageUrl($('.infobox img.cover')) ?? subject.image;
  subject.tags = $('.subject_tag_section a span')?.toArray()?.map((tag) => $(tag).text()) ?? subject.tags;
  subject.score = Number($('.global_score .number')?.text()) ?? subject.score;
  subject.info = Object.fromEntries($('#infobox li').toArray().map((li) => {
    const liDom = $(li);
    const tip = liDom.find('span.tip')?.text() ?? "";
    liDom.find('span.tip').remove();
    return [tip, liDom.text()];
  }));
  return subject;
}