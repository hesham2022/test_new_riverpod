import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_new_riverpod/core/models/cart_model.dart';
import 'package:test_new_riverpod/core/services/quote_service.dart';
import 'package:test_new_riverpod/providers/quote_provider.dart';

enum QuantityOpeartion { increase, decrease }
final cartProvider = StateNotifierProvider<CartProvider, CartState>(
    (ref) => CartProvider(ref.watch(quoteServiceProvider))..getCart());

class CartProvider extends StateNotifier<CartState> {
  final QuoteService quoteService;
  CartProvider(this.quoteService) : super(CartState.loading());

  Future<void> getCart() async {
    state = CartState.loading();
    state = CartState.loaded(await quoteService.getQuotes());
  }

  void changeCart(String id, BuildContext context, String url,
      QuantityOpeartion quantityOpeartion) async {
    if (quantityOpeartion == QuantityOpeartion.increase)
      state = (state as Loaded)
        ..cart
            .products
            .where((element) => element.productId == int.parse(id))
            .first
            .increaseQuantity();
    else
      state = (state as Loaded)
        ..cart
            .products
            .where((element) => element.productId == int.parse(id))
            .first
            .decreaseQuantity();
    await quoteService.changeProduct(id, context, url);
  }
}

abstract class CartState {
  CartState();
  factory CartState.loading() = Loading;
  factory CartState.loaded(Cart cart) = Loaded;
  factory CartState.error(String error) = CartError;
}

class Loading extends CartState {}

class Loaded extends CartState {
  final Cart cart;

  Loaded(this.cart);
}

class CartError extends CartState {
  final String error;

  CartError(this.error);
}
