// lib/presentation/pages/auth/complete_profile_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({Key? key}) : super(key: key);

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  File? _profileImage;
  Map<String, dynamic>? _estateData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _estateData = GoRouterState.of(context).extra as Map<String, dynamic>?;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _profileImage = File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading:GestureDetector(
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
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
                    color:Color.fromRGBO(11, 11, 11, 0.45),
                  ),
                ),
                const SizedBox(height: 32),

                // Profile Photo
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Profile Photo',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.divider, width: 2),
                          ),
                          child: _profileImage != null
                              ? ClipOval(child: Image.file(_profileImage!, fit: BoxFit.cover))
                              : const Icon(Icons.person, size: 60, color: AppColors.textHint),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _pickImage,
                        child: const Text('Change Photo', style: TextStyle(color: AppColors.primary)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Full Name
                const Text(
                  'Full Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _fullNameController,
                  decoration:   InputDecoration(hintText: 'Enter your full name',
                    hintStyle: GoogleFonts.outfit(color: Color.fromRGBO(156, 163, 175, 1),fontWeight: FontWeight.w400,fontSize: 16),

                    // Add border with black color and 12 radius
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(156, 163, 175, 1),
                        width: 1, // You can adjust the width as needed
                      ),
                    ),

                    // You might also want to define borders for different states
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
                        width: 1, // Slightly thicker when focused for better UX
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.red, // Keep error border red for visibility
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

                    // Add some content padding for better appearance
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),

                  validator: (value) => value == null || value.isEmpty ? 'Please enter your full name' : null,
                ),
                const SizedBox(height: 24),

                // Phone Number
                const Text(
                  'Phone Number',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration:   InputDecoration(hintText: 'Enter phone number',
                    hintStyle: GoogleFonts.outfit(color: Color.fromRGBO(156, 163, 175, 1),fontWeight: FontWeight.w400,fontSize: 16),

                    // Add border with black color and 12 radius
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(156, 163, 175, 1),
                        width: 1, // You can adjust the width as needed
                      ),
                    ),

                    // You might also want to define borders for different states
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
                        width: 1, // Slightly thicker when focused for better UX
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.red, // Keep error border red for visibility
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

                    // Add some content padding for better appearance
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Prefilled from login; editable if needed',
                  style: GoogleFonts.outfit(color: Color.fromRGBO(156, 163, 175, 1),fontWeight: FontWeight.w400,fontSize: 12),

                ),
                const SizedBox(height: 24),

                // Email (Optional)
                const Text(
                  'Email (Optional)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration:   InputDecoration(hintText: 'Enter email',
                    hintStyle: GoogleFonts.outfit(color: Color.fromRGBO(156, 163, 175, 1),fontWeight: FontWeight.w400,fontSize: 16),

                    // Add border with black color and 12 radius
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(156, 163, 175, 1),
                        width: 1, // You can adjust the width as needed
                      ),
                    ),

                    // You might also want to define borders for different states
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
                        width: 1, // Slightly thicker when focused for better UX
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.red, // Keep error border red for visibility
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

                    // Add some content padding for better appearance
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Prefilled from login; editable if needed',
                  style:  GoogleFonts.outfit(color: Color.fromRGBO(156, 163, 175, 1),fontWeight: FontWeight.w400,fontSize: 12),

                ),
                const SizedBox(height: 40),

                // Continue Button
                CustomButton(
                  text: 'Continue',
                  onPressed: () {
                    // Skip validation - user can skip profile completion
                    context.go('/home');
                  },
                ),
                const SizedBox(height: 16),

                // Skip Button
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/home'),
                    child: Text(
                      'Skip for now',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}