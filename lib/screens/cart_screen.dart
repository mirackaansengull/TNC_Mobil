import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../state/cart_scope.dart';
import '../widgets/product_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);

    return AnimatedBuilder(
      animation: cart,
      builder: (context, _) {
        final items = cart.items;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Sepetim'),
            actions: [
              if (items.isNotEmpty)
                TextButton(
                  onPressed: cart.clear,
                  child: Text('Temizle', style: TextStyle(fontSize: 14.sp)),
                ),
            ],
          ),
          body: items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 72.sp,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Sepetiniz boş',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.all(16.w),
                        itemCount: items.length,
                        separatorBuilder: (context, index) => SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final product = items[index];
                          return Card(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 10.h,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 56.w,
                                    height: 56.w,
                                    child: ProductImage(
                                      imageUrl: product.image,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          product.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          product.category,
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        product.priceLabel,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      IconButton(
                                        tooltip: 'Kaldır',
                                        onPressed: () =>
                                            cart.removeProduct(product),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(
                                          minWidth: 32.w,
                                          minHeight: 32.w,
                                        ),
                                        visualDensity: VisualDensity.compact,
                                        icon: Icon(
                                          Icons.delete_outline,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8.r,
                            offset: Offset(0, -2.h),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Toplam (${cart.itemCount} ürün)',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              Text(
                                '\$${cart.totalPrice.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          SizedBox(
                            height: 48.h,
                            child: FilledButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Sipariş simülasyonu tamamlandı (eğitim amaçlı).',
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Siparişi Simüle Et',
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
