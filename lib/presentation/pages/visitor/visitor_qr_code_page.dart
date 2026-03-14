// lib/presentation/pages/visitor/visitor_qr_code_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class VisitorQRCodePage extends StatefulWidget {
  final Map<String, dynamic> visitorData;

  const VisitorQRCodePage({
    Key? key,
    required this.visitorData,
  }) : super(key: key);

  @override
  State<VisitorQRCodePage> createState() => _VisitorQRCodePageState();
}

class _VisitorQRCodePageState extends State<VisitorQRCodePage> {
  bool _showFullInfo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(flexibleSpace: Container(
        color:Colors.white,
      ),
        backgroundColor: Colors.white,
        elevation: 0,
        title:   Text(
          'Visitor QR Code',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
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


              // Subtitle



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
              const SizedBox(height: 32),

              // Copy and Share Buttons
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40,width: 102,
                    child: OutlinedButton.icon(
                      onPressed: _copyToClipboard,
                      icon: const Icon(Icons.copy, size: 20,color: Colors.black,),
                      label: const Text('Copy',style: TextStyle(color: Colors.black,),),
                      style: OutlinedButton.styleFrom(backgroundColor:  Color.fromRGBO(0, 0, 0, 0.05),
                        side: BorderSide(color: Colors.transparent),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(height: 40,width: 102,
                    child: OutlinedButton.icon(
                      onPressed: _shareQRCode,
                      icon: const Icon(Icons.share, size: 20,color: Colors.black,),
                      label: const Text('Share',style: TextStyle(color: Colors.black,),),
                      style: OutlinedButton.styleFrom(backgroundColor:   Color.fromRGBO(0, 0, 0, 0.05),
                        side: BorderSide(color: Colors.transparent),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Show this QR at the estate gate',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryblack,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // View Full Information Dropdown
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showFullInfo = !_showFullInfo;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.05)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'View Full Information',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(11, 11, 11, 0.7),
                        ),
                      ),
                      Icon(
                        _showFullInfo ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),

              // Full Information (Expandable)
              if (_showFullInfo) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                        child: Column(
                          children: [
                            _buildInfoRow('Visitor Name', widget.visitorData['name'] ?? 'N/A'),
                            const SizedBox(height: 12),
                            _buildInfoRow('Purpose', widget.visitorData['purpose'] ?? 'N/A'),

                            const SizedBox(height: 12),
                            _buildInfoRow('Duration', widget.visitorData['duration'] ?? 'N/A'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                      Container(
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
                        child: Column(
                          children: [
                            _buildInfoRow('Status', widget.visitorData['status'] ?? 'Active'),
                            const SizedBox(height: 12),
                            _buildInfoRow('Visit Type', widget.visitorData['visitType'] ?? 'N/A'),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),

              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 48,
                    width: 154,
                    child: OutlinedButton(
                      onPressed: _revokePass,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color.fromRGBO(153, 27, 27, 1), width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child:   Text(
                        'Revoke Pass',
                        style: GoogleFonts.outfit(
                          color: Color.fromRGBO(153, 27, 27, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  String _generateQRData() {
    // Generate QR code data (JSON format)
    return '''
    {
      "type": "visitor",
      "name": "${widget.visitorData['name'] ?? ''}",
      "purpose": "${widget.visitorData['purpose'] ?? ''}",
      "visitType": "${widget.visitorData['visitType'] ?? ''}",
      "duration": "${widget.visitorData['duration'] ?? ''}",
      "timestamp": "${DateTime.now().toIso8601String()}"
    }
    ''';
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color:Color.fromRGBO(11, 11, 11, 0.7),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color:Color.fromRGBO(11, 11, 11, 0.7),
          ),
        ),
      ],
    );
  }

  void _copyToClipboard() {
    final qrData = _generateQRData();
    Clipboard.setData(ClipboardData(text: qrData));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR code copied to clipboard'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _shareQRCode() async {
    // In a real app, you would generate an image from the QR code
    // For now, we'll share the text data
    await Share.share(
      'Visitor QR Code\n${_generateQRData()}',
      subject: 'Visitor Access - ${widget.visitorData['name']}',
    );
  }

  void _revokePass() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Revoke Pass'),
        content: const Text('Are you sure you want to revoke this visitor pass?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              // Revoke logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pass revoked successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop(); // Go back to history
            },
            child: const Text('Revoke'),
          ),
        ],
      ),
    );
  }
}