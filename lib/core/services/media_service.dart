import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../network/app_failure.dart';

class MediaService {
  Future<String?> pickImage({bool fromFiles = false}) async {
    String? source;
    if (fromFiles) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg'],
      );
      source = result?.files.single.path;
    } else {
      source = (await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      ))
          ?.path;
    }
    if (source == null) {
      return null;
    }
    final file = File(source);
    if (await file.length() > 5 * 1024 * 1024) {
      throw const AppFailure('Elige una imagen de hasta 5 MB.');
    }
    final extension = source.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png'].contains(extension)) {
      throw const AppFailure('Usa una imagen PNG o JPEG.');
    }
    final directory = await getApplicationDocumentsDirectory();
    final media =
        await Directory('${directory.path}/demo_media').create(recursive: true);
    final target =
        '${media.path}/${DateTime.now().microsecondsSinceEpoch}.$extension';
    await file.copy(target);
    return target;
  }

  Future<void> clearDemoMedia() async {
    final directory = await getApplicationDocumentsDirectory();
    final media = Directory('${directory.path}/demo_media');
    if (await media.exists()) {
      await media.delete(recursive: true);
    }
  }
}
