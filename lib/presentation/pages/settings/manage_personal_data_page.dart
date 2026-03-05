// lib/presentation/pages/settings/manage_personal_data_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/app_colors.dart';

class ManagePersonalDataPage extends StatefulWidget {
  const ManagePersonalDataPage({Key? key}) : super(key: key);

  @override
  State<ManagePersonalDataPage> createState() => _ManagePersonalDataPageState();
}

class _ManagePersonalDataPageState extends State<ManagePersonalDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _estateNameController = TextEditingController();
  final _unitNumberController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing data
    _fullNameController.text = 'Lawal Rahman';
    _phoneController.text = '+234 801 234 5678';
    _emailController.text = 'Lawalabdulrahman@gmail.com';
    _estateNameController.text = 'Alaska Estate';
    _unitNumberController.text = 'No. 42 awayaya';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _estateNameController.dispose();
    _unitNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
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
        title: const Text(
          'Manage Personal Data',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your information helps your estate verify and secure your account',
                style: TextStyle(
                  color:  Color.fromRGBO(156, 163, 175, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),

              // Profile Photo
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Profile Photo',
                      style: TextStyle(
                        color: AppColors.primaryblack,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.divider, width: 2),
                        ),
                        child: _profileImage != null
                            ? ClipOval(
                          child: Image.file(
                            _profileImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : const Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _pickImage,
                      child: const Text(
                        'Change Photo',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Full Name
              const Text(
                'Full Name',
                style: TextStyle(
                  color: AppColors.primaryblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _fullNameController,
                decoration:   InputDecoration(

                  hintText: 'Choose Estate Name',
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
              const SizedBox(height: 24),

              // Phone Number
              const Text(
                'Phone Number',
                style: TextStyle(
                  color: AppColors.primaryblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration:   InputDecoration(

                  hintText: 'e.g. Block A, Unit 12',
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
              const Text(
                'Prefilled from login, editable if needed',
                style: TextStyle(
                  color:  Color.fromRGBO(156, 163, 175, 1),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),

              // Email (Optional)
              const Text(
                'Email (Optional)',
                style: TextStyle(
                  color: AppColors.primaryblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration:   InputDecoration(

                  hintText: 'e.g. Block A, Unit 12',
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
              const Text(
                'Prefilled from login, editable if needed',
                style: TextStyle(
                  color:  Color.fromRGBO(156, 163, 175, 1),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),

              // Estate Name
              const Text(
                'Estate Name:',
                style: TextStyle(
                  color: AppColors.primaryblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _estateNameController.text,
                style: const TextStyle(
                  color:  Color.fromRGBO(156, 163, 175, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),

              // Unit Number
              const Text(
                'Unit Number',
                style: TextStyle(
                  color: AppColors.primaryblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _unitNumberController.text,
                style: const TextStyle(
                  color:  Color.fromRGBO(156, 163, 175, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Personal data updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}