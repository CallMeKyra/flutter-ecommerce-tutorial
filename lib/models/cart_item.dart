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