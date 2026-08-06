import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<String> getFilePath() async {
    final FilePickerResult? rawFile = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["euy"],
    );
    if (rawFile != null && rawFile.files.isNotEmpty) {
      return rawFile.files.single.path ?? "";
    }
    return "";
  }
}
