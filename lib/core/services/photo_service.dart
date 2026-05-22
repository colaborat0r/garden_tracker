// lib/core/services/photo_service.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
/// Picks images and copies them to the public Pictures/GardenTracker/ folder
/// so they are visible to Google Photos, Samsung Cloud, and other backup apps.
class PhotoService {
  static final _picker = ImagePicker();
  /// Pick a single image from [source] and save it permanently.
  static Future<String?> pickAndSave({
    required ImageSource source,
    int imageQuality = 85,
  }) async {
    final xfile =
        await _picker.pickImage(source: source, imageQuality: imageQuality);
    if (xfile == null) return null;
    return _copyToPublicPictures(xfile.path);
  }
  /// Pick multiple images from gallery and save them all permanently.
  static Future<List<String>> pickMultipleAndSave({
    int limit = 6,
    int imageQuality = 85,
  }) async {
    final files =
        await _picker.pickMultiImage(imageQuality: imageQuality, limit: limit);
    final saved = <String>[];
    for (final f in files) {
      final path = await _copyToPublicPictures(f.path);
      if (path != null) saved.add(path);
    }
    return saved;
  }
  static Future<String?> _copyToPublicPictures(String sourcePath) async {
    try {
      final dir = await _gardenPhotoDir();
      final ext = _extension(sourcePath);
      final filename = 'garden_${DateTime.now().millisecondsSinceEpoch}$ext';
      final dest = File('${dir.path}/$filename');
      await File(sourcePath).copy(dest.path);
      return dest.path;
    } catch (_) {
      return sourcePath; // graceful fallback to original path
    }
  }
  /// Returns (creating if needed) /storage/emulated/0/Pictures/GardenTracker/
  /// This directory is scanned by Google Photos and other backup services.
  static Future<Directory> _gardenPhotoDir() async {
    final external = await getExternalStorageDirectory();
    // Path is e.g. /storage/emulated/0/Android/data/<pkg>/files
    // Strip from "Android" onward to get the storage root
    final rootPath = external!.path.split('Android').first;
    final dir = Directory('${rootPath}Pictures/GardenTracker');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }
  static String _extension(String path) {
    final dot = path.lastIndexOf('.');
    return dot != -1 ? path.substring(dot) : '.jpg';
  }
}
