import 'package:flutter/material.dart';
import '../constants/app_environment.dart';

class DevBadge extends StatelessWidget {
  const DevBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Only show in development mode
    if (!AppEnvironment.isDevelopment) return const SizedBox.shrink();

    return Positioned(
      top: 40,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bug_report, size: 14, color: Colors.white),
            SizedBox(width: 4),
            Text(
              'MOCK MODE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}