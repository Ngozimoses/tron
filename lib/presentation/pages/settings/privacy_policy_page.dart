// lib/presentation/pages/settings/privacy_policy_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

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
        title:   Text(
          'Privacy Policy',
          style: GoogleFonts.outfit(
            color: AppColors.primaryblack,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),centerTitle: false,
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child:  Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromRGBO(156, 163, 175, 0.2),
                    width: 0.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(
                      'Privacy Policy',
                      style: GoogleFonts.outfit(
                        color: AppColors.primaryblack,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                      Text(
                      'The provided Information Architecture (IA) for the Soft Errands customer portal is comprehensive and well-structured, aligning closely with the PRD\'s emphasis on trust, convenience, and human-centric errands for busy users in Lagos, Nigeria. It prioritizes core flows like onboarding, task creation, and tracking, while incorporating elements like real-time updates and escrow payments to build reliability. However, based on modern UX best practices (e.g., from apps like Uber, Glovo, or TaskRabbit), user preferences for quick, frictionless experiences (especially for time-strapped professionals and families), and the PRD\'s goals of stress-free errands and high completion rates (targeting 80%+ successful tasks), I recommend several targeted changes.\n\n'
                          'These aim to reduce drop-off rates, enhance personalization, improve accessibility, and boost engagement without overcomplicating the MVP. I\'ll outline each suggested change, explain why it\'s beneficial (drawing from user preferences like speed, trust, simplicity, and mobile-first habits), and how to apply it (including integration into the existing structure).',
                      style: GoogleFonts.outfit(
                          color: AppColors.primaryblack,
                          fontSize: 14,
                          height: 1.6,fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Accept privacy policy
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Privacy Policy accepted'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    // Decline privacy policy
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Decline Privacy Policy'),
                        content: const Text('You must accept the privacy policy to continue using the app.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    'Decline',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
