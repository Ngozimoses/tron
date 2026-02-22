// lib/presentation/pages/auth/connect_estate_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';

class ConnectEstatePage extends StatefulWidget {
  const ConnectEstatePage({Key? key}) : super(key: key);

  @override
  State<ConnectEstatePage> createState() => _ConnectEstatePageState();
}

class _ConnectEstatePageState extends State<ConnectEstatePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEstate;
  final _unitNumberController = TextEditingController();

  final List<String> _estates = [
    'Alaska Estate',
    'Green Valley Estate',
    'Sunrise Gardens',
    'Palm Residence',
  ];

  @override
  void dispose() {
    _unitNumberController.dispose();
    super.dispose();
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

                    color:Color.fromRGBO(11, 11, 11, 0.45),
                  ),
                ),
                const SizedBox(height: 40),

                // Select Estate Dropdown
                Text(
                  'Select Your Estate',
                  style: GoogleFonts.outfit(
                    fontSize: 16, fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color.fromRGBO(156, 163, 175, 1),
                      width: 1,),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedEstate,
                      hint: Text(
                        'Choose Estate Name',
                        style: GoogleFonts.outfit(color: Color.fromRGBO(156, 163, 175, 1),fontWeight: FontWeight.w400,fontSize: 16),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textHint),
                      items: _estates.map((estate) {
                        return DropdownMenuItem(
                          value: estate,
                          child: Text(
                            estate,
                            style: GoogleFonts.outfit(fontSize: 16, color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedEstate = value);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Unit Number Field
                Text(
                  'House / Unit Number',
                  style: GoogleFonts.outfit(
                    fontSize: 16, fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _unitNumberController,
                  decoration: InputDecoration(
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

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your unit number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Continue Button
                CustomButton(
                  text: 'Continue',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.push('/complete-profile', extra: {
                        'estate': _selectedEstate,
                        'unitNumber': _unitNumberController.text,
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Can't find estate
                Center(
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contact estate admin for assistance')),
                      );
                    },
                    child: Text(
                      'I can\'t find my estate',
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