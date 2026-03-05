import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tron/presentation/pages/onboarding/qrcodeanimation.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/onboarding/onboarding_bloc.dart';
import '../../blocs/onboarding/onboarding_event.dart';
import '../../blocs/onboarding/onboarding_state.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../core/widgets/svg_icons.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _pages = [
    OnboardingContent(
        image: 'assets/images/house.png',
        title: 'Alaska Estate',
        description: 'Scan . Get Access. Get Secured',
        more_description: ''
    ),
    OnboardingContent(
        image: 'assets/images/qrcode.png',
        title: 'Alaska Estate',
        description: 'Secure Your Estate',
        more_description: "Generate visitor QR codes, use your personal dynamic QR, Create event and access your estate safely"
    ),
  ];

  @override
  void initState() {
    super.initState();
    context.read<OnboardingBloc>().add(OnboardingStarted());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      context.read<OnboardingBloc>().add(OnboardingPageChanged(index));
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) => _buildPage(_pages[index]),
                  ),
                ),
                _buildIndicators(),
                _buildBottomSection(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingContent content) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgIcons.estate(size: 32),
              const SizedBox(width: 5),
              Text(
                content.title,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryblack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
              width: 250,
              height: 250,
              child: ScannerScreen(image: content.image)
          ),
          const SizedBox(height: 30),

          // Modified description with colored text for first page
          if (content.description == 'Scan . Get Access. Get Secured')
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: 'Scan . Get Access. ',
                    style: TextStyle(color: AppColors.primaryblack),
                  ),
                  TextSpan(
                    text: 'Get Secured',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
            )
          else
            Text(
              content.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryblack,
              ),
            ),

          const SizedBox(height: 16),

          Text(
            content.more_description,
            textAlign: TextAlign.left,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? AppColors.primary : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('Back'),
            )
          else
            const SizedBox.shrink(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            onPressed: () async {
              if (_currentPage == _pages.length - 1) {
                context.read<OnboardingBloc>().add(OnboardingCompleted());
                await Future.delayed(const Duration(milliseconds: 500));
                if (mounted) context.go('/identify');
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Text(
              _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
              style: GoogleFonts.outfit(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingContent {
  final String image;
  final String title;
  final String description;
  final String more_description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
    required this.more_description,
  });
}