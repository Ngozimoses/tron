// lib/presentation/pages/settings/about_qrcl_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class AboutQRCLPage extends StatelessWidget {
  const AboutQRCLPage({Key? key}) : super(key: key);

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
        title: const Text(
          'About QRCL',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About Us',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'The provided Information Architecture (IA) for the Soft Errands customer portal is comprehensive and well-structured, aligning closely with the PRD\'s emphasis on trust, convenience, and human-centric errands for busy users in Lagos, Nigeria. It prioritizes core flows like onboarding, task creation, and tracking, while incorporating elements like real-time updates and escrow payments to build reliability. However, based on modern UX best practices (e.g., from apps like Uber, Glovo, or TaskRabbit), user preferences for quick, frictionless experiences (especially for time-strapped professionals and families), and the PRD\'s goals of stress-free errands and high completion rates (targeting 80%+ successful tasks), I recommend several targeted changes.\n\n'
                    'These aim to reduce drop-off rates, enhance personalization, improve accessibility, and boost engagement without overcomplicating the MVP. I\'ll outline each suggested change, explain why it\'s beneficial (drawing from user preferences like speed, trust, simplicity, and mobile-first habits), and how to apply it (including integration into the existing structure).',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}