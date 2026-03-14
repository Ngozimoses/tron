// lib/presentation/pages/settings/sub_residents_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class SubResidentsPage extends StatefulWidget {
  const SubResidentsPage({Key? key}) : super(key: key);

  @override
  State<SubResidentsPage> createState() => _SubResidentsPageState();
}

class _SubResidentsPageState extends State<SubResidentsPage> {
  String _selectedFilter = 'All';

  // Mock data
  final List<Map<String, dynamic>> _subResidents = [
    {
      'id': '1',
      'name': 'Rahman',
      'role': 'Brother',
      'status': 'Active',
      'avatar': null,
    },
    {
      'id': '2',
      'name': 'Rahman',
      'role': 'Brother',
      'status': 'Active',
      'avatar': null,
    },
    {
      'id': '3',
      'name': 'Rahman',
      'role': 'Brother',
      'status': 'Deactivated',
      'avatar': null,
    },
    {
      'id': '4',
      'name': 'Rahman',
      'role': 'Brother',
      'status': 'Pending',
      'avatar': null,
    },
  ];

  List<Map<String, dynamic>> get _filteredSubResidents {
    if (_selectedFilter == 'All') {
      return _subResidents;
    }
    return _subResidents.where((sr) => sr['status'] == _selectedFilter).toList();
  }

  int _getCount(String status) {
    if (status == 'All') return _subResidents.length;
    return _subResidents.where((sr) => sr['status'] == status).length;
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
        centerTitle: false,
        title:   Text(
          'Sub-Residents',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: GestureDetector(
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
      body: Column(
        children: [
   SizedBox(height: 20,),
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
                  _buildFilterTab('Deactivated', _getCount('Deactivated')),
                  const SizedBox(width: 8),
                  _buildFilterTab('Pending', _getCount('Pending')),
                ],
              ),
            ),
          ),

          // Sub-Residents List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredSubResidents.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final subResident = _filteredSubResidents[index];
                return _buildSubResidentCard(subResident);
              },
            ),
          ),

          // Add Sub-Resident Button
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
            child: SizedBox(height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/add-sub-resident');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Add Sub-Resident',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
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

  Widget _buildSubResidentCard(Map<String, dynamic> subResident) {
    final isActive = subResident['status'] == 'Active';
    final isDeactivated = subResident['status'] == 'Deactivated';
    final isPending = subResident['status'] == 'Pending';

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromRGBO(156, 163, 175, 0.2), width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(
            subResident['name'],
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          // Role
          Row(
            children: [
              Text(
                'Role:',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color:Color.fromRGBO(11, 11, 11, 0.7),
                ),
              ),
              const Spacer(),
              Text(
                subResident['role'],
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color:Color.fromRGBO(11, 11, 11, 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Status
          Row(
            children: [
              Text(
                'Status:',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color:Color.fromRGBO(11, 11, 11, 0.7),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(subResident['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  subResident['status'],
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(subResident['status']),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isActive || isPending) ...[
                SizedBox(height: 36,width: 130,
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/settings/edit-sub-resident', extra: subResident);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.transparent, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Edit',
                      style: GoogleFonts.outfit(
                        color:Colors.blue,      fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(height: 36,width: 130,
                  child: ElevatedButton(
                    onPressed: () {
                      _showDeactivateDialog(subResident);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isPending ? 'Cancel' : 'Deactivate',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
              if (isDeactivated) ...[
                SizedBox(height: 36,width: 130,
                  child: OutlinedButton(
                    onPressed: () {
                      _showDeleteDialog(subResident);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: GoogleFonts.outfit(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      _showReactivateDialog(subResident);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 10 ,horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Reactivate Invite',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'deactivated':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showDeactivateDialog(Map<String, dynamic> subResident) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Deactivate Sub-Resident'),
        content: Text('Are you sure you want to deactivate ${subResident['name']}?'),
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
              setState(() {
                subResident['status'] = 'Deactivated';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sub-resident deactivated'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> subResident) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Sub-Resident'),
        content: Text('Are you sure you want to delete ${subResident['name']}?'),
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
              setState(() {
                _subResidents.remove(subResident);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sub-resident deleted'),
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

  void _showReactivateDialog(Map<String, dynamic> subResident) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Reactivate Invite'),
        content: Text('Are you sure you want to reactivate the invite for ${subResident['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                subResident['status'] = 'Pending';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invite reactivated'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Reactivate'),
          ),
        ],
      ),
    );
  }
}