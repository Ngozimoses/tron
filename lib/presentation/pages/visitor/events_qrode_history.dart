// lib/presentation/pages/visitor/events_qrcode_history.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _events = [
    {
      'id': '1',
      'name': 'Kuraimo Birthday',
      'avatar': null,
      'eventType': 'Birthday',
      'eventDate': '2026-03-12',
      'eventTime': '01:57 PM',
      'status': 'Active',
    },
    {
      'id': '2',
      'name': 'Kuraimo Birthday',
      'avatar': null,
      'eventType': 'Birthday',
      'eventDate': '2026-03-12',
      'eventTime': '01:57 PM',
      'status': 'Used',
    },
    {
      'id': '3',
      'name': 'Kuraimo Birthday',
      'avatar': null,
      'eventType': 'Birthday',
      'eventDate': '2026-03-12',
      'eventTime': '01:57 PM',
      'status': 'Revoked',
    },
  ];

  List<Map<String, dynamic>> get _filteredEvents {
    if (_selectedFilter == 'All') {
      return _events;
    }
    return _events.where((event) => event['status'] == _selectedFilter).toList();
  }

  int _getCount(String status) {
    if (status == 'All') return _events.length;
    return _events.where((event) => event['status'] == status).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(flexibleSpace: Container(
        color:Colors.white,
      ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(156, 163, 175, 1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios, size: 12, color: Colors.white),
            ),
          ),
        ),
        title:   Text(
          'Events',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),centerTitle: false,
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterTab('All', _getCount('All')),
                  const SizedBox(width: 8),
                  _buildFilterTab('Active', _getCount('Active')),
                  const SizedBox(width: 8),
                  _buildFilterTab('Used', _getCount('Used')),
                  const SizedBox(width: 8),
                  _buildFilterTab('Revoked', _getCount('Revoked')),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Events List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredEvents.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final event = _filteredEvents[index];
                return _buildEventCard(event);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, int count) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary :Color.fromRGBO(254, 234, 220, 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                color: isSelected ? Colors.white : Color.fromRGBO(156, 163, 175, 1),
                fontWeight:   FontWeight.w400,
                fontSize: 12,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.2) : Color.fromRGBO(156, 163, 175, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: GoogleFonts.outfit(
                    color: isSelected ? Colors.white : Color.fromRGBO(249, 250, 251, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Avatar and Name
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: event['avatar'] != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    event['avatar'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          event['name']?[0]?.toUpperCase() ?? 'E',
                          style: GoogleFonts.outfit(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      );
                    },
                  ),
                )
                    : Center(
                  child: Text(
                    event['name']?[0]?.toUpperCase() ?? 'E',
                    style: GoogleFonts.outfit(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  event['name'],
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Event Type
          Row(
            children: [
              Text(
                'Event Type',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                event['eventType'] ?? 'N/A',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _getEventTypeColor(event['eventType']),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _getEventIcon(event['eventType']),
                size: 16,
                color: _getEventTypeColor(event['eventType']),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Event Date
          Row(
            children: [
              Text(
                'Event Date',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(event['eventDate']),
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Event Time
          Row(
            children: [
              Text(
                'Event Time',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                event['eventTime'] ?? 'N/A',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // View Details Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                context.push('/event-qr-code', extra: event);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'View Details',
                style: GoogleFonts.outfit(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getEventTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'birthday':
        return Colors.teal;
      case 'meeting':
        return Colors.blue;
      case 'party':
        return Colors.purple;
      case 'conference':
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }

  IconData _getEventIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'birthday':
        return Icons.cake;
      case 'meeting':
        return Icons.meeting_room;
      case 'party':
        return Icons.celebration;
      case 'conference':
        return Icons.groups;
      default:
        return Icons.event;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')} - ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}