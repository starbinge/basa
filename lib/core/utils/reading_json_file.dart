import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> readingJsonFile({required File jsonFile}) async {
  Map<String, dynamic> _finalJsonData;
  final File _jsonFile = jsonFile;

  final _stringFile = await _jsonFile.readAsString();
  final _finalObject = await json.decode(_stringFile);
  _finalJsonData = _finalObject;

  return _finalJsonData;
}
