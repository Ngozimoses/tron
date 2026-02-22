import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../../../core/theme/app_colors.dart';

class ScannerScreen extends StatelessWidget {
  final String image;
  const ScannerScreen(  {super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive size based on screen constraints
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;

        // Determine the size (square) - use the smaller dimension with padding
        double size = screenWidth < screenHeight
            ? screenWidth * 0.8  // 80% of width on mobile
            : screenHeight * 0.7; // 70% of height on tablet/desktop

        // Cap the size for very large screens
        size = size.clamp(250.0, 300.0);

        return Container(

          child: QRScannerFigmaDesign(
            size: size,image:image
          ),
        );
      },
    );
  }
}

class QRScannerFigmaDesign extends StatefulWidget {
  final double size;
final String image;
  const QRScannerFigmaDesign({
    super.key,
    required this.size,   required this.image,
  });

  @override
  State<QRScannerFigmaDesign> createState() => _QRScannerFigmaDesignState();
}

class _QRScannerFigmaDesignState extends State<QRScannerFigmaDesign>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;
  late final Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    _scanAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(
        parent: _scanController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = widget.size;
    double blurEllipseSize = size * 1.28; // ~380/296 ratio
    double whiteBgSize = size * 1.04; // ~308/296 ratio
    double qrSize = size * 0.85; // Padding adjusted

    return Stack(
      children: [
        // Main Group container
        Positioned.fill(
          child: Center(
            child: SizedBox(
              width: size,
              height: size,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: SizedBox(
                        width: blurEllipseSize,
                        height: blurEllipseSize,
                        child: CustomPaint(
                          painter: BlurredEllipsePainter(
                            color:  AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // White background with dashed border
                  Positioned(
                    left: 15,
                    right: 15,
                    top: 15,bottom: 15,
                    child: Center(
                      child: Container(
                        width: whiteBgSize,
                        height: whiteBgSize,
                        decoration: BoxDecoration(
color: Colors.white,
                          borderRadius: BorderRadius.circular(size * 0.08),
                        ),

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(size * 0.091), // ~27/296 ratio
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: IgnorePointer(
                                    child: CustomPaint(
                                      painter: DashedBorderPainter(
                                        color: Colors.black,
                                        strokeWidth: size * 0.005, // Responsive stroke width
                                        radius: size * 0.1, // Responsive radius
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                    ),
                  ),



                  // QR Code Image
                  Positioned(
                    left: 17,
                    right: 17,
                    top: 17, bottom: 17,// ~5/296 ratio
                    child: Container(
                      width: size * 1.003, // ~297/296 ratio
                      height: size * 1.003,
                      child: ClipRRect(

                        child: Image.asset(widget.image
                          ,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: size * 0.16,
                                      color: Colors.grey.shade600,
                                    ),
                                    SizedBox(height: size * 0.027),
                                    Text(
                                      'QR Code Image',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: size * 0.04,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // // Blur overlay
                  // Positioned(
                  //   left: 20,
                  //   right: 20,
                  //   top: 20,bottom: 20,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(size * 0.04),
                  //     child: BackdropFilter(
                  //       filter: ui.ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
                  //       child: Container(
                  //         width: size * 1.0001,
                  //         height: size * 1.000,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(size * 0.1),
                  //
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),

        // Scanning line
        AnimatedBuilder(
          animation: _scanAnimation,
          builder: (context, child) {
            double scanLineWidth = size * 0.946; // ~280/296 ratio
            double scanLineOffset = size * 0.027; // ~8/296 ratio (adjusted for centering)

            return Positioned(
              left: 0,
              right: 0,
              top: scanLineOffset + (_scanAnimation.value * (size - 2 * scanLineOffset - 3)),
              child: Center(
                child: Container(
                  width: scanLineWidth,
                  height: size * 0.01, // Responsive line height
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        AppColors.primary,
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xCC15803D),
                        blurRadius: size * 0.05,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: const Color(0x6615803D),
                        blurRadius: size * 0.1,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Custom painter for the blurred ellipse
class BlurredEllipsePainter extends CustomPainter {
  final Color color;

  BlurredEllipsePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 17);

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.41, // ~156/380 ratio
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for dashed border
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(strokeWidth/2, strokeWidth/2,
            size.width - strokeWidth, size.height - strokeWidth),
        Radius.circular(radius - strokeWidth/2),
      ));

    // Create dash effect with responsive dash sizes
    final dashWidth = size.width * 0.2; // ~10/296 ratio
    final dashSpace = size.width * 0.5; // ~8/296 ratio
    double distance = 0.0;

    final pathMetrics = path.computeMetrics().toList();
    for (final metric in pathMetrics) {
      while (distance < metric.length) {
        final extractPath = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Responsive wrapper widget for easy usage
class ResponsiveScannerScreen extends StatelessWidget {
  const ResponsiveScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade50,
              Colors.grey.shade200,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Scanner container
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return const ScannerScreen(image: '',);
                  },
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              // Instruction text
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Text(
                  'Place the QR code within the frame to scan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // Scan button
              ElevatedButton(
                onPressed: () {
                  // Add scan functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF15803D),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: MediaQuery.of(context).size.height * 0.015,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Start Scanning',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.w600,
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