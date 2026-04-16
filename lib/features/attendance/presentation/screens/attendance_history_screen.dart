import 'package:flutter/material.dart';

import '../../../../app/app_controller.dart';
import '../../../../shared/localization/l10n.dart';
import '../../../../shared/presentation/widgets/empty_state.dart';
import '../../data/models/attendance_log.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({required this.controller, super.key});

  final AppController controller;

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  late DateTime _selectedMonth;
  bool _isLoading = true;
  String? _errorMessage;
  List<AttendanceLog> _logs = const [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final logs = await widget.controller.getAttendanceLogsForMonth(_selectedMonth);
      if (!mounted) return;
      setState(() {
        _logs = logs;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final entries = _buildEntries(
      context: context,
      logs: _logs,
      month: _selectedMonth,
      shiftName: widget.controller.shiftToday?.shiftName,
      shiftStartTime: widget.controller.shiftToday?.startTime,
      shiftEndTime: widget.controller.shiftToday?.endTime,
    );
    final summary = _buildSummary(entries);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: EmptyState(
          icon: Icons.error_outline,
          title: l10n.unableToLoadHistory,
          description: _errorMessage!,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLogs,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _MonthPickerButton(
              value: _selectedMonth,
              onTap: () async {
                final nextMonth = await _pickMonth(context, _selectedMonth);
                if (nextMonth == null) return;
                setState(() {
                  _selectedMonth = nextMonth;
                });
                await _loadLogs();
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SummaryCard(summary: summary),
          ),
          const SizedBox(height: 16),
          if (entries.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: EmptyState(
                icon: Icons.history,
                title: l10n.noAttendanceLogsYet,
                description: l10n.noAttendanceLogsDescription,
              ),
            )
          else
            ...entries.map((entry) => _HistoryRow(entry: entry)),
        ],
      ),
    );
  }
}

class _MonthPickerButton extends StatelessWidget {
  const _MonthPickerButton({
    required this.value,
    required this.onTap,
  });

  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: Color(0xFF6B7280)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _formatMonthYear(context, value),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280), size: 34),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final _MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF667085),
        );
    final valueStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          color: const Color(0xFF1565C0),
          fontWeight: FontWeight.w700,
        );

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F8FF),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -24,
              right: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFDAE8F7),
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
            ),
            Positioned(
              bottom: -90,
              right: -10,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1E2F6),
                  borderRadius: BorderRadius.circular(110),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _SummaryMetric(
                        label: l10n.noRecord,
                        value: summary.noRecordCount,
                        labelStyle: labelStyle,
                        valueStyle: valueStyle,
                      ),
                    ),
                    Expanded(
                      child: _SummaryMetric(
                        label: l10n.lateClockIn,
                        value: summary.lateClockInCount,
                        labelStyle: labelStyle,
                        valueStyle: valueStyle,
                      ),
                    ),
                    Expanded(
                      child: _SummaryMetric(
                        label: l10n.earlyClockOut,
                        value: summary.earlyClockOutCount,
                        labelStyle: labelStyle,
                        valueStyle: valueStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryMetric(
                        label: l10n.noClockIn,
                        value: summary.noClockInCount,
                        labelStyle: labelStyle,
                        valueStyle: valueStyle,
                      ),
                    ),
                    Expanded(
                      child: _SummaryMetric(
                        label: l10n.noClockOut,
                        value: summary.noClockOutCount,
                        labelStyle: labelStyle,
                        valueStyle: valueStyle,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  final String label;
  final int value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, maxLines: 2, overflow: TextOverflow.ellipsis, style: labelStyle),
        const SizedBox(height: 10),
        Text('$value', style: valueStyle),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});

  final _DailyHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final dateStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: entry.highlightColor,
        );
    final subtitleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: entry.highlightColor,
        );
    final timeStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          color: entry.checkInColor,
          fontWeight: FontWeight.w600,
        );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.dayLabel, style: dateStyle),
                const SizedBox(height: 8),
                Text(entry.subtitle, style: subtitleStyle),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(entry.checkInText, style: timeStyle),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                entry.checkOutText,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: entry.checkOutColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          const Icon(Icons.chevron_right, size: 38, color: Color(0xFF8E8E93)),
        ],
      ),
    );
  }
}

