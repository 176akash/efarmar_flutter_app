import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import 'config.dart';

class ApiService {
  final base = Config.baseUrl;

  Future<List<Product>> fetchProducts({String? q, bool? bestseller}) async {
    final uri = Uri.parse("$base/products").replace(queryParameters: {
      if (q != null && q.isNotEmpty) "q": q,
      if (bestseller == true) "bestseller": "true",
    });
    final res = await http.get(uri);
    final data = jsonDecode(res.body) as List;
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> fetchTrending() async {
    final res = await http.get(Uri.parse("$base/trending"));
    final data = jsonDecode(res.body) as List;
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<List<CartItem>> getCart() async {
    final res = await http.get(Uri.parse("$base/cart"));
    final data = jsonDecode(res.body) as List;
    return data.map((e) => CartItem.fromJson(e)).toList();
  }

  Future<void> addToCart(int productId, {int qty = 1}) async {
    await http.post(Uri.parse("$base/cart"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"productId": productId, "qty": qty}));
  }

  Future<void> removeFromCart(int cartId) async {
    await http.delete(Uri.parse("$base/cart/$cartId"));
  }

  Future<double> checkout() async {
    final res = await http.post(Uri.parse("$base/checkout"));
    final data = jsonDecode(res.body);
    return (data['total'] as num).toDouble();
  }

  Future<List<Conversation>> getConversations() async {
    final res = await http.get(Uri.parse("$base/conversations"));
    final data = jsonDecode(res.body) as List;
    return data.map((e) => Conversation.fromJson(e)).toList();
  }

  Future<List<Message>> getMessages(int convId) async {
    final res = await http.get(Uri.parse("$base/messages/$convId"));
    final data = jsonDecode(res.body) as List;
    return data.map((e) => Message.fromJson(e)).toList();
  }

  Future<Message> sendMessage(int convId, String text, {String sender = "You"}) async {
    final res = await http.post(Uri.parse("$base/messages/$convId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"sender": sender, "text": text})
    );
    return Message.fromJson(jsonDecode(res.body));
  }
}
