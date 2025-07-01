import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List products = data['products'];

      return products.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil produk');
    }
  }
}
