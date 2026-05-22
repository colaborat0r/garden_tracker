// lib/shared/widgets/photo_picker_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/services/photo_service.dart';

class PhotoPickerWidget extends StatelessWidget {
  final String? photoPath;
  final ValueChanged<String?> onChanged;
  const PhotoPickerWidget({
    super.key,
    this.photoPath,
    required this.onChanged,
  });
  Future<void> _pick(BuildContext context, ImageSource source) async {
    try {
      final path = await PhotoService.pickAndSave(source: source);
      if (path != null) onChanged(path);
    } catch (_) {}
  }
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (photoPath != null && photoPath!.isNotEmpty)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(photoPath!),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: cs.errorContainer,
                  child: IconButton(
                    icon: Icon(Icons.close,
                        size: 16, color: cs.onErrorContainer),
                    onPressed: () => onChanged(null),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          )
        else
          GestureDetector(
            onTap: () => _showOptions(context),
            child: Container(
              height: 120,
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
                  Icon(Icons.add_a_photo_outlined,
                      color: cs.onSurfaceVariant, size: 32),
                  const SizedBox(height: 8),
                  Text('Add Photo',
                      style: TextStyle(color: cs.onSurfaceVariant)),
                ],
              ),
            ),
          ),
      ],
    );
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
                _pick(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pick(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