class _DailyHistoryEntry {
  const _DailyHistoryEntry({
    required this.date,
    required this.dayLabel,
    required this.subtitle,
    required this.checkInText,
    required this.checkOutText,
    required this.checkInColor,
    required this.checkOutColor,
    required this.highlightColor,
    required this.hasAnyLog,
    required this.hasCheckIn,
    required this.hasCheckOut,
    required this.isLateClockIn,
    required this.isEarlyClockOut,
  });

  final DateTime date;
  final String dayLabel;
  final String subtitle;
  final String checkInText;
  final String checkOutText;
  final Color checkInColor;
  final Color checkOutColor;
  final Color highlightColor;
  final bool hasAnyLog;
  final bool hasCheckIn;
  final bool hasCheckOut;
  final bool isLateClockIn;
  final bool isEarlyClockOut;

}

class _MonthlySummary {
  const _MonthlySummary({
    required this.noRecordCount,
    required this.lateClockInCount,
    required this.earlyClockOutCount,
    required this.noClockInCount,
    required this.noClockOutCount,
  });

  final int noRecordCount;
  final int lateClockInCount;
  final int earlyClockOutCount;
  final int noClockInCount;
  final int noClockOutCount;
}

Future<DateTime?> _pickMonth(BuildContext context, DateTime selectedMonth) {
  final now = DateTime.now();
  final months = List<DateTime>.generate(
    12,
    (index) => DateTime(now.year, now.month - index),
  );

  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.white,
    builder: (context) {
      return SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: months.map((month) {
            final isSelected =
                month.year == selectedMonth.year && month.month == selectedMonth.month;
            return ListTile(
              title: Text(_formatMonthYear(context, month)),
              trailing: isSelected
                  ? const Icon(Icons.check, color: Color(0xFFC62828))
                  : null,
              onTap: () => Navigator.of(context).pop(month),
            );
          }).toList(growable: false),
        ),
      );
    },
  );
}

