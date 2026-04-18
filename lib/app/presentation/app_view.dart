import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:artisan_hr/app/app.dart';
import 'package:artisan_hr/app/app_controller.dart';
import 'package:artisan_hr/app/presentation/app_brand.dart';
import 'package:artisan_hr/app/presentation/app_theme.dart';
import 'package:artisan_hr/features/attendance/presentation/screens/attendance_history_screen.dart';
import 'package:artisan_hr/features/attendance/presentation/screens/attendance_home_screen.dart';
import 'package:artisan_hr/features/auth/presentation/screens/login_screen.dart';
import 'package:artisan_hr/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:artisan_hr/l10n/generated/app_localizations.dart';
import 'package:artisan_hr/shared/localization/l10n.dart';
import 'package:artisan_hr/shared/presentation/widgets/app_message_banner.dart';
import 'package:artisan_hr/shared/presentation/widgets/loading_overlay.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);

    return MaterialApp(
      title: appBrandName,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      darkTheme: buildDarkAppTheme(),
      themeMode: ThemeMode.system,
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
          final l10n = context.l10n;
          return LoadingOverlay(
            isLoading: controller.isBusy,
            label: l10n.syncingAttendanceData,
            child: controller.isAuthenticated
                ? _AuthenticatedShell(controller: controller)
                : controller.hasSeenOnboarding
                ? LoginScreen(controller: controller)
                : OnboardingScreen(controller: controller),
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
        scrolledUnderElevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PresenseWordmark(
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              controller.employee?.fullName ?? l10n.employeeAttendanceTitle,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.refreshTooltip,
            onPressed: controller.refreshAll,
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton<String>(
            tooltip: l10n.moreActions,
            onSelected: (value) {
              if (value == 'language:id' || value == 'language:en') {
                controller.setLanguage(value.split(':').last);
                return;
              }

              if (value == 'logout') {
                controller.logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Text(l10n.languageLabel),
              ),
              PopupMenuItem<String>(
                value: 'language:id',
                child: Text(l10n.indonesianLabel),
              ),
              PopupMenuItem<String>(
                value: 'language:en',
                child: Text(l10n.englishLabel),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: Text(l10n.signOutTooltip),
              ),
            ],
            icon: const Icon(Icons.more_vert),
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
