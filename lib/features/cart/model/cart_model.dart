// Cart Model
class CartModel {
  final String productId;
  final String name;
  final String image;
  final double price;
  int quantity;

  CartModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      productId: map['productId'],
      name: map['name'],
      image: map['image'],
      price: map['price'].toDouble(),
      quantity: map['quantity'],
    );
  }
}