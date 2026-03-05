// lib/presentation/pages/settings/change_phone_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class ChangePhonePage extends StatefulWidget {
  const ChangePhonePage({Key? key}) : super(key: key);

  @override
  State<ChangePhonePage> createState() => _ChangePhonePageState();
}

class _ChangePhonePageState extends State<ChangePhonePage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPhoneController = TextEditingController();
  final _newPhoneController = TextEditingController();
  final _confirmPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentPhoneController.text = '+234 8123457890';
  }

  @override
  void dispose() {
    _currentPhoneController.dispose();
    _newPhoneController.dispose();
    _confirmPhoneController.dispose();
    super.dispose();
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
centerTitle: false,
        title: const Text(
          'Change Phone Number',
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
              // Current Phone Number
                Text(
                'Current Phone Number',
                  style: GoogleFonts.outfit(
                    color: AppColors.primaryblack,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _currentPhoneController,
                enabled: false,
                decoration:   InputDecoration(

                  hintText: 'Current Phone Number',
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
              ),),
              const SizedBox(height: 24),

              // New Phone Number
                Text(
                'New Phone Number',
                  style: GoogleFonts.outfit(
                    color: AppColors.primaryblack,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _newPhoneController,
                keyboardType: TextInputType.phone,
                decoration:   InputDecoration(
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
                  hintText: 'Enter phone number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new phone number';
                  }
                  if (value.length < 11) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Confirm New Phone Number
                Text(
                'Confirm New Phone Number',
                style: GoogleFonts.outfit(
                  color: AppColors.primaryblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmPhoneController,
                keyboardType: TextInputType.phone,
                decoration:   InputDecoration(
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
                  hintText: 'Confirm new phone number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm phone number';
                  }
                  if (value != _newPhoneController.text) {
                    return 'Phone numbers do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Continue Button
              SizedBox(height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Navigate to OTP verification
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OTP sent to new number')),
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
                    'Continue',
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