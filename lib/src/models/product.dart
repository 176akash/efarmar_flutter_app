class Product {
  final int id;
  final String name;
  final double price;
  final String unit;
  final bool bestseller;

  Product({required this.id, required this.name, required this.price, required this.unit, required this.bestseller});

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'],
    name: j['name'],
    price: (j['price'] as num).toDouble(),
    unit: j['unit'] ?? '',
    bestseller: j['bestseller'] ?? false,
  );
}
