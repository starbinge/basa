List<String> extractAudios({required List<String> fields}) {
  final audioRegex = RegExp(r'\[sound:(.*?)\]');
  List<String> audios = [];

  for (var field in fields) {
    final matches = audioRegex.allMatches(field);
    for (var match in matches) {
      if (match.group(1) != null) {
        audios.add(match.group(1)!);
      }
    }
  }
  return audios;
}

String? extractImage({required List<String> fields}) {
  final imageRegex = RegExp(r'<img src="(.*?)"\s*/?>');

  for (var field in fields) {
    final match = imageRegex.firstMatch(field);
    if (match != null) {
      return match.group(1);
    }
  }
  return null;
}

String cleanTotalHtml(String text) {
  final audioRegex = RegExp(r'\[sound:(.*?)\]');
  final imageRegex = RegExp(r'<img src="(.*?)"\s*/?>');
  final htmlRegex = RegExp(r'<[^>]*>');
  String clean = text.replaceAll(audioRegex, '').replaceAll(imageRegex, '');
  clean = clean.replaceAll(htmlRegex, '');
  clean = clean.replaceAll('&nbsp;', ' ');
  clean = clean.replaceAll('&amp;', '&');

  return clean.trim();
}

