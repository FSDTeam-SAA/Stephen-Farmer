import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../domain/repo/post_report_repo.dart';

class PostRepositoryImpl implements PostRepository {
  final ImagePicker _picker;

  PostRepositoryImpl(this._picker);

  @override
  Future<File?> pickImage(PhotoSource source) async {
    final ImageSource imgSource = source == PhotoSource.camera ? ImageSource.camera : ImageSource.gallery;

    final XFile? x = await _picker.pickImage(source: imgSource, imageQuality: 85, maxWidth: 2000);

    if (x == null) return null;
    return File(x.path);
  }

  @override
  Future<void> createPost({required String description, required File? imageFile}) async {
    // TODO: API upload / local save
    // এখন শুধু placeholder
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
