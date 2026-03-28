import 'package:flutter/material.dart';

import '../shared/config/app_config.dart';
import 'app_controller.dart';
import 'presentation/app_view.dart';

class ArtisanHrApp extends StatefulWidget {
  const ArtisanHrApp({super.key});

  @override
  State<ArtisanHrApp> createState() => _ArtisanHrAppState();
}

class _ArtisanHrAppState extends State<ArtisanHrApp> {
  late final AppController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppController(
      initialBaseUrl: AppConfig.defaultApiBaseUrl,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controller: _controller,
      child: const AppView(),
    );
  }
}

class AppScope extends InheritedNotifier<AppController> {
  const AppScope({
    required this.controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  final AppController controller;

  static AppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree.');
    return scope!.controller;
  }
}