List<_DailyHistoryEntry> _buildEntries({
  required BuildContext context,
  required List<AttendanceLog> logs,
  required DateTime month,
  required String? shiftName,
  required String? shiftStartTime,
  required String? shiftEndTime,
}) {
  final l10n = context.l10n;
  final groupedLogs = <String, List<AttendanceLog>>{};
  for (final log in logs) {
    groupedLogs.putIfAbsent(log.attendanceDate, () => <AttendanceLog>[]).add(log);
  }

  final now = DateTime.now();
  final lastDay = DateTime(month.year, month.month + 1, 0);
  final maxVisibleDay = month.year == now.year && month.month == now.month
      ? now.day
      : lastDay.day;

  final shiftLabel = (shiftName == null || shiftName.trim().isEmpty) ? l10n.workShift : shiftName;
  final shiftStartMinutes = _parseTimeToMinutes(shiftStartTime);
  final shiftEndMinutes = _parseTimeToMinutes(shiftEndTime);

  final entries = <_DailyHistoryEntry>[];
  for (var day = maxVisibleDay; day >= 1; day--) {
    final date = DateTime(month.year, month.month, day);
    final dateKey = _formatDate(date);
    final dayLogs = List<AttendanceLog>.from(groupedLogs[dateKey] ?? const [])
      ..sort((left, right) {
        final leftTime = left.loggedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final rightTime = right.loggedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return leftTime.compareTo(rightTime);
      });

    AttendanceLog? checkInLog;
    AttendanceLog? checkOutLog;
    for (final log in dayLogs) {
      if (log.type == 'check_in' && checkInLog == null) {
        checkInLog = log;
      }
      if (log.type == 'check_out') {
        checkOutLog = log;
      }
    }

    final isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    final hasAnyLog = dayLogs.isNotEmpty;
    final hasCheckIn = checkInLog != null;
    final hasCheckOut = checkOutLog != null;
    final checkInText = _formatTime(checkInLog?.loggedAt);
    final checkOutText = _formatTime(checkOutLog?.loggedAt);
    final checkInMinutes = _timeOfDayMinutes(checkInLog?.loggedAt);
    final checkOutMinutes = _timeOfDayMinutes(checkOutLog?.loggedAt);
    final isLateClockIn = hasCheckIn &&
        shiftStartMinutes != null &&
        checkInMinutes != null &&
        checkInMinutes > shiftStartMinutes;
    final isEarlyClockOut = hasCheckOut &&
        shiftEndMinutes != null &&
        checkOutMinutes != null &&
        checkOutMinutes < shiftEndMinutes;

    final subtitle = hasAnyLog
        ? (isWeekend ? l10n.weekend : shiftLabel)
        : (isWeekend ? l10n.weekend : l10n.noAttendanceRecord);
    final highlightColor = hasAnyLog
        ? const Color(0xFF111827)
        : (isWeekend ? const Color(0xFFD84315) : const Color(0xFF6B7280));
    final checkInColor = isLateClockIn ? const Color(0xFFD84315) : const Color(0xFF111827);
    final checkOutColor = isEarlyClockOut ? const Color(0xFFD84315) : const Color(0xFF111827);

    entries.add(
      _DailyHistoryEntry(
        date: date,
        dayLabel: MaterialLocalizations.of(context).formatShortMonthDay(date),
        subtitle: subtitle,
        checkInText: checkInText,
        checkOutText: checkOutText,
        checkInColor: checkInColor,
        checkOutColor: checkOutColor,
        highlightColor: highlightColor,
        hasAnyLog: hasAnyLog,
        hasCheckIn: hasCheckIn,
        hasCheckOut: hasCheckOut,
        isLateClockIn: isLateClockIn,
        isEarlyClockOut: isEarlyClockOut,
      ),
    );
  }

  return entries;
}

_MonthlySummary _buildSummary(List<_DailyHistoryEntry> entries) {
  var noRecordCount = 0;
  var lateClockInCount = 0;
  var earlyClockOutCount = 0;
  var noClockInCount = 0;
  var noClockOutCount = 0;

  for (final entry in entries) {
    final isWeekend =
        entry.date.weekday == DateTime.saturday || entry.date.weekday == DateTime.sunday;
    if (!entry.hasAnyLog && !isWeekend) {
      noRecordCount += 1;
    }
    if (entry.isLateClockIn) {
      lateClockInCount += 1;
    }
    if (entry.isEarlyClockOut) {
      earlyClockOutCount += 1;
    }
    if (!entry.hasCheckIn && entry.hasCheckOut) {
      noClockInCount += 1;
    }
    if (entry.hasCheckIn && !entry.hasCheckOut) {
      noClockOutCount += 1;
    }
  }

  return _MonthlySummary(
    noRecordCount: noRecordCount,
    lateClockInCount: lateClockInCount,
    earlyClockOutCount: earlyClockOutCount,
    noClockInCount: noClockInCount,
    noClockOutCount: noClockOutCount,
  );
}

String _formatMonthYear(BuildContext context, DateTime value) {
  return MaterialLocalizations.of(context).formatMonthYear(value);
}

String _formatDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

String _formatTime(DateTime? value) {
  if (value == null) return '-';
  final local = value.toLocal();
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

int? _parseTimeToMinutes(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  final segments = value.split(':');
  if (segments.length < 2) return null;
  final hour = int.tryParse(segments[0]);
  final minute = int.tryParse(segments[1]);
  if (hour == null || minute == null) return null;
  return (hour * 60) + minute;
}

int? _timeOfDayMinutes(DateTime? value) {
  if (value == null) return null;
  final local = value.toLocal();
  return (local.hour * 60) + local.minute;
}
