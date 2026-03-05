// lib/presentation/pages/settings/edit_sub_resident_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class EditSubResidentPage extends StatefulWidget {
  final String subResidentId;

  const EditSubResidentPage({Key? key, required this.subResidentId}) : super(key: key);

  @override
  State<EditSubResidentPage> createState() => _EditSubResidentPageState();
}

class _EditSubResidentPageState extends State<EditSubResidentPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _estateEntryAccess = false;
  bool _generateVisitorQR = true;
  bool _viewVisitorActivity = false;
  bool _manageBeneficiaryVisitors = false;
  bool _unlimitedQRLimit = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
          'Edit',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.background,
                          child: const Icon(Icons.person, size: 30, color: AppColors.textHint),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lawal Rahman',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text(
                                    'Relationship: ',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Brother',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text(
                                    'Status: ',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Active',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.textSecondary,
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: 'Permission'),
                        Tab(text: 'Activity Logs'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tab Content
                  SizedBox(
                    height: 600,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildPermissionTab(),
                        _buildActivityLogsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Save Button
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
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Permissions saved successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Permissions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildToggleItem(
            title: 'Estate Entry Access',
            subtitle: 'Allows personal QR entry',
            value: _estateEntryAccess,
            onChanged: (value) {
              setState(() {
                _estateEntryAccess = value;
              });
            },
          ),
          _buildToggleItem(
            title: 'Generate Visitor QR',
            subtitle: 'Allows visitor access creation',
            value: _generateVisitorQR,
            onChanged: (value) {
              setState(() {
                _generateVisitorQR = value;
              });
            },
          ),
          _buildToggleItem(
            title: 'View Visitor Activity',
            subtitle: 'Allows personal QR entry',
            value: _viewVisitorActivity,
            onChanged: (value) {
              setState(() {
                _viewVisitorActivity = value;
              });
            },
          ),
          _buildToggleItem(
            title: 'Manage Beneficiary Visitors',
            subtitle: 'Allows personal QR entry',
            value: _manageBeneficiaryVisitors,
            onChanged: (value) {
              setState(() {
                _manageBeneficiaryVisitors = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // QR Limits
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'QR Limits',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildLimitRow('Max QRs per day:', '20 mins'),
                const Divider(height: 1, color: AppColors.divider),
                _buildLimitRow('Max active visitors:', '20 mins'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visitor QR Limits
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Visitor QR Limits',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Control how many visitor passes this sub-resident can create',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                _buildLimitRow('Daily QR Limit:', '20 mins', showToggle: true, toggleValue: _unlimitedQRLimit, onToggleChanged: (value) {
                  setState(() {
                    _unlimitedQRLimit = value;
                  });
                }, toggleLabel: '(Unlimited optional)'),
                const Divider(height: 1, color: AppColors.divider),
                _buildLimitRow('Concurrent Active Visitors:', '20 mins'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLogsTab() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildActivityLogItem(
          title: 'QR Generated',
          time: '2:15pm',
          outcome: 'Success',
        ),
        _buildActivityLogItem(
          title: 'Visitor QR Generated',
          time: '2:15pm',
          outcome: 'Success',
        ),
        _buildActivityLogItem(
          title: 'QR Generated',
          time: '2:15pm',
          outcome: 'Success',
        ),
        _buildActivityLogItem(
          title: 'QR Generated',
          time: '2:15pm',
          outcome: 'Success',
        ),
        _buildActivityLogItem(
          title: 'QR Generated',
          time: '2:15pm',
          outcome: 'Success',
        ),
      ],
    );
  }

  Widget _buildToggleItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLimitRow(String label, String value, {bool showToggle = false, bool toggleValue = false, ValueChanged<bool>? onToggleChanged, String? toggleLabel}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
                if (toggleLabel != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    toggleLabel,
                    style: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showToggle) ...[
            Switch(
              value: toggleValue,
              onChanged: onToggleChanged,
              activeColor: AppColors.primary,
            ),
            const SizedBox(width: 8),
          ],
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                size: 16,
                color: AppColors.textHint,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLogItem({
    required String title,
    required String time,
    required String outcome,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
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
                          'Time: ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Outcome: ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          outcome,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'View',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}