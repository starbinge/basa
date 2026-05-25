String cleanHtml({required String text}) {
  return text.replaceAll(RegExp(r"<[^>]*>"), '').trim();
}

String cleanAudioHtml({required String rawAudioText}) {
  return rawAudioText.replaceAll(RegExp(r'\[sound:|\]'), '').trim();
}
