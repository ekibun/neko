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
  return HtmlParser(await rsp.text())
    .queryAll('.item')
    .map(item => {
      const id = Number(item.attr('id').split('_').pop());
      if (Number.isNaN(id)) return;
      const imgDom = item.query('img');
      const typeInt = /subject_type_(\d)/.exec(item.query('.ico_subject_type')?.attr('class'))?.pop();
      return {
        id: id,
        name: item.query('h3 a').text(),
        image: {
          url: imgDom && parseImageUrl(imgDom),
        },
        summary: item.query('.info')?.text()?.replace(/^[\n ]/, ''),
        type: { 1: 'book', 2: 'video', 3: 'music', 6: 'video' }[typeInt],
      };
    }).filter(v => v);
}

export async function getSubjectInfo(subject) {
  const rsp = await fetch(`https://bgm.tv/subject/${subject.id}`);

  const doc = HtmlParser(await rsp.text());
  subject.name = doc.query('.nameSingle> a')?.attr('title') ?? doc.query('.nameSingle> a')?.text() ?? subject.name;
  const typeText = doc.query('#navMenuNeue .focus').text();
  subject.type = { '动画': 'video', '书籍': 'book', '音乐': 'music', '三次元': 'video' }[typeText] ?? subject.type;
  subject.summary = doc.query('#subject_summary')?.text() ?? subject.summary;
  subject.image = parseImageUrl(doc.query('.infobox img.cover')) ?? subject.image;
  subject.tags = doc.queryAll('.subject_tag_section a span')?.map((tag) => tag.text()) ?? subject.tags;
  subject.score = Number(doc.query('.global_score .number')?.text()) ?? subject.score;
  subject.info = Object.fromEntries(doc.queryAll('#infobox li').map((li) => {
    const tip = li.query('span.tip')?.text() ?? "";
    li.query('span.tip').remove();
    return [tip, li.text()];
  }));
  return subject;
}