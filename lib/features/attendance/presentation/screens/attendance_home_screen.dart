import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/app_controller.dart';
import '../../../../shared/presentation/widgets/empty_state.dart';
import '../../../../shared/utils/formatters.dart';

class AttendanceHomeScreen extends StatelessWidget {
  const AttendanceHomeScreen({required this.controller, super.key});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final strings = controller.strings;
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
            employee?.fullName ?? controller.user?.userName ?? strings.employeeFallback,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            employee?.employeeNo != null
                ? strings.employeeNoLabel(employee!.employeeNo ?? '-')
                : controller.user?.tenantName ?? strings.attendanceDashboard,
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
                    strings.todaySummary,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (summary == null)
                    Text(strings.noSummary)
                  else ...[
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _SummaryChip(
                          label: strings.attendanceDate,
                          value: summary.attendanceDate,
                        ),
                        _SummaryChip(
                          label: strings.checkedIn,
                          value: strings.yesNo(summary.checkedIn),
                        ),
                        _SummaryChip(
                          label: strings.checkedOut,
                          value: strings.yesNo(summary.checkedOut),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      summary.lastLoggedAt == null
                          ? strings.noAttendanceActivity
                          : strings.lastActivity(summary.lastLogType ?? '-', formatDateTime(summary.lastLoggedAt)),
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
                          label: Text(strings.checkIn),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: controller.canCheckOut
                              ? () => _showCheckOutDialog(context)
                              : null,
                          icon: const Icon(Icons.logout),
                          label: Text(strings.checkOut),
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
                  title: strings.shiftToday,
                  lines: shift == null
                      ? [strings.noShiftScheduled]
                      : [
                          shift.shiftName ?? strings.unnamedShift,
                          strings.startLabel(shift.startTime ?? '-'),
                          strings.endLabel(shift.endTime ?? '-'),
                        ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _InfoCard(
                  title: strings.attendancePolicy,
                  lines: policy == null
                      ? [strings.noPolicy]
                      : [
                          strings.timezoneLabel(policy.timezone),
                          strings.checkInRange(policy.checkInStart ?? '-', policy.checkInEnd ?? '-'),
                          strings.checkOutRange(policy.checkOutStart ?? '-', policy.checkOutEnd ?? '-'),
                        ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: strings.profile,
            lines: employee == null
                ? [strings.employeeProfileMissing]
                : [
                    strings.nameLabel(employee.fullName),
                    strings.emailValue(employee.email ?? '-'),
                    strings.statusLabel(employee.status ?? '-'),
                    strings.photoProofRequired,
                  ],
          ),
          const SizedBox(height: 16),
          Text(
            strings.recentActivity,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          if (recentLogs.isEmpty)
            EmptyState(
              icon: Icons.fact_check_outlined,
              title: strings.noRecentLogs,
              description: strings.noRecentLogsDescription,
            )
          else
            ...recentLogs.map(
              (log) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: ListTile(
                    title: Text(log.type.replaceAll('_', ' ').toUpperCase()),
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
    final strings = controller.strings;
    final notesController = TextEditingController();
    final addressController = TextEditingController();
    final deviceController = TextEditingController(text: 'Artisan HR App');

    final shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(strings.confirmCheckIn),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: strings.addressLabel),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(labelText: strings.notesLabel),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deviceController,
                  decoration: InputDecoration(labelText: strings.deviceNameLabel),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(strings.submit),
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
    final strings = controller.strings;
    final deviceController = TextEditingController(text: 'Artisan HR App');

    final shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(strings.confirmCheckOut),
          content: TextField(
            controller: deviceController,
            decoration: InputDecoration(labelText: strings.deviceNameLabel),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(strings.submit),
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
