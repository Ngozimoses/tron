import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/home/home_bloc.dart';
import '../../blocs/home/home_event.dart';
import '../../blocs/home/home_state.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../widgets/custom_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with SingleTickerProviderStateMixin{
  DateTime? _qrExpiryTime;
  Timer? _countdownTimer;
  String _qrCodeUrl = 'assets/images/mainqrcode.png';

  // ✅ Tab State
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['My Events', 'Visitors QR List'];

  // ✅ Filter States
  late EventFilter _selectedEventFilter;
  late VisitorFilter _selectedVisitorFilter;

  // ✅ Bell Animation Variables (NEW)
  late AnimationController _bellController;
  Timer? _jinglingTimer;
  bool _hasNewNotifications = true; // You can set this based on actual notification state

  @override
  void initState() {
    super.initState();

    // Initialize filters
    _selectedEventFilter = EventFilter.all;
    _selectedVisitorFilter = VisitorFilter.all;

    // Initialize bell animation controller
    _bellController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Start jingling animation if there are new notifications
    if (_hasNewNotifications) {
      _startJinglingAnimation();
    }

    // Load home data
    context.read<HomeBloc>().add(LoadHome());
    _generateNewQrCode();
    _startCountdownTimer();
  }

  // ✅ NEW: Bell animation methods
  void _startJinglingAnimation() {
    _jinglingTimer?.cancel();
    _jinglingTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && _hasNewNotifications) {
        _bellController.forward().then((_) {
          _bellController.reverse();
        });
      }
    });
  }

  void _stopJinglingAnimation() {
    _jinglingTimer?.cancel();
    _bellController.stop();
  }

  // ✅ NEW: Build notification bell with animation
  Widget _buildNotificationBell() {
    return GestureDetector(
      onTap: () {
        // Stop animation and navigate to notifications
        setState(() {
          _hasNewNotifications = false;
          _stopJinglingAnimation();
        });

        // Immediate feedback when tapped
        _bellController.forward().then((_) {
          _bellController.reverse();
        });


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Opening notifications'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.textWhite,
              borderRadius: BorderRadius.circular(12),

            ),
            child: AnimatedBuilder(
              animation: _bellController,
              builder: (context, child) {
                // Complex jingling effect
                final value = _bellController.value;

                // Multi-stage animation
                double rotation = 0;
                if (value < 0.2) {
                  // First quick rotation right
                  rotation = 0.15 * (value / 0.2);
                } else if (value < 0.4) {
                  // Rotation left
                  rotation = 0.15 - 0.3 * ((value - 0.2) / 0.2);
                } else if (value < 0.6) {
                  // Rotation right again
                  rotation = -0.15 + 0.25 * ((value - 0.4) / 0.2);
                } else if (value < 0.8) {
                  // Small rotation left
                  rotation = 0.1 - 0.2 * ((value - 0.6) / 0.2);
                } else {
                  // Settle back to center
                  rotation = -0.1 + 0.1 * ((value - 0.8) / 0.2);
                }

                return Transform.rotate(
                  angle: rotation,
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.primary,
                    size: 22,
                  ),
                );
              },
            ),
          ),

          // Animated notification badge (only show if has new notifications)
          if (_hasNewNotifications)
            Positioned(
              top: 8,
              right: 8,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.elasticOut,
                width: _bellController.isAnimating ? 12 : 10,
                height: _bellController.isAnimating ? 12 : 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ✅ UPDATE: Modify your existing _buildHeader method to use the animated bell
  Widget _buildHeader(String name, {String? profileImageUrl}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Profile Avatar + Greeting
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: profileImageUrl != null && profileImageUrl.isNotEmpty
                  ? NetworkImage(profileImageUrl)
                  : null,
              child: profileImageUrl == null || profileImageUrl.isEmpty
                  ? Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'R',
                style: GoogleFonts.outfit(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              'Hi $name',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),

        // Right: Animated Notification Icon (UPDATED)
        _buildNotificationBell(),
      ],
    );
  }

  // ✅ UPDATE: Add method to check for new notifications from your state
  void _checkForNewNotifications(HomeState state) {
    // This is where you would check if there are new notifications
    // For example, based on pending visitors or new events
    if (state is HomeLoaded) {
      bool hasNewNotifications = false;

      // Example: Check if there are pending visitors
      if (state.pendingVisitors != null && state.pendingVisitors!.isNotEmpty) {
        // Check if any visitors are newly added
        // You'll need to implement your own logic here
        hasNewNotifications = true;
      }

      // Example: Check for upcoming events
      if (state.events != null && state.events!.isNotEmpty) {
        // Check for events happening soon
        // Implement your logic
      }

      // Update state if different
      if (_hasNewNotifications != hasNewNotifications) {
        setState(() {
          _hasNewNotifications = hasNewNotifications;
          if (_hasNewNotifications) {
            _startJinglingAnimation();
          } else {
            _stopJinglingAnimation();
          }
        });
      }
    }
  }

  // ✅ UPDATE: Modify your dispose method to clean up animation
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _bellController.dispose(); // Clean up animation controller
    _jinglingTimer?.cancel(); // Clean up timer
    super.dispose();
  }


  List<dynamic> _filterVisitors(List<dynamic> visitors) {
    final now = DateTime.now();

    // Add null check for _selectedVisitorFilter
    final currentFilter = _selectedVisitorFilter ?? VisitorFilter.all;

    return visitors.where((visitor) {
      final expiryDate = visitor['expiryDate'] != null
          ? DateTime.tryParse(visitor['expiryDate'])
          : null;
      final isUsed = visitor['isUsed'] ?? false;

      bool isActive = false;
      bool isExpired = false;

      if (expiryDate != null) {
        isActive = !isUsed && expiryDate.isAfter(now);
        isExpired = !isUsed && expiryDate.isBefore(now);
      }

      switch (currentFilter) {
        case VisitorFilter.active:
          return isActive;
        case VisitorFilter.Revoked:
          return isExpired;
        case VisitorFilter.used:
          return isUsed;
        case VisitorFilter.all:
        default:
          return true;
      }
    }).toList();
  }

  Widget _buildVisitorFilterChips() {
    final filters = VisitorFilter.values.toList();

    // Ensure _selectedVisitorFilter is not null
    final currentFilter = _selectedVisitorFilter ?? VisitorFilter.all;

    return Wrap(
      spacing: 8,
      children: filters.map((filter) {
        final isSelected = currentFilter == filter;
        return ChoiceChip(
          label: Text(_getVisitorFilterLabel(filter)),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedVisitorFilter = filter;
              });
            }
          },
          selectedColor: AppColors.primaryDark,
          labelStyle: GoogleFonts.outfit(
            color: isSelected ? Colors.white : const Color.fromRGBO(156, 163, 175, 1),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          backgroundColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
            ),
          ),
        );
      }).toList(),
    );
  }

  // Similarly update event filter chips
  Widget _buildEventFilterChips() {
    final filters = EventFilter.values.toList();

    // Ensure _selectedEventFilter is not null
    final currentFilter = _selectedEventFilter ?? EventFilter.all;

    return Wrap(
      spacing: 8,
      children: filters.map((filter) {
        final isSelected = currentFilter == filter;
        return ChoiceChip(
          label: Text(_getEventFilterLabel(filter)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedEventFilter = filter;
            });
          },
          selectedColor: AppColors.primaryDark,
          labelStyle: GoogleFonts.outfit(
            color: isSelected ? Colors.white : Color.fromRGBO(156, 163, 175, 1),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          backgroundColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
            ),
          ),
        );
      }).toList(),
    );
  }





  List<dynamic> _filterEvents(List<dynamic> events) {
    final now = DateTime.now();

    return events.where((event) {
      final eventDate = event['date'] != null
          ? DateTime.tryParse(event['date'])
          : null;

      if (eventDate == null) return false;

      switch (_selectedEventFilter) {
        case EventFilter.active:
        // Active events are happening now (within a reasonable window)
          final difference = eventDate.difference(now).inHours.abs();
          return difference <= 2; // Events within 2 hours of current time

        case EventFilter.upcoming:
          return eventDate.isAfter(now);

        case EventFilter.past:
          return eventDate.isBefore(now);

        case EventFilter.all:
        default:
          return true;
      }
    }).toList();
  }
  Widget _buildMyEventsSection(List<dynamic> events) {
    final filteredEvents = _filterEvents(events);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Events',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See all',
                style: GoogleFonts.outfit(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Filter Chips
        _buildEventFilterChips(),
        const SizedBox(height: 16),

        // Events List - Use filteredEvents instead of events
        filteredEvents.isEmpty
            ? Card(
          color: AppColors.background,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.event_busy,
                  size: 48,
                  color: AppColors.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 12),
                Text(
                  _getEventEmptyStateMessage(),
                  style: GoogleFonts.outfit(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        )
            : ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredEvents.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final event = filteredEvents[index];
            return _buildEventCard(event);
          },
        ),
      ],
    );
  }
  Widget _buildVisitorsQRListSection(List<dynamic> visitors) {
    final filteredVisitors = _filterVisitors(visitors);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Visitors QR List',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See all',
                style: GoogleFonts.outfit(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Visitor Filter Chips
        _buildVisitorFilterChips(),
        const SizedBox(height: 16),

        // Visitors List - Use filteredVisitors
        filteredVisitors.isEmpty
            ? Card(
          color: AppColors.background,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.person_off,
                  size: 48,
                  color: AppColors.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 12),
                Text(
                  _getVisitorEmptyStateMessage(),
                  style: GoogleFonts.outfit(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        )
            : ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredVisitors.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final visitor = filteredVisitors[index];
            return _buildVisitorQRCard(visitor);
          },
        ),
      ],
    );
  }

  // ✅ Helper method for event empty state messages
  String _getEventEmptyStateMessage() {
    switch (_selectedEventFilter) {
      case EventFilter.active:
        return 'No active events';
      case EventFilter.upcoming:
        return 'No upcoming events';
      case EventFilter.past:
        return 'No past events';
      case EventFilter.all:
      default:
        return 'No events yet';
    }
  }
  String _getVisitorEmptyStateMessage() {
    switch (_selectedVisitorFilter) {
      case VisitorFilter.active:
        return 'No active visitors';
      case VisitorFilter.Revoked:
        return 'No expired visitors';
      case VisitorFilter.used:
        return 'No used visitors';
      case VisitorFilter.all:
      default:
        return 'No visitor QR codes yet';
    }
  }
  void _generateNewQrCode() {
    setState(() {
      _qrExpiryTime = DateTime.now().add(const Duration(minutes: 5));
    });
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _qrExpiryTime != null) {
        setState(() {
          if (_qrExpiryTime!.isBefore(DateTime.now())) {
            _generateNewQrCode();
          }
        });
      }
    });
  }
  String _formatEventDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
  String _getCountdownString() {
    if (_qrExpiryTime == null) return '--:--';

    final difference = _qrExpiryTime!.difference(DateTime.now());
    if (difference.isNegative) return 'Expired';

    final minutes = difference.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = difference.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // Check for new notifications whenever state updates
          _checkForNewNotifications(state);

          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Greeting (now with animated bell)
                      _buildHeader(state.resident?.name ?? 'Resident'),
                      const SizedBox(height: 20),

                      // QR Code Section
                      _buildQRSection(),
                      const SizedBox(height: 20),

                      // Tabs
                      _buildTabs(),
                      const SizedBox(height: 16),

                      // Tab Content
                      _selectedTabIndex == 0
                          ? _buildMyEventsSection(state.events ?? [])
                          : _buildVisitorsQRListSection(state.pendingVisitors ?? []),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(LoadHome());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Welcome'));
        },
      ),
    );
  }

  Widget _buildQRSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            'My Access QR',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // QR Code
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(
              _qrCodeUrl,
              width: 150,
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 150,
                  height: 150,
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.qr_code, size: 80, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // ✅ FIXED: Countdown with separate color using RichText
          RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
              children: [
                  TextSpan(text: 'Expires in ',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color:Color.fromRGBO(11, 11, 11, 0.45), // Dynamic color based on time remaining
              ),),
                TextSpan(
                  text: _getCountdownString(),
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: _getCountdownColor(), // Dynamic color based on time remaining
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Buttons
          Row(
            children: [
              // Create Visitor QR Button
              Expanded(
                child: CustomButton(
                  text: 'Create Visitor QR',
                  onPressed: () {
                    // Navigate to create visitor QR
                  },
                  color: AppColors.primary,
                  textColor: Colors.white,
                  textsize: 14,
                  textwidth: FontWeight.w400,
                  height: 40,
                  borderRadius: 12,
                  // No border needed for filled button
                ),
              ),
              const SizedBox(width: 12),

              // Refresh Button (Outlined style)
              Expanded(
                child: CustomButton(
                  icon: const Icon(Icons.refresh, size: 18 ,color: Colors.black,),
                  text: 'Refresh',
                  onPressed: () {
                    _generateNewQrCode();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('QR code refreshed'),
                        backgroundColor: AppColors.success,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  color:AppColors.primaryLight, // Background color
                  textColor:  Color.fromRGBO(11, 11, 11, 0.7),
                  textsize: 14,
                  textwidth: FontWeight.w400,
                  height: 40,
                  borderRadius: 12,
                  borderWidth: 1, // Add border for outlined effect
                  borderColor: AppColors.textWhite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCountdownColor() {
    if (_qrExpiryTime == null) return AppColors.primary;

    final difference = _qrExpiryTime!.difference(DateTime.now());

    if (difference.isNegative) return Colors.red;

    final totalSeconds = difference.inSeconds;

    // Color coding based on time remaining
    if (totalSeconds < 30) {
      return Colors.red; // Less than 30 seconds
    } else if (totalSeconds < 60) {
      return Colors.orange; // Less than 1 minute
    } else if (totalSeconds < 120) {
      return Colors.amber; // Less than 2 minutes
    } else {
      return AppColors.success; // More than 2 minutes
    }
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          // ✅ First Tab - My Events
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTabIndex = 0;
                  });
                },
                child: Container(
                  height: 33,
                  decoration: BoxDecoration(
                    color: _selectedTabIndex == 0

                        ? const Color.fromRGBO(87, 40, 8, 1)
                        : const Color.fromRGBO(231, 231, 231, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event,
                        size: 18,
                        color: _selectedTabIndex == 0
                            ? Colors.white
                            : const Color.fromRGBO(156, 163, 175, 1),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _tabs[0],
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: _selectedTabIndex == 0 ? FontWeight.w600 : FontWeight.w400,
                          color: _selectedTabIndex == 0
                              ? Colors.white
                              : const Color.fromRGBO(156, 163, 175, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ✅ Second Tab - Visitors QR List
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 1;
                });
              },
              child: Container(
                height: 33,
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 1
                      ? const Color.fromRGBO(87, 40, 8, 1)
                      : const Color.fromRGBO(231, 231, 231, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: 18,
                      color: _selectedTabIndex == 1
                          ? Colors.white
                          : const Color.fromRGBO(156, 163, 175, 1),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _tabs[1],
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: _selectedTabIndex == 1 ? FontWeight.w600 : FontWeight.w400,
                        color: _selectedTabIndex == 1
                            ? Colors.white
                            : const Color.fromRGBO(156, 163, 175, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getVisitorFilterLabel(VisitorFilter filter) {
    switch (filter) {
      case VisitorFilter.all:
        return 'All';
      case VisitorFilter.active:
        return 'Active';
      case VisitorFilter.Revoked:
        return 'Revoked';
      case VisitorFilter.used:
        return 'Used';
    }
  }

  Widget _buildEventCard(dynamic event) {
    // ✅ Safely parse date with fallback
    final eventDate = event['date'] != null
        ? DateTime.tryParse(event['date'])
        : null;

    // ✅ Handle null date safely
    final now = DateTime.now();
    final isPast = eventDate?.isBefore(now) ?? false;
    final isUpcoming = eventDate?.isAfter(now) ?? false;
    final isActive = eventDate != null && !isPast && !isUpcoming;

    Color statusColor;
    String statusText;

    if (isPast) {
      statusColor = Colors.grey;
      statusText = 'Past';
    } else if (isUpcoming) {
      statusColor = AppColors.info;
      statusText = 'Upcoming';
    } else {
      statusColor = AppColors.success;
      statusText = 'Active';
    }

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
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: event['avatar'] != null
                ? NetworkImage(event['avatar'])
                : null,
            child: event['avatar'] == null
                ? Text(
              event['name']?[0]?.toUpperCase() ?? 'E',
              style: GoogleFonts.outfit(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
                : null,
          ),
          const SizedBox(width: 12),

          // Event Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['name'] ?? 'Event',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hosted by: ${event['hosted_by'] ?? "Unknown"}',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                if (eventDate != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatEventDate(eventDate), // ✅ Now safe to call
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusText,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitorQRCard(dynamic visitor) {
    // Determine visitor status based on QR code expiry or usage
    final now = DateTime.now();

    // Assuming visitor has 'expiryDate' or 'isUsed' fields
    // You may need to adjust these based on your actual data structure
    final expiryDate = visitor['expiryDate'] != null
        ? DateTime.tryParse(visitor['expiryDate'])
        : null;
    final isUsed = visitor['isUsed'] ?? false;

    Color statusColor;
    String statusText;

    if (isUsed) {
      statusColor = AppColors.success;
      statusText = 'Used';
    } else if (expiryDate != null && expiryDate.isBefore(now)) {
      statusColor = Colors.grey;
      statusText = 'Revoked';
    } else if (expiryDate != null && expiryDate.isAfter(now)) {
      statusColor = AppColors.info;
      statusText = 'Active';
    } else {
      // Default case if no status info available
      statusColor = AppColors.info;
      statusText = 'Active';
    }

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
      child: Row(
        children: [
          // Avatar with initial
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              visitor['name']?[0]?.toUpperCase() ?? 'V',
              style: GoogleFonts.outfit(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Visitor Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visitor['name'] ?? 'Visitor',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  visitor['purpose'] ?? 'Visit',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                // Optional: Show expiry time if available and not used
                if (!isUsed && expiryDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Expires: ${_formatTime(expiryDate)}',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusText,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),

          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }


  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  String _getEventFilterLabel(EventFilter filter) {
    switch (filter) {
      case EventFilter.all:
        return 'All';
      case EventFilter.active:
        return 'Active';
      case EventFilter.upcoming:
        return 'Upcoming';
      case EventFilter.past:
        return 'Past';
    }
  }
}
enum VisitorFilter { all, active, Revoked, used }
enum EventFilter { all, active, upcoming, past }