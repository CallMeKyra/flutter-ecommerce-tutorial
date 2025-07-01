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