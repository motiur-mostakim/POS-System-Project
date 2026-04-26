class Product {
  final String id;
  final String name;
  final double price;
  final String barcode;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.barcode,
  });
}

class CartItemModel {
  final Product product;
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});
}
