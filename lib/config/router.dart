// lib/config/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    // Daily Log, Garden, Analytics etc. will be added next
  ],
);
