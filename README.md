# Tutorial Lengkap: Membangun Aplikasi Website E-commerce dengan Flutter (Tampilan Premium & Fungsionalitas Keranjang)

Tutorial ini akan memandu Anda langkah demi langkah dalam membuat aplikasi e-commerce dasar menggunakan Flutter, yang dapat berjalan di web, mobile, dan desktop. Kita akan fokus pada tampilan yang modern dan profesional, serta implementasi keranjang belanja.

**Target Pembaca:** Developer Flutter tingkat pemula hingga menengah.

**Apa yang Akan Anda Pelajari:**
* Inisialisasi proyek Flutter untuk berbagai platform.
* Menggunakan widget dasar untuk tata letak UI.
* Mengambil data produk dari API eksternal (dummyjson.com).
* Manajemen state dengan Provider.
* Implementasi keranjang belanja.
* Desain UI modern untuk daftar produk (grid) dan halaman keranjang.
* Menangani navigasi antar halaman.

**Persyaratan:**
* Flutter SDK terinstal dan terkonfigurasi.
* IDE (Visual Studio Code atau Android Studio) dengan plugin Flutter/Dart.
* Koneksi internet.
* Pemahaman dasar tentang Dart dan Flutter.

---

### **Bagian 1: Inisialisasi Proyek Flutter**

1.  **Buat Proyek Flutter Baru:**
    Buka terminal atau command prompt dan jalankan perintah berikut:
    ```bash
    flutter create my_ecommerce_app
    cd my_ecommerce_app
    ```
    *Ganti `my_ecommerce_app` dengan nama proyek Anda.*

2.  **Aktifkan Dukungan Web (Jika Belum Otomatis):**
    Untuk memastikan proyek Anda bisa berjalan di web, jalankan:
    ```bash
    flutter clean
    flutter create . --platforms=web
    ```
    *Ini akan memastikan semua konfigurasi web terinstal.*

3.  **Tambahkan Dependencies:**
    Buka file `pubspec.yaml` dan tambahkan dependencies berikut di bawah `dependencies:`:
    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      provider: ^6.0.5
      http: ^1.1.0
      collection: ^1.18.0
      cupertino_icons: ^1.0.2
    ```
    Simpan file `pubspec.yaml` dan jalankan di terminal:
    ```bash
    flutter pub get
    ```

### **Bagian 2: Struktur Proyek dan Model Data**

Kita akan mengatur folder proyek untuk menjaga kebersihan kode.

1.  **Buat Struktur Folder:**
    Berikut adalah struktur folder proyek Flutter Anda secara detail, yang digunakan untuk mengorganisir kode:

    ```
    your_project_root/
    ├── .vscode/                   # Konfigurasi Visual Studio Code
    ├── android/                   # Proyek spesifik Android
    ├── build/                     # Direktori output hasil build aplikasi
    ├── ios/                       # Proyek spesifik iOS
    ├── lib/                       # Source code utama aplikasi Flutter Anda
    │   ├── models/                # -> Definisi data model aplikasi
    │   │   ├── product.dart       #    (Struktur data produk dari API)
    │   │   └── cart_item.dart     #    (Struktur data item di keranjang belanja)
    │   ├── page/                  # -> Halaman-halaman UI utama aplikasi
    │   │   ├── login_page.dart
    │   │   ├── product_list_page.dart
    │   │   ├── product_detail_page.dart
    │   │   └── cart_page.dart
    │   ├── providers/             # -> Kelas-kelas Provider untuk manajemen state
    │   │   ├── auth_provider.dart #    (Manajemen state autentikasi pengguna)
    │   │   └── cart_provider.dart #    (Manajemen state keranjang belanja)
    │   ├── services/              # -> Kelas-kelas untuk layanan eksternal (API, database, dll.)
    │   │   └── api_service.dart   #    (Contoh layanan untuk interaksi API)
    │   └── main.dart              # -> Titik masuk utama aplikasi, konfigurasi Provider, dan routing
    ├── linux/                     # Proyek spesifik Linux
    ├── macos/                     # Proyek spesifik macOS
    ├── test/                      # File untuk unit dan widget testing
    ├── web/                       # Konfigurasi dan output untuk aplikasi web
    ├── windows/                   # Proyek spesifik Windows
    ├── .gitignore                 # File yang diabaikan oleh Git saat commit
    ├── .metadata                  # Metadata internal proyek Flutter
    ├── analysis_options.yaml      # Aturan linter dan analisis kode Dart
    ├── devtools_options.yaml      # Opsi konfigurasi DevTools
    ├── flutter_01.log             # Log internal Flutter
    ├── pubspec.lock               # Catatan detail dependensi setelah `flutter pub get`
    ├── pubspec.yaml               # File konfigurasi utama proyek, dependensi, dan aset
    └── README.md                  # Dokumentasi proyek ini (file yang sedang Anda baca)
    ```

2.  **Buat Model Produk (`lib/models/product.dart`):**
    Model ini merepresentasikan struktur data produk yang akan kita ambil dari API.
    ```dart
    // lib/models/product.dart
    import 'package:flutter/foundation.dart';

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
          id: json['id'] as int,
          title: json['title'] as String,
          description: json['description'] as String? ?? 'No description available',
          thumbnail: json['thumbnail'] as String,
          price: (json['price'] as num).toDouble(),
          category: json['category'] as String,
          rating: (json['rating'] as num).toDouble(),
          brand: json['brand'] as String?,
          discountPercentage: (json['discountPercentage'] as num).toDouble(),
          stock: json['stock'] as int,
          images: (json['images'] as List<dynamic>?)
                  ?.map((x) => x.toString())
                  .toList() ??
              [],
        );
      }
    }
    ```

3.  **Buat Model Item Keranjang (`lib/models/cart_item.dart`):**
    Model ini merepresentasikan item yang ditambahkan ke keranjang.
    ```dart
    // lib/models/cart_item.dart
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

