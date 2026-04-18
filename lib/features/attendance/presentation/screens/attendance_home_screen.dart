import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:artisan_hr/app/app_controller.dart';
import 'package:artisan_hr/app/presentation/app_brand.dart';
import 'package:artisan_hr/features/attendance/data/models/attendance_summary.dart';
import 'package:artisan_hr/shared/localization/l10n.dart';
import 'package:artisan_hr/shared/presentation/widgets/empty_state.dart';
import 'package:artisan_hr/shared/utils/formatters.dart';

class AttendanceHomeScreen extends StatefulWidget {
  const AttendanceHomeScreen({required this.controller, super.key});

  final AppController controller;

  @override
  State<AttendanceHomeScreen> createState() => _AttendanceHomeScreenState();
}

class _AttendanceHomeScreenState extends State<AttendanceHomeScreen> {
  String? _checkInDraftAddress;
  String? _checkInDraftNotes;
  String? _checkInDraftDeviceName;
  String? _checkInDraftSelfiePath;
  String? _checkOutDraftDeviceName;
  String? _checkOutDraftSelfiePath;

  AppController get controller => widget.controller;

  ButtonStyle _heroSecondaryButtonStyle(BuildContext context) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.white.withValues(alpha: 0.06);
        }

        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withValues(alpha: 0.2);
        }

        if (states.contains(WidgetState.hovered)) {
          return Colors.white.withValues(alpha: 0.16);
        }

        return Colors.white.withValues(alpha: 0.12);
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.white.withValues(alpha: 0.42);
        }

        return Colors.white;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withValues(alpha: 0.08);
        }

        return null;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: Colors.white.withValues(alpha: 0.08));
        }

        return BorderSide(color: Colors.white.withValues(alpha: 0.22));
      }),
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final employee = controller.employee;
    final summary = controller.summary;
    final shift = controller.shiftToday;
    final policy = controller.policy;
    final recentLogs = controller.attendanceLogs
        .take(3)
        .toList(growable: false);

    return RefreshIndicator(
      onRefresh: controller.refreshAll,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppBrandPalette.darkTeal,
                  AppBrandPalette.deepTeal,
                  colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PresenseMark(size: 54),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employee?.fullName ??
                                controller.user?.userName ??
                                l10n.employeeFallback,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            employee?.employeeNo != null
                                ? l10n.employeeNoLabel(
                                    employee!.employeeNo ?? '-',
                                  )
                                : controller.user?.tenantName ??
                                      l10n.attendanceDashboard,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.78),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _HeroChip(
                      icon: Icons.today_rounded,
                      label: MaterialLocalizations.of(
                        context,
                      ).formatFullDate(DateTime.now()),
                    ),
                    _HeroChip(
                      icon: Icons.auto_awesome_rounded,
                      label: appBrandName,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _StatusBanner(summary: summary),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: controller.canCheckIn
                            ? () => _openCheckInSheet(context)
                            : null,
                        icon: const Icon(Icons.login_rounded),
                        label: Text(l10n.checkIn),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: _heroSecondaryButtonStyle(context),
                        onPressed: controller.canCheckOut
                            ? () => _openCheckOutSheet(context)
                            : null,
                        icon: const Icon(Icons.logout_rounded),
                        label: Text(l10n.checkOut),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoCard(
                  title: l10n.shiftToday,
                  icon: Icons.schedule_rounded,
                  lines: shift == null
                      ? [l10n.noShiftScheduled]
                      : [
                          shift.shiftName ?? l10n.unnamedShift,
                          l10n.startLabel(shift.startTime ?? '-'),
                          l10n.endLabel(shift.endTime ?? '-'),
                        ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoCard(
                  title: l10n.attendancePolicy,
                  icon: Icons.rule_rounded,
                  lines: policy == null
                      ? [l10n.noPolicy]
                      : [
                          l10n.timezoneLabel(policy.timezone),
                          l10n.checkInRange(
                            policy.checkInStart ?? '-',
                            policy.checkInEnd ?? '-',
                          ),
                          l10n.checkOutRange(
                            policy.checkOutStart ?? '-',
                            policy.checkOutEnd ?? '-',
                          ),
                        ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoCard(
            title: l10n.profile,
            icon: Icons.badge_outlined,
            lines: employee == null
                ? [l10n.employeeProfileMissing]
                : [
                    l10n.nameLabel(employee.fullName),
                    l10n.emailValue(employee.email ?? '-'),
                    l10n.statusLabel(employee.status ?? '-'),
                    l10n.photoProofRequired,
                  ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.recentActivity,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (controller.attendanceLogs.isNotEmpty)
                TextButton(
                  onPressed: () => controller.selectTab(1),
                  child: Text(l10n.viewAllHistory),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (recentLogs.isEmpty)
            EmptyState(
              icon: Icons.fact_check_outlined,
              title: l10n.noRecentLogs,
              description: l10n.noRecentLogsDescription,
            )
          else
            ...recentLogs.map(
              (log) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    title: Text(
                      log.type == 'check_in' ? l10n.checkIn : l10n.checkOut,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(formatDateTime(log.loggedAt)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        log.source,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openCheckInSheet(BuildContext context) async {
    final l10n = context.l10n;
    final addressController = TextEditingController(
      text: _checkInDraftAddress ?? '',
    );
    final notesController = TextEditingController(
      text: _checkInDraftNotes ?? '',
    );
    final deviceController = TextEditingController(
      text: _checkInDraftDeviceName ?? '$appBrandName Mobile',
    );
    var selfiePath = _checkInDraftSelfiePath;
    var isSubmitting = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final canSubmit =
                !isSubmitting && (selfiePath?.isNotEmpty ?? false);

            Future<void> captureSelfie() async {
              final file = await _captureSelfie();
              if (file == null) return;
              setSheetState(() {
                selfiePath = file.path;
              });
            }

            Future<void> submit() async {
              if (!canSubmit) return;
              setSheetState(() {
                isSubmitting = true;
              });
              try {
                await controller.checkIn(
                  address: addressController.text,
                  notes: notesController.text,
                  deviceName: deviceController.text,
                  selfiePath: selfiePath!,
                );
                if (!mounted) return;
                _checkInDraftAddress = null;
                _checkInDraftNotes = null;
                _checkInDraftDeviceName = null;
                _checkInDraftSelfiePath = null;
                Navigator.of(sheetContext).pop();
              } finally {
                if (mounted) {
                  setSheetState(() {
                    isSubmitting = false;
                  });
                }
              }
            }

            return _AttendanceActionSheet(
              title: l10n.confirmCheckIn,
              subtitle: l10n.checkInSheetDescription,
              isSubmitting: isSubmitting,
              selfiePath: selfiePath,
              onCaptureSelfie: captureSelfie,
              onRemoveSelfie: () {
                setSheetState(() {
                  selfiePath = null;
                });
              },
              onSubmit: submit,
              submitLabel: l10n.submitCheckIn,
              children: [
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: l10n.addressLabel),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  minLines: 2,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: l10n.notesLabel),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deviceController,
                  decoration: InputDecoration(labelText: l10n.deviceNameLabel),
                ),
              ],
            );
          },
        );
      },
    );

    _checkInDraftAddress = addressController.text;
    _checkInDraftNotes = notesController.text;
    _checkInDraftDeviceName = deviceController.text;
    _checkInDraftSelfiePath = selfiePath;
    addressController.dispose();
    notesController.dispose();
    deviceController.dispose();
  }

  Future<void> _openCheckOutSheet(BuildContext context) async {
    final l10n = context.l10n;
    final deviceController = TextEditingController(
      text: _checkOutDraftDeviceName ?? '$appBrandName Mobile',
    );
    var selfiePath = _checkOutDraftSelfiePath;
    var isSubmitting = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final canSubmit =
                !isSubmitting && (selfiePath?.isNotEmpty ?? false);

            Future<void> captureSelfie() async {
              final file = await _captureSelfie();
              if (file == null) return;
              setSheetState(() {
                selfiePath = file.path;
              });
            }

            Future<void> submit() async {
              if (!canSubmit) return;
              setSheetState(() {
                isSubmitting = true;
              });
              try {
                await controller.checkOut(
                  deviceName: deviceController.text,
                  selfiePath: selfiePath!,
                );
                if (!mounted) return;
                _checkOutDraftDeviceName = null;
                _checkOutDraftSelfiePath = null;
                Navigator.of(sheetContext).pop();
              } finally {
                if (mounted) {
                  setSheetState(() {
                    isSubmitting = false;
                  });
                }
              }
            }

            return _AttendanceActionSheet(
              title: l10n.confirmCheckOut,
              subtitle: l10n.checkOutSheetDescription,
              isSubmitting: isSubmitting,
              selfiePath: selfiePath,
              onCaptureSelfie: captureSelfie,
              onRemoveSelfie: () {
                setSheetState(() {
                  selfiePath = null;
                });
              },
              onSubmit: submit,
              submitLabel: l10n.submitCheckOut,
              children: [
                TextField(
                  controller: deviceController,
                  decoration: InputDecoration(labelText: l10n.deviceNameLabel),
                ),
              ],
            );
          },
        );
      },
    );

    _checkOutDraftDeviceName = deviceController.text;
    _checkOutDraftSelfiePath = selfiePath;
    deviceController.dispose();
  }

  Future<XFile?> _captureSelfie() async {
    final picker = ImagePicker();
    return picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 85,
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.summary});

  final AttendanceSummary? summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusTone = _TodayStatusTone.fromSummary(
      context,
      colorScheme,
      summary,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: statusTone.backgroundColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.todayStatus,
            style: theme.textTheme.labelLarge?.copyWith(
              color: statusTone.foregroundColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statusTone.title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: statusTone.foregroundColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statusTone.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: statusTone.foregroundColor.withValues(alpha: 0.86),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.lines,
  });

  final String title;
  final IconData icon;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 20,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            ...lines.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  line,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceActionSheet extends StatelessWidget {
  const _AttendanceActionSheet({
    required this.title,
    required this.subtitle,
    required this.children,
    required this.isSubmitting,
    required this.selfiePath,
    required this.onCaptureSelfie,
    required this.onRemoveSelfie,
    required this.onSubmit,
    required this.submitLabel,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool isSubmitting;
  final String? selfiePath;
  final VoidCallback onCaptureSelfie;
  final VoidCallback onRemoveSelfie;
  final VoidCallback onSubmit;
  final String submitLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasSelfie = selfiePath != null && selfiePath!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                ...children,
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer.withValues(
                      alpha: 0.55,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.selfieProofTitle,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hasSelfie
                            ? l10n.selfieAttached
                            : l10n.selfieRequiredHint,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: isSubmitting ? null : onCaptureSelfie,
                              icon: Icon(
                                hasSelfie
                                    ? Icons.refresh_rounded
                                    : Icons.photo_camera_rounded,
                              ),
                              label: Text(
                                hasSelfie
                                    ? l10n.retakeSelfie
                                    : l10n.captureSelfie,
                              ),
                            ),
                          ),
                          if (hasSelfie) ...[
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: isSubmitting ? null : onRemoveSelfie,
                              child: Text(l10n.removeSelfie),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: isSubmitting || !hasSelfie ? null : onSubmit,
                        child: Text(
                          isSubmitting
                              ? l10n.submittingAttendance
                              : submitLabel,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TodayStatusTone {
  const _TodayStatusTone({
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String title;
  final String description;
  final Color backgroundColor;
  final Color foregroundColor;

  factory _TodayStatusTone.fromSummary(
    BuildContext context,
    ColorScheme colorScheme,
    AttendanceSummary? summary,
  ) {
    final l10n = context.l10n;

    if (summary == null) {
      return _TodayStatusTone(
        title: l10n.statusToneLoadingTitle,
        description: l10n.statusToneLoadingDescription,
        backgroundColor: colorScheme.surfaceContainerHighest,
        foregroundColor: colorScheme.onSurface,
      );
    }

    if (summary.checkedOut) {
      return _TodayStatusTone(
        title: l10n.statusToneDoneTitle,
        description: l10n.statusToneDoneDescription,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      );
    }

    if (summary.checkedIn) {
      return _TodayStatusTone(
        title: l10n.statusToneCheckedInTitle,
        description: l10n.statusToneCheckedInDescription,
        backgroundColor: colorScheme.secondaryContainer,
        foregroundColor: colorScheme.onSecondaryContainer,
      );
    }

    return _TodayStatusTone(
      title: l10n.statusToneReadyTitle,
      description: l10n.statusToneReadyDescription,
      backgroundColor: colorScheme.tertiaryContainer,
      foregroundColor: colorScheme.onTertiaryContainer,
    );
  }
}
