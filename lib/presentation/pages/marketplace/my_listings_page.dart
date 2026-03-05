// lib/presentation/pages/marketplace/my_listings_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({Key? key}) : super(key: key);

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  final TextEditingController _searchController = TextEditingController();

  // Mock data
  final List<Map<String, dynamic>> _listings = [
    {
      'id': '1',
      'title': 'Cloth Laundry',
      'description': 'I Sell Cloth at a very low price at owuchi gate',
      'category': 'Dry Cleaning',
      'status': 'Accepted',
      'image': 'assets/images/house.png',
    },
    {
      'id': '2',
      'title': 'Cloth Laundry',
      'description': 'I Sell Cloth at a very low price at owuchi gate',
      'category': 'Dry Cleaning',
      'status': 'Accepted',
      'image': 'assets/images/house.png',
    },
    {
      'id': '3',
      'title': 'Cloth Laundry',
      'description': 'I Sell Cloth at a very low price at owuchi gate',
      'category': 'Dry Cleaning',
      'status': 'Pending',
      'image': 'assets/images/house.png',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(flexibleSpace: Container(
        color:Colors.white,
      ),
        backgroundColor: Colors.white,
        elevation: 0,centerTitle: false,
        title:   Text(
          'My listing',
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/house.png'),
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for services...',
                hintStyle: GoogleFonts.outfit(
                    color: Color.fromRGBO(156, 163, 175, 1),
                    fontWeight: FontWeight.w400,
                    fontSize: 16
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(156, 163, 175, 1),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(156, 163, 175, 1),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(156, 163, 175, 1),
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                suffixIcon: const Icon(Icons.filter_list, color: AppColors.textHint),
              ),
            ),
          ),

          // Listings
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _listings.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final listing = _listings[index];
                return _buildListingCard(listing);
              },
            ),
          ),

          // Add Listing Button
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
            child: SizedBox(height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/marketplace/add-listing');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Add Listing',
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

  Widget _buildListingCard(Map<String, dynamic> listing) {
    final isAccepted = listing['status'] == 'Accepted';

    return  Container(
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
          // Image with Status Badge
          Stack(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    listing['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 50, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isAccepted ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    listing['status'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                listing['title'],
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ), Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    listing['category'],
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),


          // Category

          const SizedBox(height: 8),

          // Description
          Text(
            listing['description'],
            style: GoogleFonts.outfit(
              fontSize: 14,fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.push('/marketplace/edit-listing', extra: listing);
                  },
                  style: OutlinedButton.styleFrom(backgroundColor: Color.fromRGBO(156, 163, 175, 1),
                    side: BorderSide(color: Color.fromRGBO(156, 163, 175, 1)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Edit',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _showRemoveDialog(listing);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Remove',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(Map<String, dynamic> listing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Remove Listing'),
        content: Text('Are you sure you want to remove "${listing['title']}"?'),
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
                _listings.remove(listing);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Listing removed successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}