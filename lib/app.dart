import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/responsive.dart';
import 'data/product_repository.dart';
import 'models/product.dart';
import 'routes/app_navigator.dart';
import 'routes/app_routes.dart';
import 'screens/cart_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'state/cart_scope.dart';
import 'state/cart_state.dart';

class MiniCatalogApp extends StatefulWidget {
  const MiniCatalogApp({super.key});

  @override
  State<MiniCatalogApp> createState() => _MiniCatalogAppState();
}

class _MiniCatalogAppState extends State<MiniCatalogApp> {
  final CartState _cart = CartState();
  final ProductRepository _repository = ProductRepository();

  List<Product> _products = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _repository.loadProducts();
      if (!mounted) {
        return;
      }
      setState(() {
        _products = products;
        _isLoading = false;
        _errorMessage = products.isEmpty ? 'Ürün listesi boş.' : null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cart.dispose();
  }

  Widget _buildScreen(RouteSettings settings) {
    if (_isLoading) {
      return const _LoadingScreen();
    }
    if (_errorMessage != null) {
      return _ErrorScreen(
        message: _errorMessage!,
        onRetry: () {
          setState(() {
            _isLoading = true;
            _errorMessage = null;
          });
          _loadProducts();
        },
      );
    }

    switch (settings.name) {
      case AppRoutes.home:
        return HomeScreen(featuredProducts: _products.take(5).toList());
      case AppRoutes.catalog:
        return CatalogScreen(products: _products);
      case AppRoutes.productDetail:
        final product = settings.arguments;
        if (product is! Product) {
          return const _ErrorScreen(message: 'Ürün bilgisi bulunamadı.');
        }
        return ProductDetailScreen(product: product);
      case AppRoutes.cart:
        return const CartScreen();
      default:
        return const _ErrorScreen(message: 'Sayfa bulunamadı.');
    }
  }

  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1565C0),
        secondary: const Color(0xFFEF6C00),
      ),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 16.sp),
        bodyMedium: TextStyle(fontSize: 14.sp),
        bodySmall: TextStyle(fontSize: 12.sp),
        labelLarge: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(AppDesign.designWidth, AppDesign.designHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return CartScope(
          cart: _cart,
          child: MaterialApp(
            navigatorKey: AppNavigator.key,
            title: 'Mini Katalog',
            debugShowCheckedModeBanner: false,
            theme: _buildTheme(),
            initialRoute: AppRoutes.home,
            onGenerateRoute: (settings) {
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (context) => _buildScreen(settings),
              );
            },
          ),
        );
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text(
              'Ürünler API\'den yükleniyor...',
              style: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hata')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp),
              ),
              if (onRetry != null) ...[
                SizedBox(height: 16.h),
                FilledButton(
                  onPressed: onRetry,
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
