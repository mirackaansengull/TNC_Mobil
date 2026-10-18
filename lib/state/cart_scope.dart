import 'package:flutter/material.dart';

import 'cart_state.dart';

class CartScope extends InheritedNotifier<CartState> {
  const CartScope({
    super.key,
    required CartState cart,
    required super.child,
  }) : super(notifier: cart);

  static CartState of(BuildContext context, {bool listen = true}) {
    final scope = listen
        ? context.dependOnInheritedWidgetOfExactType<CartScope>()
        : context.getInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope bulunamadı');
    return scope!.notifier!;
  }
}
