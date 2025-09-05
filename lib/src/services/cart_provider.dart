import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import 'api_service.dart';

class CartProvider extends ChangeNotifier {
  final _api = ApiService();
  List<CartItem> items = [];
  bool loading = false;

  Future<void> refresh() async {
    loading = true;
    notifyListeners();
    items = await _api.getCart();
    loading = false;
    notifyListeners();
  }

  Future<void> add(int productId) async {
    await _api.addToCart(productId);
    await refresh();
  }

  Future<void> remove(int cartId) async {
    await _api.removeFromCart(cartId);
    await refresh();
  }

  double get total => items.fold(0, (sum, i) => sum + i.total);
}
