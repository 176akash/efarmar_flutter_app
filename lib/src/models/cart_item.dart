import 'product.dart';

class CartItem {
  final int id;
  final Product product;
  int qty;

  CartItem({required this.id, required this.product, required this.qty});

  factory CartItem.fromJson(Map<String, dynamic> j) => CartItem(
    id: j['id'],
    product: Product.fromJson(j['product']),
    qty: j['qty'],
  );

  double get total => product.price * qty;
}
