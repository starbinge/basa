import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<String> getFilePath() async {
    final FilePickerResult? rawFile = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["apkg", "pdf", "ePub"],
    );
    if (rawFile != null && rawFile.files.isNotEmpty) {
      return rawFile.files.single.path ?? "";
    }
    return "";
  }
}
