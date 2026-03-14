// lib/presentation/pages/events/event_qr_code_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class EventQRCodePage extends StatelessWidget {
  final Map<String, dynamic> eventData;

  const EventQRCodePage({
    Key? key,
    required this.eventData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(flexibleSpace: Container(
        color:Colors.white,
      ),
        backgroundColor: Colors.white,
        elevation: 0,
        title:     Text(
          eventData['eventName'] ?? 'Event',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),centerTitle: false,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              // Access Code Label
              Center(
                child: Text(
                  'Access Code',
                  style:  GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(11, 11, 11, 0.7),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // QR Code
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: _generateQRData(),
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Welcome Message
              Text(
                'Hello ${eventData['inviteeName'] ?? 'Guest'}, you have been invited to\n${eventData['eventName'] ?? 'Event'} by ${eventData['hostName'] ?? 'Host'}.',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(11, 11, 11, 0.7),
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 24),

              // Event Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color.fromRGBO(107, 114, 128, 0.4)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(107, 114, 128, 0.1), // Using the border color with low opacity
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      'Event Type',
                      eventData['eventType'] ?? 'N/A',
                      icon: Icons.event,
                      valueColor: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'Event Date',
                      eventData['eventDate'] ?? 'N/A',
                      icon: Icons.calendar_today,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'Event Time',
                      eventData['eventTime'] ?? 'N/A',
                      icon: Icons.access_time,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Copy and Share Buttons
              // Option with text (needs larger dimensions)
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Copy button with text
                  SizedBox(
                    height: 48,
                    width: 154, // Wider to accommodate text
                    child: OutlinedButton(
                      onPressed: () => _copyToClipboard(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.transparent),
                        padding: const EdgeInsets.symmetric(horizontal: 8), // Minimal padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.copy, size: 20),
                          SizedBox(width: 4),
                          Text('Copy', style: GoogleFonts.outfit(fontSize: 16,fontWeight: FontWeight.w500 ,color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Share button with text
                  SizedBox(
                    height: 48,
                    width: 154, // Wider to accommodate text
                    child: ElevatedButton(
                      onPressed: () => _shareQRCode(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 8), // Minimal padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share, size: 20),
                          SizedBox(width: 4),
                          Text('Share',style: GoogleFonts.outfit(fontSize: 16,fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String _generateQRData() {
    return '''
    {
      "type": "event",
      "eventName": "${eventData['eventName'] ?? ''}",
      "eventType": "${eventData['eventType'] ?? ''}",
      "eventDate": "${eventData['eventDate'] ?? ''}",
      "eventTime": "${eventData['eventTime'] ?? ''}",
      "hostName": "${eventData['hostName'] ?? ''}",
      "inviteeName": "${eventData['inviteeName'] ?? ''}",
      "timestamp": "${DateTime.now().toIso8601String()}"
    }
    ''';
  }

  Widget _buildDetailRow(String label, String value, {IconData? icon, Color? valueColor}) {
    return Row(
      children: [
        Icon(
          icon ?? Icons.info_outline,
          size: 18,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(11, 11, 11, 0.45),
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context) {
    final qrData = _generateQRData();
    Clipboard.setData(ClipboardData(text: qrData));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR code copied to clipboard'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _shareQRCode(BuildContext context) async {
    await Share.share(
      'Event Invitation: ${eventData['eventName']}\n${_generateQRData()}',
      subject: 'Event Invitation - ${eventData['eventName']}',
    );
  }
}