import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
  });

  final String imageUrl;
  final BoxFit fit;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        color: Colors.grey.shade500,
        size: 40.sp,
      ),
    );

    if (imageUrl.isEmpty) {
      return ClipRRect(borderRadius: borderRadius, child: placeholder);
    }

    if (imageUrl.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          imageUrl,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => placeholder,
        ),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        imageUrl,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            color: Colors.grey.shade100,
            alignment: Alignment.center,
            child: CircularProgressIndicator(strokeWidth: 2.w),
          );
        },
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }
}
