import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/svg_icons.dart';

class BottomNavWrapper extends StatefulWidget {
  final Widget child;
  final int initialIndex;

  const BottomNavWrapper({
    Key? key,
    required this.child,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<BottomNavWrapper> createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> with TickerProviderStateMixin {
  late int _currentIndex;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _fabRotationAnimation;

  final List<GlobalKey> _navItemKeys = List.generate(4, (_) => GlobalKey());
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // Initialize FAB animations
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _fabRotationAnimation = Tween<double>(begin: 0, end: 0.25).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(BottomNavWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      _animateToIndex(widget.initialIndex);
    }
  }

  void _animateToIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index, {Offset? tapPosition}) {
    if (index == _currentIndex) {
      // Double tap on same item - scroll to top behavior
      _handleDoubleTap(index);
      return;
    }

    setState(() {
      _currentIndex = index;
      _tapPosition = tapPosition;
    });

    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Navigate with animation
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/profile');
        break;
      case 2:
        context.go('/settings');
        break;
      case 3:
        context.go('/marketplace');
        break;
    }
  }

  void _handleDoubleTap(int index) {
    // Scroll to top behavior - you can implement this based on your needs
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Refreshed ${_getTabName(index)}'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  String _getTabName(int index) {
    switch (index) {
      case 0: return 'Home';
      case 1: return 'Profile';
      case 2: return 'Settings';
      case 3: return 'Shop';
      default: return '';
    }
  }

