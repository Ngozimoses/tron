// lib/presentation/pages/marketplace/marketplace_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/svg_icons.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({Key? key}) : super(key: key);

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.checkroom, 'name': 'Cloth', 'color': Colors.orange},
    {'icon': Icons.store, 'name': 'Store', 'color': Colors.blue},
    {'icon': Icons.restaurant, 'name': 'Food', 'color': Colors.green},
    {'icon': Icons.lightbulb, 'name': 'Electricity', 'color': Colors.yellow[700]!},
    {'icon': Icons.more_horiz, 'name': 'More', 'color': Colors.purple},
  ];

  final List<Map<String, dynamic>> _featuredListings = [
    {
      'id': 1,
      'provider': 'Perez',
      'service': 'Dry Cleaning',
      'rating': 4.5,
      'image': 'assets/images/house.png',
      'status': 'Active',
      'category': 'Cleaning',
    },
    {
      'id': 2,
      'provider': 'Perez',
      'service': 'Food',
      'rating': 4.5,
      'image': 'assets/images/house.png',
      'status': 'Active',
      'category': 'Food',
    },
    {
      'id': 3,
      'provider': 'Perez',
      'service': 'Dry Cleaning',
      'rating': 4.5,
      'image': 'assets/images/house.png',
      'status': 'Active',
      'category': 'Cleaning',
    },
    {
      'id': 4,
      'provider': 'Perez',
      'service': 'Food',
      'rating': 4.5,
      'image': 'assets/images/house.png',
      'status': 'Active',
      'category': 'Food',
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
      backgroundColor:Colors.white,
      appBar: AppBar(flexibleSpace: Container(
        color:Colors.white,
      ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(6),
              ),
              child: SvgIcons.store01(size: 24),
            ),
            const SizedBox(width: 8),
              Text(
              'Market Place',
              style: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage('assets/images/profile.jpg'),
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 16),

            // Promotional Banner
            _buildPromoBanner(),
            const SizedBox(height: 24),

            // Market Listing Categories
            const Text(
              'Market Listing',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildCategories(),


            // Featured Listings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Featured Listings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'See all',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildFeaturedListings(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search for services...',

        prefixIcon:      Padding(
          padding: const EdgeInsets.all(12),
          child: SvgIcons.search(size: 20),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            if (_searchController.text.isNotEmpty) {
              context.push('/marketplace/search?query=${_searchController.text}');
            }
          },
          child:  Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
                decoration: BoxDecoration( borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1
                  ,color:Color.fromRGBO(156, 163, 175, 1)),color: Color.fromRGBO(209, 213, 219, 0.2)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgIcons.filter(size: 14),
                )),
          ),
        ),
        hintStyle: GoogleFonts.outfit(color: Color.fromRGBO(156, 163, 175, 1),fontWeight: FontWeight.w400,fontSize: 16),

        // Add border with black color and 12 radius
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromRGBO(156, 163, 175, 1),
            width: 1, // You can adjust the width as needed
          ),
        ),

        // You might also want to define borders for different states
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
            width: 1, // Slightly thicker when focused for better UX
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red, // Keep error border red for visibility
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

        // Add some content padding for better appearance
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          context.push('/marketplace/search?query=$value');
        }
      },
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black87,
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, size: 16, color: Colors.black),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Hammed',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const SizedBox(
                  width: 200,
                  child: Text(
                    'Get Lost in the right in place',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(100),
              ),
              child: Image.asset(
                'assets/images/cleaning_service.jpg',
                height: 180,
                width: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    width: 180,
                    color: Colors.grey[300],
                    child: const Icon(Icons.cleaning_services, size: 60, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 30,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 30,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = _categories[index];
          return GestureDetector(
            onTap: () {
              context.push('/marketplace/search?query=${category['name']}');
            },
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: (category['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.91),
                    border: Border.all(color: category['color'] as Color),
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: category['color'] as Color,
                    size: 19,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedListings() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _featuredListings.length,
      itemBuilder: (context, index) {
        final item = _featuredListings[index];
        return _buildListingCard(item);
      },
    );
  }

  Widget _buildListingCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        context.push('/marketplace/service/${item['id']}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  item['image'] as String,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 40, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.handshake, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item['provider'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.star, size: 14, color: Colors.orange),
                      const SizedBox(width: 2),
                      Text(
                        item['rating'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['service'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item['status'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}