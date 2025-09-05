import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/cart_provider.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _api = ApiService();
  List<Product> trending = [];
  List<Product> products = [];
  String query = "";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    trending = await _api.fetchTrending();
    products = await _api.fetchProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () {}),
        title: const Text("e-FarMar", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (v) async {
                setState(() => query = v);
                products = await _api.fetchProducts(q: v);
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "Enter Product / Service",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.mic_none), onPressed: () {}),
                  ],
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10, runSpacing: 10,
              children: [
                _filterChip("LOCATION", selected: true),
                _filterChip("CROP"),
                _filterChip("PRICE"),
                _filterChip("BESTSELLER"),
              ],
            ),
            const SizedBox(height: 20),
            const Text("↗ This week's trending products",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: trending.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final p = trending[i];
                  return Container(
                    width: 160,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Container(decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(6)))),
                        const SizedBox(height: 6),
                        Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text("₹${p.price.toStringAsFixed(0)}/${p.unit}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => cart.add(p.id),
                            child: const Text("Add"),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text("All Products", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.8),
                itemBuilder: (context, index) {
                  final p = products[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Container(decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)))),
                          const SizedBox(height: 6),
                          Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text("₹${p.price.toStringAsFixed(0)}/${p.unit}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(onPressed: () => cart.add(p.id), child: const Text("Add")),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, {bool selected = false}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? Colors.amber[100] : null,
        side: const BorderSide(color: Colors.black54),
      ),
      onPressed: () {},
      child: Text(label),
    );
  }
}
