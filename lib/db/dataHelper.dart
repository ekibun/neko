import 'dart:convert';

import 'database.dart';

Subject subjectfromMap(Map subject, {String site = ""}) {
  return Subject(
    id: subject["id"]?.toString() ?? "",
    site: subject["site"] ?? site,
    subjectType: subject["type"] ?? "",
    name: subject["name"],
    image: jsonEncode(subject["image"]),
    summary: subject["summary"],
  );
}

Map subjectToMap(Subject subject) {
  return {
    "id": subject.id,
    "site": subject.site,
    "type": subject.subjectType,
    "name": subject.name,
    "image": jsonDecode(subject.image),
    "summary": subject.summary,
  };
}
