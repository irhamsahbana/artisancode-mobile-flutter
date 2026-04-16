import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../app_controller.dart';
import '../../features/attendance/presentation/screens/attendance_history_screen.dart';
import '../../features/attendance/presentation/screens/attendance_home_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/presentation/widgets/app_message_banner.dart';
import '../../shared/presentation/widgets/loading_overlay.dart';
import '../../shared/localization/l10n.dart';
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
      locale: controller.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screens = [
      AttendanceHomeScreen(controller: controller),
      AttendanceHistoryScreen(controller: controller),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artisan HR'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.languageCode,
              borderRadius: BorderRadius.circular(12),
              onChanged: (value) {
                if (value == null) return;
                controller.setLanguage(value);
              },
              items: [
                DropdownMenuItem(
                  value: 'id',
                  child: Text(l10n.indonesianLabel),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Text(l10n.englishLabel),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.refreshTooltip,
            onPressed: controller.refreshAll,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: l10n.signOutTooltip,
            onPressed: controller.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          AppMessageBanner(
            errorMessage: l10n.resolveMessage(controller.errorMessage),
            successMessage: l10n.resolveMessage(controller.successMessage),
            onDismissed: controller.clearTransientMessages,
          ),
          Expanded(child: screens[controller.selectedTabIndex]),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: controller.selectedTabIndex,
        onDestinationSelected: controller.selectTab,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: l10n.homeTab,
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: l10n.historyTab,
          ),
        ],
      ),
    );
  }
}
