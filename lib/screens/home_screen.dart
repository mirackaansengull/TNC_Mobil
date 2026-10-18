import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product.dart';
import '../routes/app_routes.dart';
import '../state/cart_scope.dart';
import '../widgets/product_image.dart';
import '../widgets/promo_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.featuredProducts});

  final List<Product> featuredProducts;

  static const String bannerUrl = 'https://wantapi.com/assets/banner.png';

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final featuredCardWidth = 160.w;
    final featuredListHeight = 220.h;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Katalog'),
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
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          PromoBanner(imageUrl: bannerUrl),
          SizedBox(height: 20.h),
          Text(
            'Hafta Sonu Fırsatları',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 8.h),
          Text(
            'Eğitim amaçlı mini katalog uygulamasına hoş geldiniz. '
            'Ürünleri keşfedin, detayları inceleyin ve sepete ekleyin.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.catalog),
              icon: Icon(Icons.grid_view_rounded, size: 20.sp),
              label: Text('Tüm Ürünleri Gör', style: TextStyle(fontSize: 15.sp)),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Öne Çıkan Ürünler',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: featuredListHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: featuredProducts.length,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final product = featuredProducts[index];
                return SizedBox(
                  width: featuredCardWidth,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.productDetail,
                          arguments: product,
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ColoredBox(
                              color: Colors.white,
                              child: ProductImage(
                                imageUrl: product.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
