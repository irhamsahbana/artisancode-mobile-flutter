import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/app_controller.dart';
import '../../../../shared/localization/l10n.dart';
import '../../../../shared/presentation/widgets/empty_state.dart';
import '../../../../shared/utils/formatters.dart';

class AttendanceHomeScreen extends StatelessWidget {
  const AttendanceHomeScreen({required this.controller, super.key});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            employee?.fullName ?? controller.user?.userName ?? l10n.employeeFallback,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            employee?.employeeNo != null
                ? l10n.employeeNoLabel(employee!.employeeNo ?? '-')
                : controller.user?.tenantName ?? l10n.attendanceDashboard,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.todaySummary,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (summary == null)
                    Text(l10n.noSummary)
                  else ...[
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _SummaryChip(
                          label: l10n.attendanceDate,
                          value: summary.attendanceDate,
                        ),
                        _SummaryChip(
                          label: l10n.checkedIn,
                          value: summary.checkedIn ? l10n.yesLabel : l10n.noLabel,
                        ),
                        _SummaryChip(
                          label: l10n.checkedOut,
                          value: summary.checkedOut ? l10n.yesLabel : l10n.noLabel,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      summary.lastLoggedAt == null
                          ? l10n.noAttendanceActivity
                          : l10n.lastActivity(summary.lastLogType ?? '-', formatDateTime(summary.lastLoggedAt)),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: controller.canCheckIn
                              ? () => _showCheckInDialog(context)
                              : null,
                          icon: const Icon(Icons.login),
                          label: Text(l10n.checkIn),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: controller.canCheckOut
                              ? () => _showCheckOutDialog(context)
                              : null,
                          icon: const Icon(Icons.logout),
                          label: Text(l10n.checkOut),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  title: l10n.shiftToday,
                  lines: shift == null
                      ? [l10n.noShiftScheduled]
                      : [
                          shift.shiftName ?? l10n.unnamedShift,
                          l10n.startLabel(shift.startTime ?? '-'),
                          l10n.endLabel(shift.endTime ?? '-'),
                        ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _InfoCard(
                  title: l10n.attendancePolicy,
                  lines: policy == null
                      ? [l10n.noPolicy]
                      : [
                          l10n.timezoneLabel(policy.timezone),
                          l10n.checkInRange(policy.checkInStart ?? '-', policy.checkInEnd ?? '-'),
                          l10n.checkOutRange(policy.checkOutStart ?? '-', policy.checkOutEnd ?? '-'),
                        ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: l10n.profile,
            lines: employee == null
                ? [l10n.employeeProfileMissing]
                : [
                    l10n.nameLabel(employee.fullName),
                    l10n.emailValue(employee.email ?? '-'),
                    l10n.statusLabel(employee.status ?? '-'),
                    l10n.photoProofRequired,
                  ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.recentActivity,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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
                    title: Text(log.type == 'check_in' ? l10n.checkIn : l10n.checkOut),
                    subtitle: Text(formatDateTime(log.loggedAt)),
                    trailing: Text(log.source),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showCheckInDialog(BuildContext context) async {
    final l10n = context.l10n;
    final notesController = TextEditingController();
    final addressController = TextEditingController();
    final deviceController = TextEditingController(text: 'Artisan HR App');

    final shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.confirmCheckIn),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: l10n.addressLabel),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(labelText: l10n.notesLabel),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deviceController,
                  decoration: InputDecoration(labelText: l10n.deviceNameLabel),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.submit),
            ),
          ],
        );
      },
    );

    if (shouldSubmit == true) {
      try {
        final selfie = await _captureSelfie();
        if (selfie == null) {
          return;
        }
        await controller.checkIn(
          address: addressController.text,
          notes: notesController.text,
          deviceName: deviceController.text,
          selfiePath: selfie.path,
        );
      } finally {
        notesController.dispose();
        addressController.dispose();
        deviceController.dispose();
      }
    } else {
      notesController.dispose();
      addressController.dispose();
      deviceController.dispose();
    }
  }

  Future<void> _showCheckOutDialog(BuildContext context) async {
    final l10n = context.l10n;
    final deviceController = TextEditingController(text: 'Artisan HR App');

    final shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.confirmCheckOut),
          content: TextField(
            controller: deviceController,
            decoration: InputDecoration(labelText: l10n.deviceNameLabel),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.submit),
            ),
          ],
        );
      },
    );

    if (shouldSubmit == true) {
      try {
        final selfie = await _captureSelfie();
        if (selfie == null) {
          return;
        }
        await controller.checkOut(
          deviceName: deviceController.text,
          selfiePath: selfie.path,
        );
      } finally {
        deviceController.dispose();
      }
    } else {
      deviceController.dispose();
    }
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

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            ...lines.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(line),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
