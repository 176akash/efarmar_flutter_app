import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CartProvider>().refresh());
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: cart.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final item = cart.items[i];
                      return ListTile(
                        leading: Container(width: 48, height: 48, color: Colors.grey[300]),
                        title: Text(item.product.name),
                        subtitle: Text("Qty: ${item.qty}  •  ₹${item.product.price.toStringAsFixed(0)}/${item.product.unit}"),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("₹${item.total.toStringAsFixed(0)}"),
                            TextButton(onPressed: () => cart.remove(item.id), child: const Text("Remove"))
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Total: ₹${cart.total.toStringAsFixed(0)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: cart.items.isEmpty ? null : () async {
                          // server will also respond with total
                          // but we show local total
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order placed! (demo)")));
                          await context.read<CartProvider>().refresh();
                        },
                        child: const Text("Checkout"),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
