import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

abstract class LocalImageStorageService {
  Future<String> persistChatImage(File sourceImage, {String? messageId});
  Future<String> persistChatImageBytes(
    Uint8List bytes, {
    String? messageId,
    String extension = '.jpg',
  });
}

class LocalImageStorageServiceImpl implements LocalImageStorageService {
  static const _chatImagesDirName = 'chat_images';

  @override
  Future<String> persistChatImage(File sourceImage, {String? messageId}) async {
    final appDir = await getApplicationDocumentsDirectory();
    final chatImagesDir = Directory('${appDir.path}/$_chatImagesDirName');
    if (!await chatImagesDir.exists()) {
      await chatImagesDir.create(recursive: true);
    }

    final ext = _fileExtension(sourceImage.path);
    final safeMessageId = (messageId != null && messageId.isNotEmpty)
        ? messageId
        : DateTime.now().millisecondsSinceEpoch.toString();
    final fileName =
        '${safeMessageId}_${DateTime.now().microsecondsSinceEpoch}$ext';
    final destinationPath = '${chatImagesDir.path}/$fileName';

    final persisted = await sourceImage.copy(destinationPath);
    return persisted.path;
  }

  @override
  Future<String> persistChatImageBytes(
    Uint8List bytes, {
    String? messageId,
    String extension = '.jpg',
  }) async {
    final appDir = await getApplicationDocumentsDirectory();
    final chatImagesDir = Directory('${appDir.path}/$_chatImagesDirName');
    if (!await chatImagesDir.exists()) {
      await chatImagesDir.create(recursive: true);
    }

    final safeMessageId = (messageId != null && messageId.isNotEmpty)
        ? messageId
        : DateTime.now().millisecondsSinceEpoch.toString();
    final fileName =
        '${safeMessageId}_${DateTime.now().microsecondsSinceEpoch}$extension';
    final destinationPath = '${chatImagesDir.path}/$fileName';

    final file = File(destinationPath);
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  String _fileExtension(String path) {
    final dotIndex = path.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == path.length - 1) {
      return '.jpg';
    }
    return path.substring(dotIndex);
  }
}