### **Bagian 3: Manajemen State (Provider)**

Kita akan menggunakan Provider untuk mengelola state keranjang belanja.

1.  **Buat Provider Keranjang (`lib/providers/cart_provider.dart`):**
    ```dart
    // lib/providers/cart_provider.dart
    import 'package:flutter/material.dart';
    import 'package:collection/collection.dart';
    import '../models/cart_item.dart';

    class CartProvider extends ChangeNotifier {
      final List<CartItem> _items = [];

      List<CartItem> get items => List.unmodifiable(_items);

      int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

      double get totalPrice => _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

      void addToCart(int productId, String title, double price, String thumbnail, String? brand, String? category) {
        final existingItem = _items.firstWhereOrNull((item) => item.productId == productId);

        if (existingItem != null) {
          existingItem.quantity++;
        } else {
          _items.add(CartItem(
            productId: productId,
            title: title,
            price: price,
            thumbnail: thumbnail,
            brand: brand,
            category: category,
          ));
        }
        notifyListeners();
      }

      void incrementQuantity(int productId) {
        final item = _items.firstWhereOrNull((item) => item.productId == productId);
        if (item != null) {
          item.quantity++;
          notifyListeners();
        }
      }

      void decrementQuantity(int productId) {
        final item = _items.firstWhereOrNull((item) => item.productId == productId);
        if (item != null) {
          if (item.quantity > 1) {
            item.quantity--;
          } else {
            _items.remove(item);
          }
          notifyListeners();
        }
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

2.  **Buat Provider Autentikasi (`lib/providers/auth_provider.dart`):**
    ```dart
    // lib/providers/auth_provider.dart
    import 'package:flutter/material.dart';

    class AuthProvider extends ChangeNotifier {
      bool _isLoggedIn = false;

      bool get isLoggedIn => _isLoggedIn;

      void login(String username, String password) {
        // Implementasi login sederhana
        if (username == 'user' && password == 'password') {
          _isLoggedIn = true;
          notifyListeners();
        } else {
          _isLoggedIn = false;
        }
      }

      void logout() {
        _isLoggedIn = false;
        notifyListeners();
      }
    }
    ```

### **Bagian 4: Halaman-Halaman Aplikasi**

Kita akan membuat halaman Login, Daftar Produk, Detail Produk, dan Keranjang.

1.  **Halaman Login (`lib/page/login_page.dart`):**
    ```dart
    // lib/page/login_page.dart
    import 'package:flutter/material.dart';
    import 'package:provider/provider.dart';
    import '../providers/auth_provider.dart';

    class LoginPage extends StatefulWidget {
      const LoginPage({super.key});

      @override
      State<LoginPage> createState() => _LoginPageState();
    }

    class _LoginPageState extends State<LoginPage> {
      final TextEditingController _usernameController = TextEditingController();
      final TextEditingController _passwordController = TextEditingController();

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.grey[850]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Selamat Datang',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.person, color: Colors.amberAccent),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.lock, color: Colors.amberAccent),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        authProvider.login(_usernameController.text, _passwordController.text);
                        if (authProvider.isLoggedIn) {
                          Navigator.pushReplacementNamed(context, '/products');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Username atau password salah!')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        shadowColor: Colors.amber.withOpacity(0.5),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }
    ```

2.  **Halaman Daftar Produk (`lib/page/product_list_page.dart`):**
    Ini adalah halaman inti dengan tampilan grid produk dan desain yang sudah kita poles.
    ```dart
    // lib/page/product_list_page.dart
    import 'package:flutter/material.dart';
    import 'package:http/http.dart' as http;
    import 'dart:convert';
    import '../models/product.dart';
    import 'package:provider/provider.dart';
    import '../providers/cart_provider.dart';

    class ProductListPage extends StatefulWidget {
      const ProductListPage({super.key});

      @override
      _ProductListPageState createState() => _ProductListPageState();
    }

    class _ProductListPageState extends State<ProductListPage> {
      List<Product> products = [];
      bool isLoading = true;

      @override
      void initState() {
        super.initState();
        fetchProducts();
      }

      Future<void> fetchProducts() async {
        try {
          print('Fetching products from: [https://dummyjson.com/products](https://dummyjson.com/products)');
          final response = await http.get(
            Uri.parse("[https://dummyjson.com/products](https://dummyjson.com/products)"),
          );
          print('Response status code: ${response.statusCode}');
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            if (data != null && data['products'] is List) {
              print('Response body received. Number of products: ${data['products'].length}');
              setState(() {
                products = (data['products'] as List)
                    .map((json) => Product.fromJson(json))
                    .toList();
                isLoading = false;
              });
              print('Products loaded successfully. Total products: ${products.length}');
            } else {
              print('Error: "products" key not found or not a list in JSON response.');
              setState(() {
                isLoading = false;
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error: Invalid product data format from API.')),
                );
              }
            }
          } else {
            setState(() {
              isLoading = false;
            });
            if (mounted) {
              print('Failed to load products. Status: ${response.statusCode}, Body: ${response.body}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to load products: ${response.statusCode}')),
              );
            }
          }
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          if (mounted) {
            print('Error fetching products: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        }
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Color.fromARGB(255, 58, 56, 56)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                AppBar(
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.amberAccent,
                      size: 28,
                    ),
                    tooltip: "Kembali",
                    splashRadius: 24,
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text(
                    "Produk Tersedia",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.shopping_cart,
                                  size: 42,
                                  color: Colors.amberAccent,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/cart');
                                },
                              ),
                              if (cart.totalQuantity > 0)
                                Positioned(
                                  right: 8,
                                  top: 5,
                                  child: CircleAvatar(
                                    radius: 7,
                                    backgroundColor: Colors.red,
                                    child: Text(
                                      cart.totalQuantity.toString(),
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                      : GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Colors.amber.withOpacity(0.3),
                                  width: 1.0,
                                ),
                              ),
                              color: const Color(0xFF333333),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/product-detail',
                                    arguments: product,
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFCF5ED),
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.3),
                                                  spreadRadius: 1,
                                                  blurRadius: 3,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: Image.network(
                                              product.thumbnail,
                                              fit: BoxFit.contain,
                                              errorBuilder: (context, error, stackTrace) {
                                                return const Center(
                                                  child: Icon(Icons.broken_image, size: 30, color: Colors.grey),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 6.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  (product.category ?? '').toUpperCase(),
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.amber,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  product.title,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[300],
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: Text(
                                                    "Rp ${product.price}",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.amberAccent,
                                                      shadows: [
                                                        Shadow(
                                                          color: Colors.black,
                                                          offset: Offset(0.5, 0.5),
                                                          blurRadius: 1,
                                                        ),
                                                      ],
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: Consumer<CartProvider>(
                                        builder: (context, cart, child) {
                                          return IconButton(
                                            icon: const Icon(
                                              Icons.add_shopping_cart,
                                              size: 24,
                                              color: Colors.amberAccent,
                                            ),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                                            onPressed: () {
                                              cart.addToCart(
                                                product.id,
                                                product.title,
                                                product.price,
                                                product.thumbnail,
                                                product.brand,
                                                product.category,
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('${product.title} ditambahkan!', style: const TextStyle(fontSize: 12, color: Colors.white)),
                                                  backgroundColor: Colors.green[700],
                                                  duration: const Duration(seconds: 1),
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
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
    }
    ```

---

### **8. File: `lib/page/product_detail_page.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart'; // Path disesuaikan

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black87,
              Colors.grey[850]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.amberAccent,
                  size: 28,
                ),
                tooltip: "Kembali",
                splashRadius: 24,
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.shopping_cart,
                              size: 42,
                              color: Colors.amberAccent,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/cart');
                            },
                          ),
                          if (cart.totalQuantity > 0)
                            Positioned(
                              right: 8,
                              top: 5,
                              child: CircleAvatar(
                                radius: 7,
                                backgroundColor: Colors.red,
                                child: Text(
                                  cart.totalQuantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white70,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.thumbnail,
                          width: 300,
                          height: 300,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image, size: 80, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.greenAccent,
                            Colors.teal,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.attach_money,
                            color: Colors.black87,
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Rp ${product.price}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              shadows: [
                                Shadow(
                                  color: Colors.black38,
                                  offset: Offset(1, 1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        product.description.isNotEmpty
                            ? product.description
                            : 'Deskripsi tidak tersedia.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[400],
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 30),

                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return ElevatedButton(
                          onPressed: () {
                            cart.addToCart(
                              product.id,
                              product.title,
                              product.price,
                              product.thumbnail,
                              product.brand,
                              product.category,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product.title} ditambahkan ke keranjang!',
                                ),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 16,
                            ),
                            elevation: 12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadowColor: Colors.black.withOpacity(0.4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.shopping_cart, color: Colors.white),
                              SizedBox(width: 12),
                              Text(
                                'Tambah ke Keranjang',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black38,
                                      offset: Offset(1, 1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}