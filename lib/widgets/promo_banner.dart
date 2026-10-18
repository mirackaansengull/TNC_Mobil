import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Banner görseli genişliğe göre ölçeklenir; metin kırpılmasını önler.
class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: ColoredBox(
        color: const Color(0xFFF3F4F6),
        child: Image.network(
          imageUrl,
          width: double.infinity,
          fit: BoxFit.fitWidth,
          loadingBuilder: (context, child, progress) {
            if (progress == null) {
              return child;
            }
            return SizedBox(
              height: 120.h,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return SizedBox(
              height: 120.h,
              child: Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 40.sp,
                  color: Colors.grey.shade500,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
