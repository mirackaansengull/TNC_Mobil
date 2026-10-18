import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Tasarım referansı: iPhone 11 / orta boy Android (375×812).
class AppDesign {
  static const designWidth = 375.0;
  static const designHeight = 812.0;
}

int responsiveGridCrossAxisCount() {
  final width = 1.sw;
  if (width >= 900) {
    return 4;
  }
  if (width >= 600) {
    return 3;
  }
  return 2;
}

double responsiveGridAspectRatio() {
  final width = 1.sw;
  if (width >= 600) {
    return 0.78;
  }
  return 0.72;
}
