// lib/config/router.dart
import 'package:go_router/go_router.dart';
import '../features/shell/main_shell.dart';
import '../features/home/home_screen.dart';
import '../features/beds/beds_screen.dart';
import '../features/beds/add_edit_bed_screen.dart';
import '../features/beds/bed_detail_screen.dart';
import '../features/plants/plant_detail_screen.dart';
import '../features/plants/add_edit_plant_screen.dart';
import '../features/log/quick_log_screen.dart';
import '../features/log/add_observation_screen.dart';
import '../features/log/add_harvest_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/more/more_screen.dart';
import '../features/expenses/expenses_screen.dart';
import '../features/reminders/reminders_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/settings/about_screen.dart';
import '../features/knowledge/knowledge_screen.dart';
import '../features/journal/journal_screen.dart';
final GoRouter goRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        // ── Tab 0: Home ──
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
        ]),
        // ── Tab 1: Garden ──
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/garden',
            builder: (c, s) => const BedsScreen(),
            routes: [
              GoRoute(path: 'add-bed', builder: (c, s) => const AddEditBedScreen()),
              GoRoute(
                path: 'bed/:bedId',
                builder: (c, s) => BedDetailScreen(
                    bedId: int.parse(s.pathParameters['bedId']!)),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (c, s) => AddEditBedScreen(
                        bedId: int.parse(s.pathParameters['bedId']!)),
                  ),
                  GoRoute(
                    path: 'add-plant',
                    builder: (c, s) => AddEditPlantScreen(
                        bedId: int.parse(s.pathParameters['bedId']!)),
                  ),
                  GoRoute(
                    path: 'plant/:plantId',
                    builder: (c, s) => PlantDetailScreen(
                      plantId: int.parse(s.pathParameters['plantId']!),
                      bedId: int.parse(s.pathParameters['bedId']!),
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (c, s) => AddEditPlantScreen(
                          bedId: int.parse(s.pathParameters['bedId']!),
                          plantId: int.parse(s.pathParameters['plantId']!),
                        ),
                      ),
                      GoRoute(
                        path: 'add-observation',
                        builder: (c, s) => AddObservationScreen(
                            plantId: int.parse(s.pathParameters['plantId']!)),
                      ),
                      GoRoute(
                        path: 'add-harvest',
                        builder: (c, s) => AddHarvestScreen(
                            plantId: int.parse(s.pathParameters['plantId']!)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ]),
        // ── Tab 2: Log ──
        StatefulShellBranch(routes: [
          GoRoute(path: '/log', builder: (c, s) => const QuickLogScreen()),
        ]),
        // ── Tab 3: Reports ──
        StatefulShellBranch(routes: [
          GoRoute(path: '/reports', builder: (c, s) => const ReportsScreen()),
        ]),
        // ── Tab 4: More ──
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/more',
            builder: (c, s) => const MoreScreen(),
            routes: [
              GoRoute(path: 'expenses', builder: (c, s) => const ExpensesScreen()),
              GoRoute(path: 'reminders', builder: (c, s) => const RemindersScreen()),
              GoRoute(path: 'settings', builder: (c, s) => const SettingsScreen(), routes: [
                GoRoute(path: 'about', builder: (c, s) => const AboutScreen()),
              ]),
              GoRoute(path: 'knowledge', builder: (c, s) => const KnowledgeScreen()),
              GoRoute(path: 'journal', builder: (c, s) => const JournalScreen()),
            ],
          ),
        ]),
      ],
    ),
  ],
);