  void _onQRTapped() async {
    // Trigger FAB animation
    await _fabAnimationController.forward();
    await _fabAnimationController.reverse();

    HapticFeedback.mediumImpact();

    // Show QR type selection modal with animation
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
      builder: (context) => _buildQRTypeSelectionModal(),
    );
  }

  void _onAddListingTapped() {
    HapticFeedback.mediumImpact();
    context.push('/marketplace/my-listings');
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              // Navigation Items Container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(229, 231, 235, 0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return _buildAnimatedNavItem(
                          index: index,
                          icon: _getIconData(index, false),
                          activeIcon: _getIconData(index, true),
                          label: _getTabName(index),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Animated FAB Button
              AnimatedBuilder(
                animation: _fabAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _fabScaleAnimation.value,
                    child: Transform.rotate(
                      angle: _fabRotationAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: (_currentIndex == 3)
                    ? _buildAddListingButton()
                    : _buildQRButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedNavItem({
    required int index,
    required Widget icon,
    required Widget activeIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      key: _navItemKeys[index],
      onTapDown: (details) {
        _tapPosition = details.globalPosition;
      },
      onTap: () => _onTabTapped(index, tapPosition: _tapPosition),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Icon (now using Widget instead of IconData)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Container(
                key: ValueKey(isSelected),
                child: isSelected ? activeIcon : icon,
              ),
            ),

            // Animated Label
            if (isSelected) ...[
              const SizedBox(width: 6),
              AnimatedOpacity(
                opacity: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  label,
                  style: GoogleFonts.outfit(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getIconData(int index, bool active) {
    switch (index) {
      case 0:
        return active ?SvgIcons.home02(size: 20): SvgIcons.home01(size: 20) ;
      case 1:
        return active ? SvgIcons.profile2(size: 20):SvgIcons.profile(size: 20,) ;
      case 2:
        return active ?SvgIcons.settings02(size: 20): SvgIcons.settings01(size: 20);
      case 3:
        return active ?SvgIcons.store02(size: 20): SvgIcons.store01(size: 20) ;
      default:
        return SvgIcons.home01();
    }
  }



  Widget _buildQRButton() {
    return GestureDetector(
      onTap: _onQRTapped,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Color.fromRGBO(229, 231, 235, 1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),

        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner_rounded,
              color: AppColors.primaryblack,
              size: 19,
            ),
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryblack, width: 1.5),
                ),
                child: const Icon(
                  Icons.add,
                  color: AppColors.primaryblack,
                  size: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddListingButton() {
    return GestureDetector(
      onTap: _onAddListingTapped,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
       color: AppColors.primaryLight,
          shape: BoxShape.circle,
          border: Border.all(color:AppColors.primaryLight, width: 2),

        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgIcons.shoppingBag02(size: 20),
            Positioned(
              top: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Center(
                  child: Text(
                    "1",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 7.62,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced QR Type Selection Modal with animations
  Widget _buildQRTypeSelectionModal() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.45,
        minChildSize: 0.3,
        maxChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Drag Handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    children: [
                      // Header with animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 400),
                        tween: Tween(begin: 0, end: 1),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Create QR Code',
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryblack,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: AppColors.textSecondary),
                              onPressed: () => Navigator.pop(context),
                              splashRadius: 24,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // QR Type Cards with staggered animation
                      _buildAnimatedQRTypeCard(
                        index: 0,
                        icon: Icons.event,
                        iconColor: const Color.fromRGBO(6, 95, 70, 1),
                        title: 'Event QR',
                        description: 'Create a time-limited QR code for your event',
                        backgroundColor: Colors.green.shade50,
                        onTap: () {
                          Navigator.pop(context);
                          _showEventQRModal();
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildAnimatedQRTypeCard(
                        index: 1,
                        icon: Icons.person,
                        iconColor: const Color.fromRGBO(112, 52, 10, 1),
                        title: 'Visitor QR',
                        description: 'Generate a unique QR code for visitors',
                        backgroundColor: Colors.orange.shade50,
                        onTap: () {
                          Navigator.pop(context);
                          _showVisitorQRModal();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedQRTypeCard({
    required int index,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (index * 100)),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(50 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: iconColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: iconColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: iconColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: iconColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _showVisitorQRModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
      builder: (context) => _buildVisitorQRModal(),
    );
  }
  void _showEventQRModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
      builder: (context) => _buildEventQRModal(),
    );
  }



  Widget _buildEventQRModal() {
    final _formKey = GlobalKey<FormState>();
    final _eventNameController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _hostNameController = TextEditingController();
    final _inviteeNameController = TextEditingController();
    String? _selectedEventType;
    DateTime? _selectedDate;
    TimeOfDay? _selectedTime;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar and close icon row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Handle bar with some left padding to center it visually
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.divider,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                      // Close icon
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: AppColors.textSecondary,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    'Event QR',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    'A unique QR code will be generated for your Event. The code expires automatically',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Rest of your content remains the same...
                  // Event Name Field
                  Text(
                    'Event Name',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _eventNameController,
                    decoration: InputDecoration(
                      hintText: 'e.g. John Doe',
                      hintStyle: GoogleFonts.outfit(
                        color: const Color.fromRGBO(156, 163, 175, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description Field
                  Text(
                    'Description',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter Description',
                      hintStyle: GoogleFonts.outfit(
                        color: const Color.fromRGBO(156, 163, 175, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Event Type Field
                  Text(
                    'Event Type',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color.fromRGBO(156, 163, 175, 1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedEventType,
                        hint: Text(
                          'Select Type',
                          style: GoogleFonts.outfit(
                            color: const Color.fromRGBO(156, 163, 175, 1),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        icon: const Icon(Icons.chevron_right, color: AppColors.textHint),
                        items: const [
                          DropdownMenuItem(value: 'meeting', child: Text('Meeting')),
                          DropdownMenuItem(value: 'party', child: Text('Party')),
                          DropdownMenuItem(value: 'conference', child: Text('Conference')),
                          DropdownMenuItem(value: 'workshop', child: Text('Workshop')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedEventType = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Event Date and Time
                  Row(
                    children: [
                      // Event Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Event Date',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setState(() {
                                    _selectedDate = date;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color.fromRGBO(156, 163, 175, 1)),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      _selectedDate != null
                                          ? '${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                                          : '12 - 03',
                                      style: GoogleFonts.outfit(
                                        color: const Color.fromRGBO(156, 163, 175, 1),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.calendar_today, size: 18, color: AppColors.textHint),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Event Time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Event Time',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() {
                                    _selectedTime = time;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color.fromRGBO(156, 163, 175, 1)),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      _selectedTime != null
                                          ? _selectedTime!.format(context)
                                          : 'e.g. John Doe',
                                      style: GoogleFonts.outfit(
                                        color: const Color.fromRGBO(156, 163, 175, 1),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Image Upload (Optional)
                  Row(
                    children: [
                      Text(
                        'Image (optional)',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Handle image upload
                        },
                        icon: const Icon(Icons.upload_file, size: 18),
                        label: Text('Upload'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.divider),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Generate Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Format date and time
                        String formattedDate = _selectedDate != null
                            ? '${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.year}'
                            : '12-03-2026';

                        String formattedTime = _selectedTime != null
                            ? _selectedTime!.format(context)
                            : '01:57 PM';

                        // Get values from controllers
                        final eventData = {
                          'eventName': _eventNameController.text.isNotEmpty
                              ? _eventNameController.text
                              : 'Birthday Party',
                          'eventType': _selectedEventType ?? 'Party',
                          'eventDate': formattedDate,
                          'eventTime': formattedTime,
                          'hostName': _hostNameController.text.isNotEmpty
                              ? _hostNameController.text
                              : 'Odunayo',
                          'inviteeName': _inviteeNameController.text.isNotEmpty
                              ? _inviteeNameController.text
                              : 'Islamiyat',
                          'description': _descriptionController.text,
                        };

                        // Close the modal
                        Navigator.pop(context);

                        // Navigate to Event QR Code page with dynamic data
                        context.push('/event-qr-code', extra: eventData);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Event QR generated successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Generate Event Code',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVisitorQRModal() {
    // Add controllers and state variables
    final _visitorNameController = TextEditingController();
    final _purposeController = TextEditingController();
    String? _selectedVisitType;
    String? _selectedDuration;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar and close icon row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Handle bar with some left padding to center it visually
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    // Close icon
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.textSecondary,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'Generate Visitor QR',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  'A unique QR code will be generated for your visitor. The code expires automatically',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Visitor Name Field
                Text(
                  'Visitor Name',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _visitorNameController,
                  decoration: InputDecoration(
                    hintText: 'e.g. John Doe',
                    hintStyle: GoogleFonts.outfit(
                      color: const Color.fromRGBO(156, 163, 175, 1),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
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
                  ),
                ),
                const SizedBox(height: 20),

                // Purpose Field
                Text(
                  'Purpose',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _purposeController,
                  decoration: InputDecoration(
                    hintText: 'Delivery / Guest / Cleaner',
                    hintStyle: GoogleFonts.outfit(
                      color: const Color.fromRGBO(156, 163, 175, 1),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Visit Type Field
                Text(
                  'Visit Type',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color.fromRGBO(156, 163, 175, 1)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedVisitType,
                      hint: Text(
                        'Select Type',
                        style: GoogleFonts.outfit(
                          color: const Color.fromRGBO(156, 163, 175, 1),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      icon: const Icon(Icons.chevron_right, color: AppColors.textHint),
                      items: const [
                        DropdownMenuItem(value: 'guest', child: Text('Guest Visit')),
                        DropdownMenuItem(value: 'delivery', child: Text('Delivery')),
                        DropdownMenuItem(value: 'service', child: Text('Service')),
                        DropdownMenuItem(value: 'family', child: Text('Family')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedVisitType = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Duration Field
                Text(
                  'Duration',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color.fromRGBO(156, 163, 175, 1)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedDuration,
                      hint: Text(
                        'Select Duration',
                        style: GoogleFonts.outfit(
                          color: const Color.fromRGBO(156, 163, 175, 1),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      icon: const Icon(Icons.expand_more, color: AppColors.textHint),
                      items: const [
                        DropdownMenuItem(value: '1 Hour', child: Text('1 Hour')),
                        DropdownMenuItem(value: '2 Hours', child: Text('2 Hours')),
                        DropdownMenuItem(value: '4 Hours', child: Text('4 Hours')),
                        DropdownMenuItem(value: '1 Day', child: Text('1 Day')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedDuration = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Optional',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.outfit(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Generate Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Get values from controllers and state
                          final visitorData = {
                            'name': _visitorNameController.text.isNotEmpty
                                ? _visitorNameController.text
                                : 'John Doe',
                            'purpose': _purposeController.text.isNotEmpty
                                ? _purposeController.text
                                : 'Guest Visit',
                            'visitType': _selectedVisitType ?? 'guest',
                            'duration': _selectedDuration ?? '2 Hours',
                            'status': 'Active',
                          };

                          // Close the modal
                          Navigator.pop(context);

                          // Navigate to Visitor QR Code page with dynamic data
                          context.push('/visitor-qr-code', extra: visitorData);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Visitor QR generated successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Generate',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

}