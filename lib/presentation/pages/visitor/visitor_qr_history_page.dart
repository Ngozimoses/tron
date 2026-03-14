// lib/presentation/pages/visitor/visitor_qr_history_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class VisitorQRHistoryPage extends StatefulWidget {
  const VisitorQRHistoryPage({Key? key}) : super(key: key);

  @override
  State<VisitorQRHistoryPage> createState() => _VisitorQRHistoryPageState();
}

class _VisitorQRHistoryPageState extends State<VisitorQRHistoryPage> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _visitorQRs = [
    {
      'id': '1',
      'name': 'Rahman',
      'avatar': null,
      'purpose': 'Guest Visit',
      'type': 'Guest Visit',
      'status': 'Active',
      'expiresIn': '00:45:22',
      'qrCode': 'QR_CODE_1',
    },
    {
      'id': '2',
      'name': 'Delivery Guy',
      'avatar': null,
      'purpose': 'Logistics Delivery',
      'type': 'Delivery',
      'status': 'Expired',
      'expired': 'Today, 2:15pm',
      'qrCode': 'QR_CODE_2',
    },
    {
      'id': '3',
      'name': 'Rahman',
      'avatar': null,
      'purpose': 'Guest Visit',
      'type': 'Guest Visit',
      'status': 'Revoked',
      'revoked': 'Yesterday, 4:50pm',
      'qrCode': 'QR_CODE_3',
    },
  ];

  List<Map<String, dynamic>> get _filteredQRs {
    if (_selectedFilter == 'All') return _visitorQRs;
    return _visitorQRs.where((qr) => qr['status'] == _selectedFilter).toList();
  }

  int _getCount(String status) {
    if (status == 'All') return _visitorQRs.length;
    return _visitorQRs.where((qr) => qr['status'] == status).length;
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
          'Visitor QR History',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),centerTitle: false,
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterTab('All', _getCount('All')),
                  const SizedBox(width: 8),
                  _buildFilterTab('Active', _getCount('Active')),
                  const SizedBox(width: 8),
                  _buildFilterTab('Expired', _getCount('Expired')),
                  const SizedBox(width: 8),
                  _buildFilterTab('Revoked', _getCount('Revoked')),
                ],
              ),
            ),
          ),

          // QR List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredQRs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final qr = _filteredQRs[index];
                return _buildQRCard(qr);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, int count) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary :Color.fromRGBO(254, 234, 220, 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                color: isSelected ? Colors.white : Color.fromRGBO(156, 163, 175, 1),
                fontWeight:   FontWeight.w400,
                fontSize: 12,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.2) : Color.fromRGBO(156, 163, 175, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: GoogleFonts.outfit(
                    color: isSelected ? Colors.white : Color.fromRGBO(249, 250, 251, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQRCard(Map<String, dynamic> qr) {
    final isActive = qr['status'] == 'Active';
    final isExpired = qr['status'] == 'Expired';
    final isRevoked = qr['status'] == 'Revoked';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Avatar and Name
          Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: qr['avatar'] != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    qr['avatar'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          _getIconForType(qr['type']),
                          color: AppColors.primary,
                          size: 24,
                        ),
                      );
                    },
                  ),
                )
                    : Center(
                  child: Icon(
                    _getIconForType(qr['type']),
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  qr['name'],
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Purpose Row
          Row(
            children: [
              Text(
                'Purpose',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(11, 11, 11, 0.7),
                ),
              ),
              const Spacer(),
              Text(
                qr['purpose'],
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(11, 11, 11, 0.7),
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Status Row
          Row(
            children: [
              Text(
                'Status',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(11, 11, 11, 0.7),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(qr['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  qr['status'],
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: _getStatusColor(qr['status']),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Time Info Row
          Row(
            children: [
              Text(
                isActive ? 'Expires in:' : (isExpired ? 'Expired:' : 'Revoked'),
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isActive ? Colors.orange : AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                isActive
                    ? qr['expiresIn']
                    : (isExpired ? qr['expired'] : qr['revoked']),
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isActive ? Colors.orange : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isActive) ...[
                // View QR Button
                SizedBox(height: 40,width: 130,
                  child: OutlinedButton(
                    onPressed: () { context.push('/visitor-qr-code', extra: {
                      'name': qr['name']?? 'John Doe',
                      'purpose':qr['purpose']?? 'Guest Visit',
                      'visitType': qr['type'] ?? 'guest',
                      'duration': qr['expiresIn'],
                      'status': qr['status'],
                    });


                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'View QR',
                      style: GoogleFonts.outfit(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Revoke Button
                SizedBox(height: 40,width: 130,
                  child: ElevatedButton(
                    onPressed: () {
                      _showRevokeDialog(qr);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade500,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Revoke',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Regenerate QR Button
                SizedBox(height: 40,width: 130,
                  child: OutlinedButton(
                    onPressed: () {
                      // Regenerate QR logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('QR regenerated')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Regenerate QR',
                      style: GoogleFonts.outfit(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (isRevoked) ...[
                  const SizedBox(width: 12),
                  // Delete Button
                  SizedBox(height: 40,width: 130,
                    child: ElevatedButton(
                      onPressed: () {
                        _showDeleteDialog(qr);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade500,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Delete',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String? type) {
    switch (type?.toLowerCase()) {
      case 'delivery':
        return Icons.delivery_dining;
      case 'service':
        return Icons.build;
      default:
        return Icons.person;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'expired':
        return Colors.grey;
      case 'revoked':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showRevokeDialog(Map<String, dynamic> qr) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Revoke QR Code'),
        content: Text(
          'Are you sure you want to revoke the QR code for ${qr['name']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                qr['status'] = 'Revoked';
                qr['revoked'] = 'Just now';
              });
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

  void _showDeleteDialog(Map<String, dynamic> qr) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete QR Code'),
        content: Text(
          'Are you sure you want to delete the QR code for ${qr['name']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _visitorQRs.remove(qr);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('QR code deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}