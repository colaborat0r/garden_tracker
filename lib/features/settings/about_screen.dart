// lib/features/settings/about_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _kofiUrl = 'https://ko-fi.com/chicktrack';

  static const _features = [
    (icon: Icons.yard_outlined,        label: 'Garden Beds',      desc: 'Manage raised beds, containers, ground plots & hydroponics'),
    (icon: Icons.eco_outlined,         label: 'Plant Tracking',   desc: 'Track every plant from seed to harvest with growth stages'),
    (icon: Icons.science_outlined,     label: 'Observations',     desc: 'Log watering, fertilizing, pest sightings and plant notes'),
    (icon: Icons.scale_outlined,       label: 'Harvest Log',      desc: 'Record harvests with weight, quality ratings and photos'),
    (icon: Icons.receipt_long_outlined,label: 'Expense Tracker',  desc: 'Track seeds, soil, tools and supplies with category breakdown'),
    (icon: Icons.notifications_outlined,label: 'Reminders',       desc: 'Never forget to water, fertilize or check for pests'),
    (icon: Icons.book_outlined,        label: 'Garden Journal',   desc: 'Write notes, lessons learned and mood entries with photos'),
    (icon: Icons.school_outlined,      label: 'Knowledge Base',   desc: '40+ plant growing guides with planting calendars and cultivation tips'),
    (icon: Icons.bar_chart_outlined,   label: 'Reports & Charts', desc: 'Visualize yield by crop/bed, expenses and success rates'),
    (icon: Icons.picture_as_pdf_outlined, label: 'Export & Backup', desc: 'Export to CSV, PDF or JSON — fully offline, your data stays yours'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('About Garden Tracker')),
      body: ListView(
        children: [
          // ── Hero banner ──────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primaryContainer, cs.secondaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: cs.primary.withValues(alpha: 0.15),
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    width: 64,
                    height: 64,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.eco, size: 56, color: cs.primary),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Garden Tracker',
                  style: tt.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Version 1.0.0',
                  style: tt.bodySmall?.copyWith(color: cs.onPrimaryContainer.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your offline-first garden companion for homesteaders, hobby growers and plant lovers.',

                  textAlign: TextAlign.center,
                  style: tt.bodyMedium?.copyWith(color: cs.onPrimaryContainer),
                ),
              ],
            ),
          ),

          // ── Ko-fi support button ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: FilledButton.icon(
              onPressed: _launchKofi,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF5CB85C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Text('☕', style: TextStyle(fontSize: 20)),
              label: const Text(
                'Support me on Ko-fi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'If Garden Tracker saves you time or puts food on your table, consider buying me a coffee! It keeps the app free and growing.',
              textAlign: TextAlign.center,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),

          const SizedBox(height: 24),
          _sectionHeader(context, '✨ Features'),

          // ── Feature tiles ────────────────────────────────────────────
          ..._features.map(
            (f) => ListTile(
              leading: CircleAvatar(
                backgroundColor: cs.primaryContainer,
                child: Icon(f.icon, color: cs.onPrimaryContainer, size: 20),
              ),
              title: Text(f.label, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(f.desc),
              dense: true,
            ),
          ),

          const SizedBox(height: 24),
          _sectionHeader(context, '📋 App Info'),

          _infoTile(Icons.code_outlined, 'Built with Flutter', 'Cross-platform, runs beautifully on Android & iOS'),
          _infoTile(Icons.storage_outlined, 'Offline-first', 'All data stored locally — no account required, no ads'),
          _infoTile(Icons.lock_outline, 'Privacy', 'Your garden data never leaves your device'),
          _infoTile(Icons.place_outlined, 'Planting Calendars', 'Region-specific planting guides and seasonal growing calendars'),

          const SizedBox(height: 24),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              '🌱 Built with love for homesteaders everywhere\n© 2026 ChickTrack',
              textAlign: TextAlign.center,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      );

  Widget _infoTile(IconData icon, String title, String subtitle) => ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        dense: true,
      );

  Future<void> _launchKofi() async {
    final uri = Uri.parse(_kofiUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

