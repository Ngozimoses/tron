// lib/presentation/pages/settings/add_sub_resident_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/app_colors.dart';

class AddSubResidentPage extends StatefulWidget {
  const AddSubResidentPage({Key? key}) : super(key: key);

  @override
  State<AddSubResidentPage> createState() => _AddSubResidentPageState();
}

class _AddSubResidentPageState extends State<AddSubResidentPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedRelationship;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Permissions
  bool _createVisitorQR = false;
  bool _createEvent = false;
  bool _generateEventQR = false;
  bool _viewAccessLogs = false;
  bool _viewPayments = false;
  bool _incidentReport = false;
  bool _makePayment = false;

  final List<String> _relationships = [
    'Brother',
    'Sister',
    'Father',
    'Mother',
    'Son',
    'Daughter',
    'Spouse',
    'Friend',
    'Other',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
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
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),centerTitle: false,
        title: Text(
          'Add Sub Resident',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
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
              // Info Text
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'An invite will be sent to the number entered',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Full Name
                Text(
                'Full Name',
                style: GoogleFonts.outfit(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  hintText: 'e.g. Blessing Adeyemi',
                  hintStyle: GoogleFonts.outfit(
                    color: const Color.fromRGBO(156, 163, 175, 1),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(156, 163, 175, 0.6),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(156, 163, 175, 0.6),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(156, 163, 175, 0.6),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Phone Number
                Text(
                'Phone Number',
                style: GoogleFonts.outfit(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  hintStyle: GoogleFonts.outfit(
                    color: const Color.fromRGBO(156, 163, 175, 1),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(156, 163, 175, 0.6),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(156, 163, 175, 0.6),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(156, 163, 175, 0.6),
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
                  ),   ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Email
                Text(
                'Email',
                style: GoogleFonts.outfit(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                  hintStyle: GoogleFonts.outfit(
                    color: const Color.fromRGBO(156, 163, 175, 1),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(156, 163, 175, 0.6),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(156, 163, 175, 0.6),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(156, 163, 175, 0.6),
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
                  ),   ),
              ),
              const SizedBox(height: 20),

              // Relationship
                Text(
                'Relationship',
                style: GoogleFonts.outfit(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color.fromRGBO(156, 163, 175, 0.6),
                    width: 1,),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedRelationship,
                    hint: Text(
                      'Select Relationship',
                      style: GoogleFonts.outfit(
                        color: const Color.fromRGBO(156, 163, 175, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 16,)  ),
                    icon: const Icon(Icons.chevron_right, color: AppColors.textHint),
                    items: _relationships.map((relationship) {
                      return DropdownMenuItem(
                        value: relationship,
                        child: Text(relationship),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRelationship = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Permissions
                Text(
                'Permissions (Optional, if estate allows)',
                style: GoogleFonts.outfit(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              _buildPermissionCheckbox('Create Visitor QR', _createVisitorQR, (value) {
                setState(() {
                  _createVisitorQR = value!;
                });
              }),
              _buildPermissionCheckbox('Create Event', _createEvent, (value) {
                setState(() {
                  _createEvent = value!;
                });
              }),
              _buildPermissionCheckbox('Generate Event QR', _generateEventQR, (value) {
                setState(() {
                  _generateEventQR = value!;
                });
              }),
              _buildPermissionCheckbox('View Access Logs', _viewAccessLogs, (value) {
                setState(() {
                  _viewAccessLogs = value!;
                });
              }),
              _buildPermissionCheckbox('View Payments', _viewPayments, (value) {
                setState(() {
                  _viewPayments = value!;
                });
              }),
              _buildPermissionCheckbox('Incident Report', _incidentReport, (value) {
                setState(() {
                  _incidentReport = value!;
                });
              }),
              _buildPermissionCheckbox('Make Payment', _makePayment, (value) {
                setState(() {
                  _makePayment = value!;
                });
              }),
              const SizedBox(height: 24),

              // Image Upload
                Text(
                'Image (optional)',
                style: GoogleFonts.outfit(
                  color: const Color.fromRGBO(156, 163, 175, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (_image != null) ...[
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.divider),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Buttons
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width:154.5 ,height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.outfit(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(width:154.5 ,height: 48,
                    child: ElevatedButton(
                      onPressed: _addSubResident,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Add',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Expanded(
            child: Text(
              label,
              style:GoogleFonts.outfit(
                color: const Color.fromRGBO(156, 163, 175, 1),
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),   Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  void _addSubResident() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRelationship == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a relationship'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Add sub-resident logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sub-resident added successfully. Invite sent!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }
  }
}