import 'package:flutter/material.dart';

import '../../features/attendance/presentation/screens/attendance_history_screen.dart';
import '../../features/attendance/presentation/screens/attendance_home_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../shared/presentation/widgets/app_message_banner.dart';
import '../../shared/presentation/widgets/loading_overlay.dart';
import '../app.dart';
import 'app_theme.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);

    return MaterialApp(
      title: 'Artisan HR',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return LoadingOverlay(
            isLoading: controller.isBusy,
            child: controller.isAuthenticated
                ? _AuthenticatedShell(controller: controller)
                : LoginScreen(controller: controller),
          );
        },
      ),
    );
  }
}

class _AuthenticatedShell extends StatelessWidget {
  const _AuthenticatedShell({required this.controller});

  final dynamic controller;

  @override
  Widget build(BuildContext context) {
    final screens = [
      AttendanceHomeScreen(controller: controller),
      AttendanceHistoryScreen(controller: controller),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artisan HR'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: controller.refreshAll,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: controller.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          AppMessageBanner(
            errorMessage: controller.errorMessage,
            successMessage: controller.successMessage,
            onDismissed: controller.clearTransientMessages,
          ),
          Expanded(child: screens[controller.selectedTabIndex]),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: controller.selectedTabIndex,
        onDestinationSelected: controller.selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
