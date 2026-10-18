import 'package:flutter/material.dart';

/// SnackBar gibi gecikmeli callback'lerde güvenli navigasyon için.
class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static Future<T?>? pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return key.currentState?.pushNamed<T>(routeName, arguments: arguments);
  }
}
