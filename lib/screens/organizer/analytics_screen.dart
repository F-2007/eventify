import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/event_model.dart';
import '../../services/auth_service.dart';
import '../../services/event_service.dart';
import '../../services/ticket_service.dart';
import '../../services/qr_service.dart';
import '../../theme/app_colors.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<EventModel> _events = [];
  int _totalTickets = 0;
  int _totalCheckIns = 0;
  double _totalRevenue = 0;
  Map<String, int> _ticketsPerEvent = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) return;

    try {
      // Get organizer's events
      final events =
          await EventService.getEventsByCreator(currentUser.id);

      int totalTickets = 0;
      int totalCheckIns = 0;
      double totalRevenue = 0;
      Map<String, int> ticketsPerEvent = {};

      for (final event in events) {
        // Get tickets for each event
        final tickets =
            await TicketService.getTicketsByEvent(event.id);
        ticketsPerEvent[event.title] = tickets.length;
        totalTickets += tickets.length;
        totalRevenue += tickets.length * event.price;

        // Get check-ins for each event
        final checkIns = await QRService.getCheckIns(event.id);
        totalCheckIns += checkIns.length;
      }

      if (mounted) {
        setState(() {
          _events = events;
          _totalTickets = totalTickets;
          _totalCheckIns = totalCheckIns;
          _totalRevenue = totalRevenue;
          _ticketsPerEvent = ticketsPerEvent;
          _isLoading = false;
        });
      }
    } catch (e) {
      print(' Analytics error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Event Analytics",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Real-time data from your events.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 25),

          /// Stat Cards
          Row(
            children: [
              Expanded(
                child: buildStatCard(
                  icon: Icons.event,
                  title: "Events",
                  value: _events.length.toString(),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: buildStatCard(
                  icon: Icons.confirmation_num,
                  title: "Tickets",
                  value: _totalTickets.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: buildStatCard(
                  icon: Icons.qr_code_scanner,
                  title: "Check-ins",
                  value: _totalCheckIns.toString(),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: buildStatCard(
                  icon: Icons.attach_money,
                  title: "Revenue",
                  value: "\$${_totalRevenue.toStringAsFixed(0)}",
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          /// Bar Chart — Tickets per Event
          if (_ticketsPerEvent.isNotEmpty) ...[
            const Text(
              "Tickets per Event",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (_ticketsPerEvent.values.isEmpty
                          ? 10
                          : _ticketsPerEvent.values
                                  .reduce((a, b) => a > b ? a : b) +
                              2)
                      .toDouble(),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final eventName = _ticketsPerEvent.keys
                            .elementAt(group.x.toInt());
                        return BarTooltipItem(
                          '$eventName\n${rod.toY.toInt()} tickets',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < _ticketsPerEvent.keys.length) {
                            final name = _ticketsPerEvent.keys
                                .elementAt(index);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                name.length > 8
                                    ? '${name.substring(0, 8)}...'
                                    : name,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withValues(alpha: 0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _ticketsPerEvent.entries
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.value.toDouble(),
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.secondary,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          width: 22,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],

          /// Pie Chart — Check-in Rate
          if (_totalTickets > 0) ...[
            const Text(
              "Check-in Rate",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: 220,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 35,
                        sections: [
                          PieChartSectionData(
                            color: Colors.green,
                            value: _totalCheckIns.toDouble(),
                            title:
                                '${((_totalCheckIns / _totalTickets) * 100).toStringAsFixed(0)}%',
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            radius: 50,
                          ),
                          PieChartSectionData(
                            color: Colors.grey.shade300,
                            value: (_totalTickets - _totalCheckIns)
                                .toDouble(),
                            title:
                                '${(((_totalTickets - _totalCheckIns) / _totalTickets) * 100).toStringAsFixed(0)}%',
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                            radius: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem(
                        color: Colors.green,
                        label: "Checked In",
                        value: _totalCheckIns.toString(),
                      ),
                      const SizedBox(height: 12),
                      _buildLegendItem(
                        color: Colors.grey.shade300,
                        label: "Not Yet",
                        value: (_totalTickets - _totalCheckIns)
                            .toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          if (_ticketsPerEvent.isEmpty && _totalTickets == 0) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Icon(Icons.bar_chart, color: Colors.grey, size: 48),
                  SizedBox(height: 12),
                  Text(
                    "No data yet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Charts will appear once tickets are sold.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "$label ($value)",
          style: const TextStyle(
            color: AppColors.dark,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 30),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
