// lib/presentation/pages/visitor/visitor_qr_view_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';

class VisitorQRViewPage extends StatelessWidget {
  final String visitorId;

  const VisitorQRViewPage({Key? key, required this.visitorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data - replace with actual data from visitorId
    final visitor = {
      'name': 'Rahman',
      'purpose': 'Guest Visit',
      'type': 'Guest Visit',
      'status': 'Active',
      'expiresIn': '00:45:22',
      'qrCode': 'QR_CODE_DATA',
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(flexibleSpace: Container(
        color:Colors.white,
      ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Visitor QR Code',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Show this at the Gate',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: QrImageView(
                      data: visitor['qrCode'] as String,
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Copy QR code
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('QR code copied')),
                            );
                          },
                          icon: const Icon(Icons.copy, color: AppColors.primary),
                          label: const Text(
                            'Copy',
                            style: TextStyle(color: AppColors.primary),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.divider),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Share QR code
                          },
                          icon: const Icon(Icons.share, color: AppColors.primary),
                          label: const Text(
                            'Share',
                            style: TextStyle(color: AppColors.primary),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.divider),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      // Toggle full information
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'View Full Information',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.expand_more,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  _showRevokeDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Revoke Pass',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRevokeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revoke QR Code'),
        content: const Text('Are you sure you want to revoke this QR code?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('QR code revoked successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Revoke'),
          ),
        ],
      ),
    );
  }
}