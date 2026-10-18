import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product.dart';
import '../routes/app_navigator.dart';
import '../routes/app_routes.dart';
import '../state/cart_scope.dart';
import '../widgets/product_image.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final inCart = cart.contains(product);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Detayı'),
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
          AspectRatio(
            aspectRatio: 1.2,
            child: ColoredBox(
              color: Colors.white,
              child: ProductImage(
                imageUrl: product.image,
                fit: BoxFit.contain,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (product.tagline.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              product.tagline,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
          SizedBox(height: 8.h),
          Row(
            children: [
              Chip(
                label: Text(
                  product.category,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  product.priceLabel,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'Açıklama',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.all(16.w),
        child: SizedBox(
          height: 48.h,
          child: FilledButton.icon(
            onPressed: inCart
                ? null
                : () {
                    cart.addProduct(product);
                    final messenger = ScaffoldMessenger.of(context);
                    messenger.hideCurrentSnackBar();
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text('${product.name} sepete eklendi'),
                        action: SnackBarAction(
                          label: 'Sepete Git',
                          onPressed: () {
                            AppNavigator.pushNamed(AppRoutes.cart);
                          },
                        ),
                      ),
                    );
                  },
            icon: Icon(inCart ? Icons.check : Icons.add_shopping_cart, size: 20.sp),
            label: Text(
              inCart ? 'Sepette' : 'Sepete Ekle',
              style: TextStyle(fontSize: 15.sp),
            ),
          ),
        ),
      ),
    );
  }
}
