import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/day_log.dart';
import '../theme/app_theme.dart';

class StatChart extends StatelessWidget {
  final List<DayLog> logs;

  const StatChart({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No data yet — complete some tasks!',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
      );
    }

    final maxY = logs.fold<int>(0, (max, log) {
      final val = log.xpEarned > log.xpLost ? log.xpEarned : log.xpLost;
      return val > max ? val : max;
    }).toDouble();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY > 0 ? maxY * 1.2 : 100,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final i = value.toInt();
                  if (i < 0 || i >= logs.length) return const SizedBox.shrink();
                  // Show day abbreviation from date
                  final date = DateTime.tryParse(logs[i].date);
                  if (date == null) return const SizedBox.shrink();
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      days[date.weekday - 1],
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(logs.length, (i) {
            final log = logs[i];
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: log.xpEarned.toDouble(),
                  color: AppTheme.successGreen,
                  width: 12,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
                BarChartRodData(
                  toY: log.xpLost.toDouble(),
                  color: AppTheme.penaltyRed,
                  width: 12,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
