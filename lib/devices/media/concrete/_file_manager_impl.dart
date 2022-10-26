import 'package:flutter_base_rootstrap/devices/media/abstract/file_manager.dart';
import 'package:image_picker/image_picker.dart';

///
/// Library image_picker: https://pub.dev/packages/image_picker
/// remember adding permissions in Android and iOs
/// if (kIsWeb) {
///   Image.network(pickedFile.path);
/// } else {
///   Image.file(File(pickedFile.path));
/// }
///
class FileManagerImpl extends FileManager {
  @override
  Future<XFile?> pickPhotoFromGallery() async =>
      await ImagePicker().pickImage(source: ImageSource.gallery);

  @override
  Future<XFile?> pickVideoFromGallery() async =>
      await ImagePicker().pickVideo(source: ImageSource.gallery);

  @override
  Future<XFile?> pickPhotoFromCamera() async =>
      await ImagePicker().pickImage(source: ImageSource.camera);

  @override
  Future<XFile?> pickVideoFromCamera() async =>
      await ImagePicker().pickVideo(source: ImageSource.camera);
}
