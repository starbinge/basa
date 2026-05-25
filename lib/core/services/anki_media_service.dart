import 'dart:convert';
import 'dart:io';

class AnkiMediaService {
  Map<String, String> _mediaMap = {};
  String _currentActivePath = "";

  Map<String, String> get mediaMap => _mediaMap;

  Future<void> findAudioPath({required String mediaInformationSource}) async {
    final File _mediaFile = File(mediaInformationSource);
    try {
      if (_mediaMap.isNotEmpty && _currentActivePath == mediaInformationSource)
        return;
      if (await _mediaFile.exists()) {
        final String jsonString = await _mediaFile.readAsString();
        final Map<String, dynamic> rawMap = jsonDecode(jsonString);
        _mediaMap = rawMap.map((key, value) => MapEntry(value.toString(), key));
        _currentActivePath = mediaInformationSource;
      }
    } catch (e) {
      _mediaMap = {};
    }
  }
}
