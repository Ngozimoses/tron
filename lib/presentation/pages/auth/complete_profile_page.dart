// lib/presentation/pages/auth/complete_profile_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/di/injection_container.dart' as di;
import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/local/auth_local_datasource.dart';
import '../../router/auth_notifier.dart';
import '../../widgets/custom_button.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({Key? key}) : super(key: key);

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  File? _profileImage;
  Map<String, dynamic>? _estateData;
  bool _isLoading = false;

  // Add scroll controller
  final _scrollController = ScrollController();

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _avatarController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _avatarSlideAnimation;
  late Animation<Offset> _nameSlideAnimation;
  late Animation<Offset> _phoneSlideAnimation;
  late Animation<Offset> _emailSlideAnimation;
  late Animation<Offset> _buttonSlideAnimation;
  late Animation<double> _avatarScaleAnimation;

  // Field focus nodes for keyboard handling
  late FocusNode _nameFocusNode;
  late FocusNode _phoneFocusNode;
  late FocusNode _emailFocusNode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _estateData = GoRouterState.of(context).extra as Map<String, dynamic>?;
  }

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initFocusNodes();
    _setupFocusListeners();
  }

  void _initFocusNodes() {
    _nameFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
  }

  void _setupFocusListeners() {
    // Add listeners to scroll when fields are focused
    _nameFocusNode.addListener(() {
      if (_nameFocusNode.hasFocus) {
        _scrollToField(_nameFocusNode);
      }
    });

    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus) {
        _scrollToField(_phoneFocusNode);
      }
    });

    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        _scrollToField(_emailFocusNode);
      }
    });
  }

  void _scrollToField(FocusNode focusNode) {
    // Small delay to ensure keyboard is shown
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        // Get the position of the focused field
        final renderBox = focusNode.context?.findRenderObject() as RenderBox?;
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
      duration: const Duration(milliseconds: 900),
    );
    _avatarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    ));

    _avatarSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.1, 0.45, curve: Curves.easeOut),
    ));

    _nameSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.25, 0.6, curve: Curves.easeOut),
    ));

    _phoneSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.4, 0.72, curve: Curves.easeOut),
    ));

    _emailSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.52, 0.82, curve: Curves.easeOut),
    ));

    _buttonSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    ));

    _avatarScaleAnimation = CurvedAnimation(
      parent: _avatarController,
      curve: Curves.elasticOut,
    );

    _fadeController.forward();
    _slideController.forward();
    // Avatar bounces in with a slight delay
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _avatarController.forward();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _avatarController.dispose();
    _scrollController.dispose();

    // Dispose focus nodes
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();

    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _profileImage = File(image.path));
      // Re-trigger avatar bounce on new image selection
      _avatarController.reset();
      _avatarController.forward();
    }
  }

  Future<void> _completeProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final localDs = di.sl<AuthLocalDataSource>();
        await localDs.setCompletedProfile(true);
        if (mounted) {
          authNotifier.setCompletedProfile(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile completed successfully!')),
          );
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
    }
  }

  Future<void> _skipProfile() async {
    setState(() => _isLoading = true);
    try {
      final localDs = di.sl<AuthLocalDataSource>();
      await localDs.setCompletedProfile(true);
      if (mounted) {
        authNotifier.setCompletedProfile(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You can complete your profile later from settings')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
        context.go('/home');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.outfit(
        color: const Color.fromRGBO(156, 163, 175, 1),
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color.fromRGBO(156, 163, 175, 1), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color.fromRGBO(156, 163, 175, 1), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
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
      body: SafeArea(
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
                          'Complete Your Profile',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your information helps your estate verify and secure your account',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(11, 11, 11, 0.45),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Avatar bounces in with elastic scale
                  SlideTransition(
                    position: _avatarSlideAnimation,
                    child: Center(
                      child: Column(
                        children: [
                          const Text(
                            'Profile Photo',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          ScaleTransition(
                            scale: _avatarScaleAnimation,
                            child: GestureDetector(
                              onTap: _isLoading ? null : _pickImage,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _profileImage != null
                                        ? AppColors.primary
                                        : AppColors.divider,
                                    width: _profileImage != null ? 2.5 : 2,
                                  ),
                                  boxShadow: _profileImage != null
                                      ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.2),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    )
                                  ]
                                      : [],
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: _profileImage != null
                                      ? ClipOval(
                                    key: ValueKey(_profileImage!.path),
                                    child: Image.file(_profileImage!, fit: BoxFit.cover),
                                  )
                                      : const Icon(
                                    key: ValueKey('placeholder'),
                                    Icons.person,
                                    size: 60,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: TextButton(
                              key: ValueKey(_profileImage != null),
                              onPressed: _isLoading ? null : _pickImage,
                              child: Text(
                                _profileImage != null ? 'Change Photo' : 'Upload Photo',
                                style: const TextStyle(color: AppColors.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Full Name field
                  SlideTransition(
                    position: _nameSlideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Full Name',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _fullNameController,
                          focusNode: _nameFocusNode,
                          enabled: !_isLoading,
                          decoration: _fieldDecoration('Enter your full name'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter your full name'
                              : null,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_phoneFocusNode);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Phone field
                  SlideTransition(
                    position: _phoneSlideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Phone Number',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          focusNode: _phoneFocusNode,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.phone,
                          decoration: _fieldDecoration('Enter phone number'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_emailFocusNode);
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Prefilled from login; editable if needed',
                          style: GoogleFonts.outfit(
                            color: const Color.fromRGBO(156, 163, 175, 1),
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email field
                  SlideTransition(
                    position: _emailSlideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email (Optional)',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _fieldDecoration('Enter email'),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            _completeProfile();
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Prefilled from login; editable if needed',
                          style: GoogleFonts.outfit(
                            color: const Color.fromRGBO(156, 163, 175, 1),
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
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
                            text: _isLoading ? 'Saving...' : 'Continue',
                            onPressed: _isLoading ? () {} : _completeProfile,
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
                              onPressed: _isLoading ? null : _skipProfile,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Text(
                                  key: ValueKey(_isLoading),
                                  _isLoading ? 'Please wait...' : 'Skip for now',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
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
    );
  }
}