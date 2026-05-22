// lib/features/journal/journal_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/garden_providers.dart';
import '../../core/providers/database_provider.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/empty_state.dart';
import 'add_edit_journal_screen.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(allJournalEntriesProvider);
    final photosAsync = ref.watch(allPhotosProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            const SliverAppBar.large(
              title: Text('📔 Garden Journal'),
            ),
            const SliverToBoxAdapter(
              child: TabBar(tabs: [
                Tab(icon: Icon(Icons.article_outlined), text: 'Notes'),
                Tab(icon: Icon(Icons.photo_library_outlined), text: 'Gallery'),
              ]),
            ),
          ],
          body: TabBarView(
            children: [
              // ── Notes Tab ──────────────────────────────────────────
              entriesAsync.when(
                data: (entries) => entries.isEmpty
                    ? EmptyState(
                        emoji: '📝',
                        title: 'No Journal Entries Yet',
                        subtitle:
                            'Track your lessons learned, observations, and garden stories.',
                        actionLabel: 'Write First Entry',
                        onAction: () => _openAdd(context),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: entries.length,
                        itemBuilder: (_, i) =>
                            _JournalEntryCard(entry: entries[i]),
                      ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
              // ── Photo Gallery Tab ───────────────────────────────────
              photosAsync.when(
                data: (photos) {
                  if (photos.isEmpty) {
                    return const EmptyState(
                      emoji: '📷',
                      title: 'No Plant Photos Yet',
                      subtitle:
                          'Photos added to plants appear here as your garden timeline.',
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: photos.length,
                    itemBuilder: (_, i) =>
                        _PhotoThumbnail(photo: photos[i]),
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openAdd(context),
          icon: const Icon(Icons.edit_outlined),
          label: const Text('New Entry'),
        ),
      ),
    );
  }

  void _openAdd(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => const AddEditJournalScreen()),
    );
  }
}

class _JournalEntryCard extends ConsumerWidget {
  final JournalEntry entry;
  const _JournalEntryCard({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: cs.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: cs.onErrorContainer),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Entry?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Delete')),
            ],
          ),
        );
      },
      onDismissed: (_) =>
          ref.read(databaseProvider).deleteJournalEntry(entry.id),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddEditJournalScreen(entry: entry)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (entry.mood != null)
                      Text(entry.mood!,
                          style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.title,
                        style: tt.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      formatShortDate(entry.createdAt),
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
                if (entry.body != null && entry.body!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    entry.body!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                ],
                if (entry.photoPath != null) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(entry.photoPath!),
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
                if (entry.tags != null &&
                    entry.tags!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: entry.tags!
                        .split(',')
                        .map((t) => Chip(
                              label: Text(t.trim()),
                              padding: EdgeInsets.zero,
                              labelPadding: const EdgeInsets.symmetric(
                                  horizontal: 6),
                              visualDensity: VisualDensity.compact,
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoThumbnail extends ConsumerWidget {
  final PlantPhoto photo;
  const _PhotoThumbnail({required this.photo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onLongPress: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Photo?'),
            content: photo.caption != null
                ? Text(photo.caption!)
                : null,
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Delete')),
            ],
          ),
        );
        if (confirm == true) {
          ref.read(databaseProvider).deletePlantPhoto(photo.id);
        }
      },
      onTap: () => _showPhotoDetail(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(photo.photoPath),
            fit: BoxFit.cover,
          ),
          if (photo.caption != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(4),
                child: Text(
                  photo.caption!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showPhotoDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.file(File(photo.photoPath),
                  fit: BoxFit.contain),
            ),
            if (photo.caption != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(photo.caption!,
                    style: const TextStyle(fontSize: 13)),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        ),
      ),
    );
  }
}

