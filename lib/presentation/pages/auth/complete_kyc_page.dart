import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

/// ESTATE MODEL
class Estate {
  final String id;
  final String name;

  Estate({
    required this.id,
    required this.name,
  });
}

class CompleteKycPage extends StatefulWidget {
  const CompleteKycPage({super.key});

  @override
  State<CompleteKycPage> createState() => _CompleteKycPageState();
}

class _CompleteKycPageState extends State<CompleteKycPage>
    with TickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _houseUnit = TextEditingController();

  final ImagePicker picker = ImagePicker();

  File? profileImage;
  File? utilityBill;

  Estate? selectedEstate;

  int step = 0;

  /// Sample estates (replace with API later)
  final List<Estate> estates = [
    Estate(id: "1", name: "Alaka Estate"),
    Estate(id: "2", name: "Lekki Phase 1"),
    Estate(id: "3", name: "Chevron Estate"),
    Estate(id: "4", name: "Banana Island"),
  ];

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _email.dispose();
    _houseUnit.dispose();
    super.dispose();
  }

  /// PICK PROFILE IMAGE
  Future<void> pickProfile() async {
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  /// PICK UTILITY BILL
  Future<void> pickUtilityBill() async {
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        utilityBill = File(image.path);
      });
    }
  }

  /// SELECT ESTATE
  Future<void> selectEstate() async {
    final estate = await showModalBottomSheet<Estate>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: estates.length,
          itemBuilder: (context, index) {

            final e = estates[index];

            return ListTile(
              title: Text(e.name),
              onTap: () {
                Navigator.pop(context, e);
              },
            );
          },
        );
      },
    );

    if (estate != null) {
      setState(() {
        selectedEstate = estate;
      });
    }
  }

  /// NEXT STEP
  void nextStep() {
    if (step < 2) {
      setState(() => step++);
    }
  }

  /// PREVIOUS STEP
  void previousStep() {
    if (step > 0) {
      setState(() => step--);
    }
  }

  double progress() {
    return (step + 1) / 3;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(  flexibleSpace: Container(color: Colors.white),
        backgroundColor: Colors.white,
        elevation: 0,
        title:   Text("Complete KYC", style: GoogleFonts.outfit(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),),
        leading: GestureDetector(
          onTap: () =>   context.go("/home"),
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

      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {

          /// SHOW LOADER
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const _SubmittingDialog(),
            );
          }

          /// SUCCESS
          if (state is AuthAuthenticated) {

            /// wait before closing loader
            Future.delayed(const Duration(seconds: 4), () {

              Navigator.pop(context); // close loader

              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [

                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 60,
                        ),

                        SizedBox(height: 16),

                        Text(
                          "KYC Successfully Submitted",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );

              /// navigate after success message
              Future.delayed(const Duration(seconds: 2), () {
                context.go("/home");
              });

            });
          }

          /// ERROR
          if (state is AuthError) {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },

        /// 🔴 THIS WAS MISSING
        child: Column(
          children: [

            /// PROGRESS BAR
            Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  backgroundColor: const Color.fromRGBO(156, 163, 175, 1),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  value: progress(),
                  minHeight: 8,
                ),
              ),
            ),

            step <= 1
                ?  Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Your information helps your estate verify and secure your account',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: const Color.fromRGBO(11, 11, 11, 0.45),
            ),
          ),
        ) :  Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Select your estate and confirm your house/unit number to continue.',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: const Color.fromRGBO(11, 11, 11, 0.45),
            ),
          ),
        ),

            /// STEPS
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: step == 0
                    ? stepProfile()
                    : step == 1
                    ? stepPersonal()
                    : stepAddress(),
              ),
            ),

            /// BUTTONS
            bottomButtons(),
          ],
        ),
      ),);
  }

  /// STEP 1 - PROFILE
  Widget stepProfile() {
    return Center(
      key: const ValueKey(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          GestureDetector(
            onTap: pickProfile,
            child: CircleAvatar(
              radius: 70,
              backgroundImage:
              profileImage != null ? FileImage(profileImage!) : null,
              child: profileImage == null
                  ? const Icon(Icons.camera_alt, size: 40)
                  : null,
            ),
          ),

          const SizedBox(height: 20),

            Text("Upload Profile Picture",  style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: const Color.fromRGBO(11, 11, 11, 0.45),
          ),),
        ],
      ),
    );
  }

  /// STEP 2 - PERSONAL DETAILS
  Widget stepPersonal() {
    return Padding(
      key: const ValueKey(2),
      padding: const EdgeInsets.all(20),

      child: Form(
        key: _formKey,
        child: Column(
          children: [

            Row(
              children: [
                Text("Full Name",  style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black,
                ),),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _fullName,
              decoration: InputDecoration(
                labelText: "Choose Estate Name",      labelStyle: GoogleFonts.outfit(
                color: const Color.fromRGBO(11, 11, 11, 0.45),
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
              validator: (v) =>
              v!.isEmpty ? "Please enter your name" : null,
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Text("Phone Number",  style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black,
                ),),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phone,
              decoration:   InputDecoration(      labelStyle: GoogleFonts.outfit(
                color: const Color.fromRGBO(11, 11, 11, 0.45),
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
                labelText: "Phone Number",
              ),
              validator: (v) =>
              v!.isEmpty ? "Please enter phone number" : null,
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Text("Email (optional)",  style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black,
                ),),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _email,
              decoration:   InputDecoration(
                labelText: "Input Email)",      labelStyle: GoogleFonts.outfit(
                color: const Color.fromRGBO(11, 11, 11, 0.45),
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
            ),
          ],
        ),
      ),
    );
  }

  /// STEP 3 - ESTATE + ADDRESS
  Widget stepAddress() {
    return Padding(
      key: const ValueKey(3),
      padding: const EdgeInsets.all(20),

      child: Column(
        children: [

          /// SELECT ESTATE
          GestureDetector(
            onTap: selectEstate,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(
                    selectedEstate?.name ?? "Select your estate",
                    style: TextStyle(
                      color: selectedEstate == null
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),

                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// HOUSE UNIT
          TextField(
            controller: _houseUnit,
            decoration:   InputDecoration(
              labelText: "House / Unit Number",     labelStyle: GoogleFonts.outfit(
              color: const Color.fromRGBO(11, 11, 11, 0.45),
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
          ),

          const SizedBox(height: 30),

          /// UTILITY BILL
          GestureDetector(
            onTap: pickUtilityBill,
            child: Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Row(
                children: [

                  const Icon(Icons.upload_file),

                  const SizedBox(width: 10),

                  Text(
                    utilityBill != null
                        ? "Utility bill uploaded"
                        : "Upload utility bill",
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// BOTTOM BUTTONS
  Widget bottomButtons() {

    return Padding(
      padding: const EdgeInsets.all(20),

      child: Row(
        children: [

          if (step > 0)
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(
                      color: Color.fromRGBO(156, 163, 175, 1),
                      width: 3,
                    ),
                  ),
                  onPressed: previousStep,
                  child: const Text("Back"),
                ),
              ),
            ),

          const SizedBox(width: 10),

          Expanded(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {

                final loading = state is AuthLoading;

                return SizedBox(height: 48,
                  child: ElevatedButton(

                    onPressed: loading
                        ? null
                        : () {

                      if (step == 1) {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        nextStep();
                      }

                      else if (step == 2) {

                        if (selectedEstate == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text("Please select an estate"),
                            ),
                          );
                          return;
                        }

                        if (utilityBill == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Please upload utility bill"),
                            ),
                          );
                          return;
                        }

                        context.read<AuthBloc>().add(
                          CompleteKycEvent(
                            fullName: _fullName.text,
                            phoneNumber: _phone.text,
                            email: _email.text,
                            estateId: selectedEstate!.id,
                            profileImage: profileImage?.path,
                          ),
                        );
                      }

                      else {
                        nextStep();
                      }
                    },

                    child: Text(step == 2 ? "Submit KYC" : "Next"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class _SubmittingDialog extends StatelessWidget {
  const _SubmittingDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [

            CircularProgressIndicator(),

            SizedBox(height: 20),

            Text(
              "Submitting for review...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}