// lib/presentation/pages/notifications/notifications_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock notification data
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Visitor QR Used',
      'description': 'John Doe entered the estate gate.',
      'time': '10:32 AM',
      'date': DateTime.now(),
      'isRead': false,
      'icon': Icons.qr_code_scanner,
    },
    {
      'id': '2',
      'title': 'Visitor QR Used',
      'description': 'John Doe entered the estate gate.',
      'time': '10:32 AM',
      'date': DateTime.now(),
      'isRead': false,
      'icon': Icons.qr_code_scanner,
    },
    {
      'id': '3',
      'title': 'Sub-Resident Added',
      'description': 'Blessing has been added as a sub-resident',
      'time': 'Last Week',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'isRead': true,
      'icon': Icons.person_add,
    },
    {
      'id': '4',
      'title': 'Visitor QR Used',
      'description': 'John Doe entered the estate gate.',
      'time': '10:32 AM',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'isRead': true,
      'icon': Icons.qr_code_scanner,
    },
    {
      'id': '5',
      'title': 'Visitor QR Used',
      'description': 'John Doe entered the estate gate.',
      'time': '10:32 AM',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
      'icon': Icons.qr_code_scanner,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_searchQuery.isEmpty) {
      return _notifications;
    }
    return _notifications.where((notification) {
      final title = notification['title'].toLowerCase();
      final description = notification['description'].toLowerCase();
      final search = _searchQuery.toLowerCase();
      return title.contains(search) || description.contains(search);
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> get _groupedNotifications {
    final grouped = <String, List<Map<String, dynamic>>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var notification in _filteredNotifications) {
      final date = notification['date'] as DateTime;
      final notificationDate = DateTime(date.year, date.month, date.day);

      String group;
      if (notificationDate == today) {
        group = 'Today';
      } else if (notificationDate == yesterday) {
        group = 'Yesterday';
      } else {
        group = 'Earlier';
      }

      if (grouped[group] == null) {
        grouped[group] = [];
      }
      grouped[group]!.add(notification);
    }

    return grouped;
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
        centerTitle: false,
        title:   Text(
          'Notifications',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(156, 163, 175, 1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios, size: 12, color: Colors.white),
            ),
          ),
        ),

      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: GoogleFonts.outfit(
                    color: Color.fromRGBO(156, 163, 175, 1),
                    fontWeight: FontWeight.w400,
                    fontSize: 16
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(156, 163, 175, 1),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(156, 163, 175, 1),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(156, 163, 175, 1),
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textHint,
                  size: 20,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Notifications List
          Expanded(
            child: _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    final grouped = _groupedNotifications;
    final groups = ['Today', 'Yesterday', 'Earlier'];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        final notifications = grouped[group] ?? [];

        if (notifications.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color.fromRGBO(156, 163, 175, 0.2), width: 0.4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group Header
                _buildGroupHeader(group),
                const SizedBox(height: 12),

                // Notifications
                ...notifications.map((notification) => _buildNotificationItem(notification)),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupHeader(String group) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    String dateText;
    if (group == 'Today') {
      dateText = _formatDate(today);
    } else if (group == 'Yesterday') {
      dateText = _formatDate(today.subtract(const Duration(days: 1)));
    } else {
      dateText = '';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: group == 'Earlier' ? AppColors.background : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            group,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          if (dateText.isNotEmpty)
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  dateText,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              notification['icon'] as IconData,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                notification['title'] as String,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(11, 11, 11, 1),
                ),
              ),
            ),
            Text(
              notification['time'] as String,
              style: GoogleFonts.outfit(
                fontSize: 12,fontWeight: FontWeight.w400,
                color:  Color.fromRGBO(11, 11, 11, 0.4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          notification['description'] as String,
          style: GoogleFonts.outfit(
            fontSize: 16,fontWeight: FontWeight.w400,
            color: Color.fromRGBO(11, 11, 11, 0.7),
          ),
        ),
        Divider(color: Color.fromRGBO(156, 163, 175, 0.2), thickness: 0.4)
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day}-${months[date.month - 1]}-${date.year}';
  }
}