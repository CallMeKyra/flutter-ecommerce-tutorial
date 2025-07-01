import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../cart_provider.dart';

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
            ], // **Gradasi lebih mewah**
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.deepOrange,
                  size: 28,
                ), // **Ikon kembali lebih eksklusif**
                tooltip: "Kembali",
                splashRadius: 24,
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                product.title,
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
                      padding: EdgeInsets.only(right: 16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
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
                                  style: TextStyle(
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
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // **Border dan shadow mengikuti bentuk gambar**
                        border: Border.all(
                          color:
                              Colors
                                  .white70, // **Warna putih krem yang lebih lembut**
                          width: 3, // **Ketebalan border yang pas**
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.5,
                            ), // **Shadow lebih tajam**
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: Offset(
                              0,
                              6,
                            ), // **Bayangan lebih jelas tanpa terlalu gelap**
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // **Membuat sudut lebih halus**
                        child: Image.network(
                          product.thumbnail,
                          width: 250, // **Ukuran tetap proporsional**
                          height: 250,
                          fit:
                              BoxFit
                                  .contain, // **Menjaga proporsi gambar tanpa distorsi**
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Container(
                            width:
                                200, // **Lebar border lebih pendek agar sesuai dengan teks harga**
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 10,
                            ), // **Padding lebih kecil agar pas**
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // **Bentuk tetap elegan**
                              gradient: LinearGradient(
                                colors: [
                                  Colors.greenAccent,
                                  Colors.teal,
                                ], // **Gradasi tetap eksklusif**
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.black87,
                                  size: 22,
                                ), // **Ukuran ikon lebih kecil**
                                SizedBox(
                                  width: 6,
                                ), // **Menyesuaikan jarak agar lebih harmonis**
                                Text(
                                  "Rp ${product.price}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(
                                          0.3,
                                        ), // **Shadow lebih halus**
                                        offset: Offset(1, 1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
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
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return ElevatedButton(
                          onPressed: () {
                            cart.addToCart(
                              product.id,
                              product.title,
                              product.price,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product.title} ditambahkan ke keranjang!',
                                ),
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Colors.deepOrange, // **Warna lebih premium**
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 16,
                            ),
                            elevation: 12, // **Efek bayangan lebih mewah**
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadowColor: Colors.black.withOpacity(
                              0.4,
                            ), // **Menambahkan shadow**
                          ),
                          child: Row(
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
                                      color: Colors.black.withOpacity(0.3),
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
                    SizedBox(height: 20),
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
