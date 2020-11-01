import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart';

class PageParser {
  const PageParser();

  Future<List<String>> call(Stream<List<int>> content, Uri sourceUrl) async {
    final htmlDoc = parse(
      await content.transform(utf8.decoder).join(),
      sourceUrl: sourceUrl.toString(),
      encoding: utf8.name,
    );

    final elementsList = _findByTitle(
      htmlDoc,
      "Nach neuen Fotos in den vorhandenen Verzeichnissen suchen",
    );

    final metaList = htmlDoc
        .getElementsByTagName("h3")
        .firstWhere(
          (element) => element.text
              .contains("Ergebnisse der Metadaten-Synchronisierung"),
          orElse: () => null,
        )
        ?.nextElementSibling;

    return [
      if (elementsList != null) ..._parseList(elementsList),
      if (metaList != null) ..._parseList(metaList),
    ];
  }

  Element _findByTitle(
    Document document,
    String title, {
    String titleTag = "h3",
  }) =>
      document
          .getElementsByTagName(titleTag)
          .firstWhere(
            (element) => element.text.contains(title),
            orElse: () => null,
          )
          ?.nextElementSibling;

  Iterable<String> _parseList(Element list) => list.children
      .where((element) => element.localName == "li")
      .map((e) => e.text);
}
