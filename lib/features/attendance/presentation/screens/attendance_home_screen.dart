import 'package:flutter/material.dart';

import '../../../../app/app_controller.dart';
import '../../../../shared/presentation/widgets/empty_state.dart';
import '../../../../shared/utils/formatters.dart';

class AttendanceHomeScreen extends StatelessWidget {
  const AttendanceHomeScreen({required this.controller, super.key});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final employee = controller.employee;
    final summary = controller.summary;
    final shift = controller.shiftToday;
    final policy = controller.policy;
    final recentLogs = controller.attendanceLogs.take(3).toList(growable: false);

    return RefreshIndicator(
      onRefresh: controller.refreshAll,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            employee?.fullName ?? controller.user?.userName ?? 'Employee',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            employee?.employeeNo != null
                ? 'Employee No: ${employee!.employeeNo}'
                : controller.user?.tenantName ?? 'Attendance dashboard',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today Summary',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (summary == null)
                    const Text('No summary data is available yet.')
                  else ...[
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _SummaryChip(
                          label: 'Attendance Date',
                          value: summary.attendanceDate,
                        ),
                        _SummaryChip(
                          label: 'Checked In',
                          value: summary.checkedIn ? 'Yes' : 'No',
                        ),
                        _SummaryChip(
                          label: 'Checked Out',
                          value: summary.checkedOut ? 'Yes' : 'No',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      summary.lastLoggedAt == null
                          ? 'No attendance activity recorded yet today.'
                          : 'Last activity: ${summary.lastLogType ?? '-'} at ${formatDateTime(summary.lastLoggedAt)}',
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
                          label: const Text('Check In'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: controller.canCheckOut
                              ? () => _showCheckOutDialog(context)
                              : null,
                          icon: const Icon(Icons.logout),
                          label: const Text('Check Out'),
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
                  title: 'Shift Today',
                  lines: shift == null
                      ? const ['No shift scheduled today.']
                      : [
                          shift.shiftName ?? 'Unnamed shift',
                          'Start: ${shift.startTime ?? '-'}',
                          'End: ${shift.endTime ?? '-'}',
                        ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _InfoCard(
                  title: 'Attendance Policy',
                  lines: policy == null
                      ? const ['No policy data available.']
                      : [
                          'Timezone: ${policy.timezone}',
                          'Check-in: ${policy.checkInStart ?? '-'} - ${policy.checkInEnd ?? '-'}',
                          'Check-out: ${policy.checkOutStart ?? '-'} - ${policy.checkOutEnd ?? '-'}',
                        ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Profile',
            lines: employee == null
                ? const ['Employee profile not found for this user.']
                : [
                    'Name: ${employee.fullName}',
                    'Email: ${employee.email ?? '-'}',
                    'Status: ${employee.status ?? '-'}',
                  ],
          ),
          const SizedBox(height: 16),
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          if (recentLogs.isEmpty)
            const EmptyState(
              icon: Icons.fact_check_outlined,
              title: 'No recent logs',
              description: 'Your latest attendance actions will show up here.',
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
    final notesController = TextEditingController();
    final addressController = TextEditingController();
    final deviceController = TextEditingController(text: 'Artisan HR App');

    final shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Check In'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deviceController,
                  decoration: const InputDecoration(labelText: 'Device name'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );

    if (shouldSubmit == true) {
      try {
        await controller.checkIn(
          address: addressController.text,
          notes: notesController.text,
          deviceName: deviceController.text,
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
    final deviceController = TextEditingController(text: 'Artisan HR App');

    final shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Check Out'),
          content: TextField(
            controller: deviceController,
            decoration: const InputDecoration(labelText: 'Device name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );

    if (shouldSubmit == true) {
      try {
        await controller.checkOut(deviceName: deviceController.text);
      } finally {
        deviceController.dispose();
      }
    } else {
      deviceController.dispose();
    }
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
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
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
