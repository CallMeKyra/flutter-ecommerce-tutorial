import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.grey[800]!], // Tema elegan
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: Text(
                'Keranjang Kamu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.amberAccent,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: Scrollbar(
                // **Menambahkan scrollbar lebih jelas**
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 10,
                radius: Radius.circular(14),
                child: ListView.builder(
                  itemCount: Provider.of<CartProvider>(context).items.length,
                  itemBuilder: (context, index) {
                    final entry =
                        Provider.of<CartProvider>(
                          context,
                        ).items.entries.toList()[index];
                    final item = entry.value;
                    return _buildCartItem(context, item);
                  },
                ),
              ),
            ),
            _buildTotalSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, item) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Card(
        color: Colors.black.withOpacity(0.3),
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Harga: Rp ${item.price.toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.grey[300], fontSize: 13),
                  ),
                  Text(
                    "Jumlah: ${item.quantity}",
                    style: TextStyle(color: Colors.grey[300], fontSize: 13),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                  size: 28,
                ), // **Memastikan ikon tetap ada**
                onPressed: () {
                  cart.removeFromCart(
                    item.id,
                  ); // **Memastikan fungsi hapus bekerja**
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${item.title} telah dihapus dari keranjang',
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalSection(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.7,
            ), // **Bayangan hitam lebih elegan**
            spreadRadius: 5,
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  Colors.brown,
                  Colors.amber,
                ], // **Warna lebih profesional**
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.white70, size: 30),
                SizedBox(width: 12),
                Text(
                  'Total Produk: ${cart.items.values.fold(0, (sum, item) => sum + item.quantity)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.blueGrey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.attach_money, color: Colors.white70, size: 30),
                SizedBox(width: 12),
                Text(
                  'Total Harga: Rp ${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
