# 🛍️ Flutter E-Commerce App (Web, Mobile, Desktop)

![Flutter](https://img.shields.io/badge/Made%20With-Flutter-blue?style=for-the-badge&logo=flutter)
![Responsive](https://img.shields.io/badge/UI-Responsive-success?style=for-the-badge)
![State Management](https://img.shields.io/badge/State%20Management-Provider-007acc?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Mobile%20%7C%20Desktop-6c5ce7?style=for-the-badge)

> Proyek ini adalah aplikasi e-commerce sederhana dengan desain premium dan fitur keranjang belanja, dibangun menggunakan Flutter. Cocok untuk pemula hingga menengah!

---

## 📦 Dependencies yang Digunakan

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  http: ^1.1.0
  collection: ^1.18.0
  cupertino_icons: ^1.0.2
```

---

## 🧱 Struktur Folder

Struktur folder utama dalam proyek:

```
lib/
├── main.dart                 # Titik masuk aplikasi dan routing
├── models/                  # Menyimpan model data
│   ├── product.dart         # Model data produk
│   └── cart_item.dart       # Model data item dalam keranjang
├── page/                    # Halaman-halaman antarmuka pengguna
│   ├── login_page.dart      # Halaman login pengguna
│   ├── product_list_page.dart # Daftar produk dari API
│   ├── product_detail_page.dart # Halaman detail produk
│   └── cart_page.dart       # Halaman keranjang belanja
├── providers/               # State management
│   ├── auth_provider.dart   # Manajemen autentikasi login
│   └── cart_provider.dart   # Manajemen data keranjang belanja
```

---

## 📄 Kode dan Penjelasan File

### `lib/providers/auth_provider.dart`
Provider ini digunakan untuk autentikasi login sederhana.

```dart
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void login(String username, String password) {
    if (username == 'user' && password == 'password') {
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
```

### `lib/providers/cart_provider.dart`
Provider ini digunakan untuk mengelola data keranjang belanja.

```dart
import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  void addToCart(CartItem item) {
    final index = _items.indexWhere((e) => e.productId == item.productId);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
```

### `lib/models/product.dart`
Model data untuk produk yang digunakan dalam daftar dan detail produk.

```dart
class Product {
  final int id;
  final String title;
  final String description;
  final String thumbnail;
  final double price;
  final String category;
  final double rating;
  final String? brand;
  final double discountPercentage;
  final int stock;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.price,
    required this.category,
    required this.rating,
    this.brand,
    required this.discountPercentage,
    required this.stock,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      price: (json['price'] as num).toDouble(),
      category: json['category'],
      rating: (json['rating'] as num).toDouble(),
      brand: json['brand'],
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      stock: json['stock'],
      images: List<String>.from(json['images']),
    );
  }
}
```

### `lib/models/cart_item.dart`
Model data untuk item yang ditambahkan ke keranjang.

```dart
class CartItem {
  final int productId;
  final String title;
  final double price;
  final String thumbnail;
  final String? brand;
  final String? category;
  int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.thumbnail,
    this.brand,
    this.category,
    this.quantity = 1,
  });
}
```

### `lib/main.dart`
Titik masuk aplikasi Flutter dan pengaturan routing serta provider.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'page/login_page.dart';
import 'page/product_list_page.dart';
import 'page/product_detail_page.dart';
import 'page/cart_page.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/products': (context) => const ProductListPage(),
        '/cart': (context) => const CartPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/product-detail') {
          final product = settings.arguments as Product;
          return MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          );
        }
        return null;
      },
    );
  }
}
```
### `lib/page/product_list_page.dart`
Menampilkan daftar produk dari API dan tombol tambah ke keranjang.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final data = await ApiService.fetchProducts();
    setState(() => products = data);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Produk')),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (_, i) {
          final p = products[i];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              '/product-detail',
              arguments: p,
            ),
            child: Card(
              child: Column(
                children: [
                  Expanded(child: Image.network(p.thumbnail)),
                  Text(p.title),
                  Text('Rp ${p.price}'),
                  TextButton(
                    onPressed: () => cart.addToCart(CartItem(
                      productId: p.id,
                      title: p.title,
                      price: p.price,
                      thumbnail: p.thumbnail,
                      brand: p.brand,
                      category: p.category,
                    )),
                    child: const Text('Tambah ke Keranjang'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
---
### `lib/page/product_detail_page.dart`
Menampilkan detail produk secara lengkap dan tombol beli.

```dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(product.thumbnail, height: 200),
            const SizedBox(height: 10),
            Text(product.description),
            const SizedBox(height: 10),
            Text('Rp ${product.price}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                cart.addToCart(CartItem(
                  productId: product.id,
                  title: product.title,
                  price: product.price,
                  thumbnail: product.thumbnail,
                  brand: product.brand,
                  category: product.category,
                ));
              },
              child: const Text('Beli Sekarang'),
            )
          ],
        ),
      ),
    );
  }
}
```

### `lib/page/cart_page.dart`
Menampilkan semua item di keranjang dan total harga.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Keranjang kosong'))
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (_, i) {
                final item = cart.items[i];
                return ListTile(
                  leading: Image.network(item.thumbnail, width: 50),
                  title: Text(item.title),
                  subtitle: Text('Rp ${item.price} x ${item.quantity}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => cart.removeItem(item.productId),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total: Rp ${cart.totalPrice.toStringAsFixed(0)}'),
            ElevatedButton(
              onPressed: cart.clearCart,
              child: const Text('Checkout'),
            )
          ],
        ),
      ),
    );
  }
}
```

---
