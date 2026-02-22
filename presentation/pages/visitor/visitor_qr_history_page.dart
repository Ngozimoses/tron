// lib/presentation/pages/visitor/visitor_qr_history_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Visitor QR History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Active', 'Expired', 'Revoked'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? AppColors.primary : Colors.white,
                        foregroundColor: isSelected ? Colors.white : AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        children: [
                          Text(filter),
                          if (filter == 'All') ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white.withOpacity(0.2) : AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${_visitorQRs.length}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
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

  Widget _buildQRCard(Map<String, dynamic> qr) {
    final isActive = qr['status'] == 'Active';
    final isExpired = qr['status'] == 'Expired';
    final isRevoked = qr['status'] == 'Revoked';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: qr['avatar'] != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(qr['avatar'], fit: BoxFit.cover),
                )
                    : Icon(
                  qr['type'] == 'Delivery' ? Icons.local_shipping : Icons.person,
                  color: AppColors.textHint,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      qr['name'],
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Purpose: ${qr['purpose']}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Status: ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.green.withOpacity(0.1)
                                : isExpired
                                ? Colors.orange.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            qr['status'],
                            style: TextStyle(
                              color: isActive
                                  ? Colors.green
                                  : isExpired
                                  ? Colors.orange
                                  : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (isActive) ...[
                      Row(
                        children: [
                          const Text(
                            'Expires in: ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            qr['expiresIn'],
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ] else if (isExpired) ...[
                      Text(
                        'Expired: ${qr['expired']}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ] else if (isRevoked) ...[
                      Text(
                        'Revoked: ${qr['revoked']}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (isActive) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/visitor-qr/${qr['id']}');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View QR',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showRevokeDialog(qr);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Revoke'),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Regenerate QR
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Regenerate QR',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
                if (isRevoked) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Delete QR
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Delete'),
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

  void _showRevokeDialog(Map<String, dynamic> qr) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revoke QR Code'),
        content: Text('Are you sure you want to revoke the QR code for ${qr['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
}