import 'package:flutter/material.dart';

import 'package:artisan_hr/app/app_controller.dart';
import 'package:artisan_hr/app/presentation/app_brand.dart';
import 'package:artisan_hr/shared/localization/l10n.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.controller, super.key});

  final AppController controller;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _activePage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    await widget.controller.completeOnboarding();
  }

  Future<void> _goNext(int pageCount) async {
    if (_activePage == pageCount - 1) {
      await _finishOnboarding();
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final items = <_OnboardingItem>[
      _OnboardingItem(
        icon: Icons.schedule_send_rounded,
        eyebrow: l10n.onboardingBadge,
        title: l10n.onboardingHeadline,
        description: l10n.onboardingSubheadline,
      ),
      _OnboardingItem(
        icon: Icons.shield_outlined,
        eyebrow: l10n.justInTimePermissionsTitle,
        title: l10n.onboardingProofTitle,
        description: l10n.onboardingProofDescription,
      ),
      _OnboardingItem(
        icon: Icons.history_toggle_off_rounded,
        eyebrow: l10n.historyTab,
        title: l10n.onboardingHistoryTitle,
        description: l10n.onboardingHistoryDescription,
      ),
    ];
    final isLastPage = _activePage == items.length - 1;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppBrandPalette.night, AppBrandPalette.nightSurface]
                : [Color(0xFFE9F7F2), Color(0xFFF8FCFA)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth > 560
                  ? 460.0
                  : constraints.maxWidth - 32;

              return Center(
                child: SizedBox(
                  width: width.clamp(320.0, 460.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      PresenseLockup(
                                        markSize: 54,
                                        wordmarkStyle: textTheme.titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w300,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: _finishOnboarding,
                                  child: Text(l10n.skipIntro),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              initialValue: widget.controller.languageCode,
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: l10n.languageLabel,
                              ),
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
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }
                                widget.controller.setLanguage(value);
                              },
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: PageView.builder(
                                      controller: _pageController,
                                      itemCount: items.length,
                                      onPageChanged: (page) {
                                        setState(() {
                                          _activePage = page;
                                        });
                                      },
                                      itemBuilder: (context, index) {
                                        return _OnboardingPage(
                                          item: items[index],
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Row(
                                    children: [
                                      for (
                                        var index = 0;
                                        index < items.length;
                                        index++
                                      )
                                        AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 180,
                                          ),
                                          margin: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          width: _activePage == index ? 26 : 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: _activePage == index
                                                ? colorScheme.primary
                                                : colorScheme.outlineVariant,
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: () => _goNext(items.length),
                                child: Text(
                                  isLastPage
                                      ? l10n.onboardingGetStarted
                                      : l10n.onboardingNext,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OnboardingItem {
  const _OnboardingItem({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String description;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.item});

  final _OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [AppBrandPalette.nightCard, AppBrandPalette.nightSurface]
              : [Color(0xFFFFFFFF), Color(0xFFF1FAF6)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(22),
              ),
              alignment: Alignment.center,
              child: Icon(
                item.icon,
                color: colorScheme.onPrimaryContainer,
                size: 30,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              item.eyebrow,
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item.title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.description,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppBrandPalette.softMint,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                context.l10n.onboardingPermissionHint,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppBrandPalette.darkTeal,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
