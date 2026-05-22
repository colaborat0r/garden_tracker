// lib/features/more/more_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('More')),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _MenuCard(
                  icon: Icons.attach_money,
                  title: 'Expenses',
                  subtitle: 'Track seeds, soil, tools & amendments',
                  color: Colors.teal,
                  onTap: () => context.push('/more/expenses'),
                ),
                const SizedBox(height: 12),
                _MenuCard(
                  icon: Icons.alarm,
                  title: 'Reminders',
                  subtitle: 'Water, fertilize, pest check & harvest alerts',
                  color: Colors.orange,
                  onTap: () => context.push('/more/reminders'),
                ),
                const SizedBox(height: 12),
                _MenuCard(
                  icon: Icons.book_outlined,
                  title: 'Garden Journal',
                  subtitle: 'Notes, lessons learned & photo timeline',
                  color: Colors.indigo,
                  onTap: () => context.push('/more/journal'),
                ),
                const SizedBox(height: 12),
                _MenuCard(
                  icon: Icons.local_library_outlined,
                  title: 'Knowledge Base',
                  subtitle: 'Crop guides, growing tips & planting calendar',
                  color: Colors.green,
                  onTap: () => context.push('/more/knowledge'),
                ),
                const SizedBox(height: 12),
                _MenuCard(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  subtitle: 'Garden name, backup, export data',
                  color: cs.primary,
                  onTap: () => context.push('/more/settings'),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    '🌿 Garden Tracker v1.0',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _MenuCard({
    required this.icon, required this.title, required this.subtitle,
    required this.color, required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
