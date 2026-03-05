// lib/presentation/pages/auth/connect_estate_page.dart
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/local/auth_local_datasource.dart';
import '../../router/auth_notifier.dart';
import '../../widgets/custom_button.dart';

class ConnectEstatePage extends StatefulWidget {
  const ConnectEstatePage({Key? key}) : super(key: key);

  @override
  State<ConnectEstatePage> createState() => _ConnectEstatePageState();
}

class _ConnectEstatePageState extends State<ConnectEstatePage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEstate;
  final _unitNumberController = TextEditingController();
  bool _isLoading = false;

  // Add scroll controller
  final _scrollController = ScrollController();

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _dropdownSlideAnimation;
  late Animation<Offset> _unitSlideAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  // Focus node for unit number field
  late FocusNode _unitFocusNode;

  final List<String> _estates = [
    'Alaska Estate',
    'Green Valley Estate',
    'Sunrise Gardens',
    'Palm Residence',
  ];

  // Contact information
  final String _whatsappNumber = '09123451998';
  final String _phoneNumber = '09023451998';
  final String _email = 'Ngozimoses@gmail.com';

  @override
  void initState() {
    super.initState();
    _initFocusNodes();
    _initAnimations();
    _setupFocusListeners();
  }

  void _initFocusNodes() {
    _unitFocusNode = FocusNode();
  }

  void _setupFocusListeners() {
    // Add listener to scroll when unit field is focused
    _unitFocusNode.addListener(() {
      if (_unitFocusNode.hasFocus) {
        _scrollToField();
      }
    });
  }

  void _scrollToField() {
    // Small delay to ensure keyboard is shown
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        // Get the position of the focused field
        final renderBox = _unitFocusNode.context?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero).dy;
          final screenHeight = MediaQuery.of(context).size.height;
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

          // Calculate offset to show the field above the keyboard
          final offset = position - (screenHeight - keyboardHeight) + 100;

          if (offset > 0) {
            _scrollController.animateTo(
              _scrollController.position.pixels + offset,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          } else {
            // If field is below keyboard, scroll to bottom
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        }
      }
    });
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    _dropdownSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    ));

    _unitSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.4, 0.75, curve: Curves.easeOut),
    ));

    _buttonSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _unitNumberController.dispose();
    _unitFocusNode.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _connectEstate() async {
    if (_formKey.currentState!.validate() && _selectedEstate != null) {
      setState(() => _isLoading = true);

      try {
        final localDs = di.sl<AuthLocalDataSource>();
        await localDs.setConnectedEstate(true);

        if (mounted) {
          authNotifier.setConnectedEstate(true);
          context.push('/complete-profile', extra: {
            'estate': _selectedEstate,
            'unitNumber': _unitNumberController.text,
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else if (_selectedEstate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an estate')),
      );
    }
  }

  void _showContactBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Close button (optional)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: AppColors.textHint),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            const SizedBox(height: 8),

            // Title
            Text(
              'Contact Estate Admin',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'Reach out to your estate administrator for assistance',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryblack,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Contact options row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // WhatsApp Button
                _buildContactButton(
                 icon: FontAwesomeIcons.whatsapp,
                  iconColor: const Color(0xFF25D366), // WhatsApp green
                  label: 'WhatsApp',
                  onTap: () => _launchWhatsApp(),
                ),

                // Email Button
                _buildContactButton(
                  icon: Icons.email,
                  iconColor: const Color(0xFFEA4335), // Gmail red
                  label: 'Email',
                  onTap: () => _launchEmail(),
                ),

                // Call Button
                _buildContactButton(
                  icon: Icons.phone,
                  iconColor: const Color(0xFF34A853), // Green for call
                  label: 'Call',
                  onTap: () => _launchPhone(),
                ),
              ],
            ),



            const SizedBox(height: 24),

            // Close button

          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
  required IconData icon,  // Changed from Icon to IconData
  required Color iconColor,
  required String label,
  required VoidCallback onTap,
  }) {
  return GestureDetector(
  onTap: onTap,
  child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
  Container(
  width: 60,
  height: 60,
  decoration: BoxDecoration(
  shape: BoxShape.circle,
  color: iconColor.withOpacity(0.1),
  ),
  child: Icon(
  icon,  // Now using IconData directly
  color: iconColor,
  size: 30,
  ),
  ),
  const SizedBox(height: 8),
  Text(
  label,
  style: GoogleFonts.outfit(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Colors.black87,
  ),
  ),
  ],
  ),
  );
  }



  Future<void> _launchWhatsApp() async {
    final url = 'https://wa.me/${_whatsappNumber.replaceAll('+', '')}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }

  Future<void> _launchEmail() async {
    final url = 'mailto:$_email';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email app')),
      );
    }
  }

  Future<void> _launchPhone() async {
    final url = 'tel:$_phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone app')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(color: Colors.white),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(156, 163, 175, 1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios, size: 12, color: Colors.white),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside input fields
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                // Add bottom padding to account for keyboard
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title slides in from top
                    SlideTransition(
                      position: _titleSlideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connect to your estate',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select your estate and confirm your house/unit number to continue.',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(11, 11, 11, 0.45),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Dropdown slides in from bottom
                    SlideTransition(
                      position: _dropdownSlideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Your Estate',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedEstate != null
                                    ? AppColors.primary
                                    : const Color.fromRGBO(156, 163, 175, 1),
                                width: _selectedEstate != null ? 1.5 : 1,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: _selectedEstate,
                                hint: Text(
                                  'Choose Estate Name',
                                  style: GoogleFonts.outfit(
                                    color: const Color.fromRGBO(156, 163, 175, 1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                                icon: AnimatedRotation(
                                  turns: _selectedEstate != null ? 0.5 : 0,
                                  duration: const Duration(milliseconds: 300),
                                  child: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.textHint,
                                  ),
                                ),
                                items: _estates.map((estate) {
                                  return DropdownMenuItem(
                                    value: estate,
                                    child: Text(
                                      estate,
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: _isLoading
                                    ? null
                                    : (value) => setState(() => _selectedEstate = value),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Unit number slides in slightly later
                    SlideTransition(
                      position: _unitSlideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'House / Unit Number',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _unitNumberController,
                            focusNode: _unitFocusNode,
                            enabled: !_isLoading,
                            keyboardType: TextInputType.streetAddress,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              _connectEstate();
                            },
                            decoration: InputDecoration(
                              hintText: 'e.g. Block A, Unit 12',
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
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your unit number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Buttons slide in last
                    SlideTransition(
                      position: _buttonSlideAnimation,
                      child: Column(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: CustomButton(
                              key: ValueKey(_isLoading),
                              text: _isLoading ? 'Connecting...' : 'Continue',
                              onPressed: _isLoading ? () {} : _connectEstate,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.easeOut,
                            builder: (context, value, child) =>
                                Opacity(opacity: value, child: child),
                            child: Center(
                              child: TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : _showContactBottomSheet,
                                child: Text(
                                  "I can't find my estate",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Add extra bottom padding for keyboard
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}