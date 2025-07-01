import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'page/login_page.dart';
import 'page/cart_page.dart';
import 'page/product_list_page.dart';
import 'page/product_detail_page.dart';
import 'models/product.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyStore App',
      theme: ThemeData.light(),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/product-detail') {
          final product = settings.arguments as Product?;
          if (product == null) {
            return MaterialPageRoute(
              builder:
                  (context) => Scaffold(
                    appBar: AppBar(title: const Text('Error')),
                    body: const Center(child: Text('Produk tidak ditemukan!')),
                  ),
            );
          }
          return MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          );
        }
        return null;
      },
      routes: {
        '/': (context) => LoginPage(),
        '/products': (context) => ProductListPage(),
        '/cart': (context) => CartPage(),
      },
    );
  }
}