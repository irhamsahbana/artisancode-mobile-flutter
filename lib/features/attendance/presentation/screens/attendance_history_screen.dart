import 'package:flutter/material.dart';

import '../../../../app/app_controller.dart';
import '../../../../shared/presentation/widgets/empty_state.dart';
import '../../../../shared/utils/formatters.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({required this.controller, super.key});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final logs = controller.attendanceLogs;

    if (logs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: EmptyState(
          icon: Icons.history,
          title: 'No attendance logs yet',
          description: 'Your attendance history will appear here after you check in or check out.',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshHistory,
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: logs.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final log = logs[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _badgeColor(log.type),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          log.type.replaceAll('_', ' ').toUpperCase(),
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        log.attendanceDate,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoLine(label: 'Logged at', value: formatDateTime(log.loggedAt)),
                  _InfoLine(label: 'Source', value: log.source),
                  if ((log.address ?? '').isNotEmpty)
                    _InfoLine(label: 'Address', value: log.address!),
                  if ((log.notes ?? '').isNotEmpty) _InfoLine(label: 'Notes', value: log.notes!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _badgeColor(String type) {
    switch (type) {
      case 'check_in':
        return const Color(0xFF0F766E);
      case 'check_out':
        return const Color(0xFFB45309);
      default:
        return const Color(0xFF475569);
    }
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
