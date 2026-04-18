import 'package:flutter/material.dart';

import 'package:artisan_hr/app/app_controller.dart';
import 'package:artisan_hr/app/presentation/app_brand.dart';
import 'package:artisan_hr/features/attendance/data/models/attendance_log.dart';
import 'package:artisan_hr/shared/localization/l10n.dart';
import 'package:artisan_hr/shared/presentation/widgets/empty_state.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({required this.controller, super.key});

  final AppController controller;

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
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
      final logs = await widget.controller.getAttendanceLogsForMonth(
        _selectedMonth,
      );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        children: const [
          _HistoryLoadingCard(height: 64),
          SizedBox(height: 16),
          _HistoryLoadingCard(height: 180),
          SizedBox(height: 16),
          _HistoryLoadingCard(height: 88),
          SizedBox(height: 12),
          _HistoryLoadingCard(height: 88),
        ],
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyState(
              icon: Icons.error_outline,
              title: l10n.unableToLoadHistory,
              description: l10n.historyLoadErrorHint,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _loadLogs,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.refreshTooltip),
            ),
          ],
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
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          AppBrandPalette.nightCard,
                          AppBrandPalette.nightSurface,
                        ]
                      : [Color(0xFFFFFFFF), Color(0xFFF1FAF6)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  const PresenseMark(size: 44),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.historySummaryTitle,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.historySummaryDescription,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                height: 1.45,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
  const _MonthPickerButton({required this.value, required this.onTap});

  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: colorScheme.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _formatMonthYear(context, value),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: colorScheme.onSurfaceVariant,
              size: 34,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryLoadingCard extends StatelessWidget {
  const _HistoryLoadingCard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
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
    final colorScheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant);
    final valueStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      color: colorScheme.primary,
      fontWeight: FontWeight.w700,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.92),
              AppBrandPalette.softMint,
            ],
          ),
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
                  color: colorScheme.primaryContainer.withValues(alpha: 0.75),
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
                  color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(110),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.historySummaryTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.historySummaryDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.78,
                    ),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
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
        Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: labelStyle,
        ),
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
    final subtitleStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(color: entry.highlightColor);
    final timeStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      color: entry.checkInColor,
      fontWeight: FontWeight.w600,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
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
            child: Center(child: Text(entry.checkInText, style: timeStyle)),
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
  final colorScheme = Theme.of(context).colorScheme;

  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: months
                        .map((month) {
                          final isSelected =
                              month.year == selectedMonth.year &&
                              month.month == selectedMonth.month;
                          return ListTile(
                            title: Text(
                              _formatMonthYear(context, month),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check_circle_rounded,
                                    color: colorScheme.primary,
                                  )
                                : null,
                            textColor: colorScheme.onSurface,
                            iconColor: colorScheme.primary,
                            selected: isSelected,
                            selectedTileColor: colorScheme.primaryContainer
                                .withValues(alpha: 0.28),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            onTap: () => Navigator.of(context).pop(month),
                          );
                        })
                        .toList(growable: false),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
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
    groupedLogs
        .putIfAbsent(log.attendanceDate, () => <AttendanceLog>[])
        .add(log);
  }

  final now = DateTime.now();
  final lastDay = DateTime(month.year, month.month + 1, 0);
  final maxVisibleDay = month.year == now.year && month.month == now.month
      ? now.day
      : lastDay.day;

  final shiftLabel = (shiftName == null || shiftName.trim().isEmpty)
      ? l10n.workShift
      : shiftName;
  final shiftStartMinutes = _parseTimeToMinutes(shiftStartTime);
  final shiftEndMinutes = _parseTimeToMinutes(shiftEndTime);

  final entries = <_DailyHistoryEntry>[];
  for (var day = maxVisibleDay; day >= 1; day--) {
    final date = DateTime(month.year, month.month, day);
    final dateKey = _formatDate(date);
    final dayLogs = List<AttendanceLog>.from(groupedLogs[dateKey] ?? const [])
      ..sort((left, right) {
        final leftTime =
            left.loggedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final rightTime =
            right.loggedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
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

    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    final hasAnyLog = dayLogs.isNotEmpty;
    final hasCheckIn = checkInLog != null;
    final hasCheckOut = checkOutLog != null;
    final checkInText = _formatTime(checkInLog?.loggedAt);
    final checkOutText = _formatTime(checkOutLog?.loggedAt);
    final checkInMinutes = _timeOfDayMinutes(checkInLog?.loggedAt);
    final checkOutMinutes = _timeOfDayMinutes(checkOutLog?.loggedAt);
    final isLateClockIn =
        hasCheckIn &&
        shiftStartMinutes != null &&
        checkInMinutes != null &&
        checkInMinutes > shiftStartMinutes;
    final isEarlyClockOut =
        hasCheckOut &&
        shiftEndMinutes != null &&
        checkOutMinutes != null &&
        checkOutMinutes < shiftEndMinutes;

    final subtitle = hasAnyLog
        ? (isWeekend ? l10n.weekend : shiftLabel)
        : (isWeekend ? l10n.weekend : l10n.noAttendanceRecord);
    final highlightColor = hasAnyLog
        ? AppBrandPalette.ink
        : (isWeekend ? const Color(0xFFD36A2B) : const Color(0xFF6B7280));
    final checkInColor = isLateClockIn
        ? const Color(0xFFD36A2B)
        : AppBrandPalette.ink;
    final checkOutColor = isEarlyClockOut
        ? const Color(0xFFD36A2B)
        : AppBrandPalette.ink;

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
        entry.date.weekday == DateTime.saturday ||
        entry.date.weekday == DateTime.sunday;
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
