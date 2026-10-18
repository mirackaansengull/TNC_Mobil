import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/responsive.dart';
import '../models/product.dart';
import '../routes/app_routes.dart';
import '../state/cart_scope.dart';
import '../widgets/product_grid_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key, required this.products});

  final List<Product> products;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Tümü';

  List<String> get _categories {
    final values = widget.products.map((p) => p.category).toSet().toList()
      ..sort();
    return ['Tümü', ...values];
  }

  List<Product> get _filteredProducts {
    return widget.products.where((product) {
      final matchesCategory =
          _selectedCategory == 'Tümü' || product.category == _selectedCategory;
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final filtered = _filteredProducts;
    final crossAxisCount = responsiveGridCrossAxisCount();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Kataloğu'),
        actions: [
          IconButton(
            tooltip: 'Sepet',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
            icon: Badge(
              isLabelVisible: cart.itemCount > 0,
              label: Text(
                '${cart.itemCount}',
                style: TextStyle(fontSize: 10.sp),
              ),
              child: Icon(Icons.shopping_cart_outlined, size: 24.sp),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: TextField(
              style: TextStyle(fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: 'Ürün veya kategori ara...',
                hintStyle: TextStyle(fontSize: 14.sp),
                prefixIcon: Icon(Icons.search, size: 22.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12.h,
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          SizedBox(
            height: 44.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final selected = category == _selectedCategory;
                return FilterChip(
                  label: Text(
                    category,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  selected: selected,
                  onSelected: (_) {
                    setState(() => _selectedCategory = category);
                  },
                );
              },
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'Aramanızla eşleşen ürün bulunamadı.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(16.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: responsiveGridAspectRatio(),
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      return ProductGridCard(
                        product: product,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.productDetail,
                            arguments: product,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
