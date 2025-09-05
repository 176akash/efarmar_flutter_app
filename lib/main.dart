import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/messages_screen.dart';
import 'src/screens/cart_screen.dart';
import 'src/screens/post_screen.dart';
import 'src/services/cart_provider.dart';

void main() {
  runApp(const EFarMarApp());
}

class EFarMarApp extends StatelessWidget {
  const EFarMarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal),
        home: const RootNav(),
      ),
    );
  }
}

class RootNav extends StatefulWidget {
  const RootNav({super.key});

  @override
  State<RootNav> createState() => _RootNavState();
}

class _RootNavState extends State<RootNav> {
  int _index = 0;
  final _screens = const [
    HomeScreen(),
    MessagesScreen(),
    PostScreen(),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.black54,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: "Post"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        ],
      ),
    );
  }
}
