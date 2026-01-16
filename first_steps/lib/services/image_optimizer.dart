import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Helper for optimizing images before saving
class ImageOptimizer {
  static const int maxDimension = 1024;
  static const int jpegQuality = 85;

  static Future<String> optimizeAndSave(String originalPath) async {
    final bytes = await File(originalPath).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw Exception('Failed to decode image');
    }

    final resized = _resizeIfNeeded(decoded);
    final outputBytes = img.encodeJpg(resized, quality: jpegQuality);

    final directory = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(path.join(directory.path, 'images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final filename =
        'optimized_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final outputPath = path.join(imagesDir.path, filename);
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(outputBytes, flush: true);

    return outputPath;
  }

  static img.Image _resizeIfNeeded(img.Image image) {
    final width = image.width;
    final height = image.height;

    if (width <= maxDimension && height <= maxDimension) {
      return image;
    }

    if (width >= height) {
      return img.copyResize(image, width: maxDimension);
    }

    return img.copyResize(image, height: maxDimension);
  }
}
