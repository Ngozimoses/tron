import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  DateTime? _qrExpiryTime;
  Timer? _countdownTimer;
  String _qrData = ''; // Store the actual QR data
  final String _residentId = 'RES123456'; // Replace with actual resident ID from your auth state
  int _qrVersion = 0; // For QR rotation/versioning

  // ✅ Tab State
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['My Events', 'Visitors QR List'];
late String data = "user";
  // ✅ Filter States
  late EventFilter _selectedEventFilter;
  late VisitorFilter _selectedVisitorFilter;

  // ✅ Bell Animation Variables
  late AnimationController _bellController;
  Timer? _jinglingTimer;
  bool _hasNewNotifications = true;

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

  // Generate QR data with timestamp and version for security
  String _generateQrData() {
    final now = DateTime.now();
    final expiryTime = now.add(const Duration(minutes: 5));

    // Create a JSON object with relevant data
    final qrMap = {
      'type': 'resident_access',
      'residentId': _residentId,
      'timestamp': now.toIso8601String(),
      'expiry': expiryTime.toIso8601String(),
      'version': _qrVersion,
      'signature': _generateSignature(now), // Simple signature for basic security
    };

    return jsonEncode(qrMap);
  }
// Add this method to show the QR code dialog
  void _showQrCodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: _buildQrCodeDialogContent(),
        );
      },
    );
  }

  Widget _buildQrCodeDialogContent() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _qrData.isNotEmpty
                  ? QrImageView(
                data: _qrData,
                version: QrVersions.auto,
                size: 250,
                backgroundColor: Colors.white,
                errorCorrectionLevel: QrErrorCorrectLevel.H,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Color.fromRGBO(11, 11, 11, 0.7),
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Color.fromRGBO(11, 11, 11, 0.7),
                ),
              )
                  : Container(
                width: 250,
                height: 250,
                color: Colors.grey.shade100,
                child: const Icon(Icons.qr_code, size: 120, color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }
  String _generateSignature(DateTime timestamp) {
    final data = '$_residentId:${timestamp.millisecondsSinceEpoch}:$_qrVersion';
    // This is a simple hash - in production, use proper crypto
    return data.hashCode.toString();
  }

  void _generateNewQrCode() {
    setState(() {
      _qrVersion++; // Increment version for each new QR
      _qrExpiryTime = DateTime.now().add(const Duration(minutes: 5));
      _qrData = _generateQrData();
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
        // Stop animation and update badge state
        setState(() {
          _hasNewNotifications = false;
          _stopJinglingAnimation();
        });

        // Play bell animation
        _bellController.forward().then((_) {
          _bellController.reverse();
        });

        // ✅ Navigate to notifications page
        context.push('/notifications');
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

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _bellController.dispose();
    _jinglingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(flexibleSpace: Container(
        color:Colors.white,
      ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: "data" != null && "data".isNotEmpty
                ? NetworkImage("data")
                : null,
            child: "data" == null || "data".isEmpty
                ? Text(
              {data}.isNotEmpty ? data.toUpperCase() : 'R',
              style: GoogleFonts.outfit(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
                : null,
          ),
        ), centerTitle: false, title:  Text(
          'Hi ${data}',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),actions: [ _buildNotificationBell()],),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // Check for new notifications whenever state updates
          _checkForNewNotifications(state);

          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {

              data = state.resident?.name ?? 'Resident';

            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Greeting

                      const SizedBox(height: 20),

                      // QR Code Section with actual QR generator
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

          // QR Code with Profile Image at Center - Only this is tappable
          GestureDetector(
            onTap: _showQrCodeDialog,
            child: Hero(
              tag: 'qr-code-${_qrVersion}',
              child: Container(
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // QR Code
                    _qrData.isNotEmpty
                        ? QrImageView(
                      data: _qrData,
                      version: QrVersions.auto,
                      size: 150,
                      backgroundColor: Colors.white,
                      errorCorrectionLevel: QrErrorCorrectLevel.H,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Color.fromRGBO(11, 11, 11, 0.7),
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Color.fromRGBO(11, 11, 11, 0.7),
                      ),
                    )
                        : Container(
                      width: 150,
                      height: 150,
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.qr_code, size: 80, color: Colors.grey),
                    ),

                    // Profile Image at Center
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _buildProfileImage(),
                      ),
                    ),

                    // Small tap indicator (optional - can remove if you want)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.zoom_out_map,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Countdown (outside the tappable area)
          RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: 'Expires in ',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(11, 11, 11, 0.45),
                  ),
                ),
                TextSpan(
                  text: _getCountdownString(),
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: _getCountdownColor(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Buttons (outside the tappable area)
          Row(
            children: [
              // Create Visitor QR Button
              Expanded(
                child: CustomButton(
                  text: 'Create Visitor QR',
                  onPressed: () {
                    _navigateToCreateVisitorQR();
                  },
                  color: AppColors.primary,
                  textColor: Colors.white,
                  textsize: 14,
                  textwidth: FontWeight.w400,
                  height: 40,
                  borderRadius: 12,
                ),
              ),
              const SizedBox(width: 12),

              // Refresh Button
              Expanded(
                child: CustomButton(
                  icon: const Icon(Icons.refresh, size: 18, color: Colors.black),
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
                  color: AppColors.primaryLight,
                  textColor: const Color.fromRGBO(11, 11, 11, 0.7),
                  textsize: 14,
                  textwidth: FontWeight.w400,
                  height: 40,
                  borderRadius: 12,
                  borderWidth: 1,
                  borderColor: AppColors.textWhite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildProfileImage() {
    // You can get the profile image URL from your state
    // For example, from the HomeBloc state
    final profileImageUrl = ''; // Get this from your state

    if (profileImageUrl.isNotEmpty) {
      return Image.network(
        profileImageUrl,
        fit: BoxFit.cover,
        width: 30,
        height: 30,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.primary.withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: 25,
              color: AppColors.primary,
            ),
          );
        },
      );
    } else {
      // Fallback to initials or default icon
      return Container(
        color: AppColors.primary,
        child: Center(
          child: Text(
            'R', // You can get the first letter of the resident's name
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  void _navigateToCreateVisitorQR() {
    // Generate visitor QR data
    final visitorData = {
      'type': 'visitor_access',
      'residentId': _residentId,
      'generatedAt': DateTime.now().toIso8601String(),
      'expiry': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
      'version': _qrVersion,
    };

    // Navigate to visitor QR creation page with the data
    context.push('/create-visitor-qr', extra: visitorData);
  }

  // Add method to validate QR data (for scanner side)
  bool validateQrData(String qrData) {
    try {
      final Map<String, dynamic> data = jsonDecode(qrData);

      // Check if it's a valid resident QR
      if (data['type'] != 'resident_access') return false;

      // Check if resident ID matches (in production, verify with backend)
      if (data['residentId'] != _residentId) return false;

      // Check if QR is expired
      final expiry = DateTime.parse(data['expiry']);
      if (expiry.isBefore(DateTime.now())) return false;

      // Verify signature (in production, use proper verification)
      final signature = _generateSignature(DateTime.parse(data['timestamp']));
      if (data['signature'] != signature.toString()) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  Color _getCountdownColor() {
    if (_qrExpiryTime == null) return AppColors.primary;

    final difference = _qrExpiryTime!.difference(DateTime.now());

    if (difference.isNegative) return Colors.red;

    final totalSeconds = difference.inSeconds;

    if (totalSeconds < 30) {
      return Colors.red;
    } else if (totalSeconds < 60) {
      return Colors.orange;
    } else if (totalSeconds < 120) {
      return Colors.amber;
    } else {
      return AppColors.success;
    }
  }

  String _getCountdownString() {
    if (_qrExpiryTime == null) return '--:--';

    final difference = _qrExpiryTime!.difference(DateTime.now());
    if (difference.isNegative) return 'Expired';

    final minutes = difference.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = difference.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
              onPressed: () {context.push('/event-qr-history');},
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
              onPressed: () {context.push('/visitor-qr-history');},
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

  String _formatEventDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ✅ First Tab - My Events
          SizedBox(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 0;
                });
              },
              child: Container(

                decoration: BoxDecoration(
                  color: _selectedTabIndex == 0

                      ? const Color.fromRGBO(87, 40, 8, 1)
                      : const Color.fromRGBO(231, 231, 231, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
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
          const SizedBox(width: 10),
          SizedBox(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 1;
                });
              },
              child: Container(

                decoration: BoxDecoration(
                  color: _selectedTabIndex == 1
                      ? const Color.fromRGBO(87, 40, 8, 1)
                      : const Color.fromRGBO(231, 231, 231, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
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
      statusColor = Colors.orange;
      statusText = 'Upcoming';
    } else {
      statusColor = Colors.green;
      statusText = 'Active';
    }

    return GestureDetector(
      onTap: () {
        context.push('/event-qr-code', extra: event);
      },
      child: Container(
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
            // Avatar (Square with rounded corners)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: event['avatar'] != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
                          fontSize: 24,
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
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Event Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    event['name'] ?? 'Event',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Hosted by
                  Text(
                    'Hosted by: ${event['hosted_by'] ?? "Unknown"}',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Right side: Status and Date/Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
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
                const SizedBox(height: 8),
                // Date and Time
                if (eventDate != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatEventDate(eventDate),
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildVisitorQRCard(dynamic visitor) {
    // Determine visitor status based on QR code expiry or usage
    final now = DateTime.now();
    final expiryDate = visitor['expiryDate'] != null
        ? DateTime.tryParse(visitor['expiryDate'])
        : null;
    final isUsed = visitor['isUsed'] ?? false;
    final isRevoked = visitor['isRevoked'] ?? false;

    Color statusColor;
    String statusText;

    if (isRevoked) {
      statusColor = Colors.red;
      statusText = 'Revoked';
    } else if (isUsed) {
      statusColor = Colors.grey;
      statusText = 'Used';
    } else if (expiryDate != null && expiryDate.isBefore(now)) {
      statusColor = Colors.grey;
      statusText = 'Expired';
    } else {
      statusColor = Colors.green;
      statusText = 'Active';
    }

    // Calculate time left if active
    String? timeLeft;
    if (!isUsed && !isRevoked && expiryDate != null && expiryDate.isAfter(now)) {
      final difference = expiryDate.difference(now);
      final minutes = difference.inMinutes;
      if (minutes < 60) {
        timeLeft = '$minutes min left';
      } else if (minutes < 1440) {
        final hours = minutes ~/ 60;
        timeLeft = '$hours hr${hours > 1 ? 's' : ''} left';
      } else {
        final days = minutes ~/ 1440;
        timeLeft = '$days day${days > 1 ? 's' : ''} left';
      }
    }

    return GestureDetector(
      onTap: () {
        context.push('/visitor-qr-code', extra: visitor);
      },
      child: Container(
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
            // Avatar (Square with rounded corners)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: visitor['avatar'] != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  visitor['avatar'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildAvatarIcon(visitor);
                  },
                ),
              )
                  : _buildAvatarIcon(visitor),
            ),
            const SizedBox(width: 12),

            // Visitor Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    visitor['name'] ?? 'Visitor',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Created by you or time left
                  Text(
                    timeLeft ?? 'Created by you',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: timeLeft != null
                          ? Colors.orange
                          : Colors.black.withOpacity(0.6),
                      fontWeight: timeLeft != null ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            // Right side: Status and Date/Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
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
                const SizedBox(height: 8),
                // Date and Time
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatEventDate(expiryDate ?? now),
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Helper method to build avatar icon
  Widget _buildAvatarIcon(dynamic visitor) {
    final name = visitor['name'] ?? 'Visitor';
    final purpose = visitor['purpose']?.toLowerCase() ?? '';

    // Check if it's a delivery rider
    if (purpose.contains('delivery') || purpose.contains('rider')) {
      return const Icon(
        Icons.delivery_dining,
        color: AppColors.primary,
        size: 28,
      );
    }

    // Default: show first letter
    return Center(
      child: Text(
        name[0]?.toUpperCase() ?? 'V',
        style: GoogleFonts.outfit(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
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