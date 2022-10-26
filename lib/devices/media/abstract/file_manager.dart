import 'package:image_picker/image_picker.dart';

abstract class FileManager {
  Future<XFile?> pickPhotoFromCamera();

  Future<XFile?> pickVideoFromCamera();

  Future<XFile?> pickPhotoFromGallery();

  Future<XFile?> pickVideoFromGallery();
}

extension FilesUtil on XFile {
  static const String _validMimeType = "image/jpeg,image/jpg,image/png";
  // setup your minSize
  static const int _minSize = 5000000;

  Future<bool> isValid() async {
    final size = await length();
    return size < _minSize &&
        _validMimeType.contains(mimeType?.toLowerCase() ?? "---");
  }
}
