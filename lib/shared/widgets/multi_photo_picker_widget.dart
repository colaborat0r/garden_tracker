// lib/shared/widgets/multi_photo_picker_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/services/photo_service.dart';

/// Allows picking and displaying multiple photos.
class MultiPhotoPickerWidget extends StatelessWidget {
  final List<String> photoPaths;
  final ValueChanged<List<String>> onChanged;
  final int maxPhotos;

  const MultiPhotoPickerWidget({
    super.key,
    required this.photoPaths,
    required this.onChanged,
    this.maxPhotos = 6,
  });

  Future<void> _pickPhoto(BuildContext context, ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final paths = await PhotoService.pickMultipleAndSave(
            limit: maxPhotos - photoPaths.length);
        if (paths.isNotEmpty) {
          onChanged([...photoPaths, ...paths]);
        }
      } else {
        final path = await PhotoService.pickAndSave(source: source);
        if (path != null) {
          onChanged([...photoPaths, path]);
        }
      }
    } catch (_) {}
  }

  void _removePhoto(int index) {
    final updated = [...photoPaths]..removeAt(index);
    onChanged(updated);
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final canAdd = photoPaths.length < maxPhotos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (photoPaths.isEmpty)
          GestureDetector(
            onTap: () => _showOptions(context),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: cs.outline.withValues(alpha: 0.4), width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      color: cs.onSurfaceVariant, size: 28),
                  const SizedBox(height: 6),
                  Text('Add Photos (up to $maxPhotos)',
                      style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...photoPaths.asMap().entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(e.value),
                                height: 110,
                                width: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removePhoto(e.key),
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: cs.errorContainer,
                                  child: Icon(Icons.close,
                                      size: 14, color: cs.onErrorContainer),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                if (canAdd)
                  GestureDetector(
                    onTap: () => _showOptions(context),
                    child: Container(
                      height: 110,
                      width: 80,
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: cs.outline.withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined,
                              color: cs.onSurfaceVariant),
                          const SizedBox(height: 4),
                          Text('Add',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: cs.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

