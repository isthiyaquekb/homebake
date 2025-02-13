import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String businessDesc;
  final String expireDate;
  final String sku;
  final int stock;
  final int minStock;
  final String image;
  final String category;
  final Timestamp createdAt;

  ProductModel({
    this.id = '',
    required this.name,
    required this.description,
    required this.price,
    required this.businessDesc,
    required this.expireDate,
    required this.sku,
    required this.stock,
    required this.minStock,
    required this.image,
    required this.category,
    Timestamp? createdAt,
  }) : createdAt = createdAt ?? Timestamp.now();

  /// Converts a ProductModel instance into a Map (for FireStore)
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "price": price,
      "business_desc": businessDesc,
      "expire_date": expireDate,
      "sku": sku,
      "stock": stock,
      "min_stock": minStock,
      "image": image,
      "category": category,
      "created_at": createdAt,
    };
  }

  /// Creates a ProductModel instance from a FireStore document snapshot
  factory ProductModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ProductModel(
      id: documentId,
      name: map["name"] ?? '',
      description: map["description"] ?? '',
      price: (map["price"] ?? 0).toDouble(),
      businessDesc: map["business_desc"] ?? '',
      expireDate: map["expire_date"] ?? '',
      sku: map["sku"] ?? '',
      stock: (map["stock"] ?? 0).toInt(),
      minStock: (map["min_stock"] ?? 0).toInt(),
      image: map["image"]??'',
      category: map["category"]??'',
      createdAt: map["created_at"] ?? Timestamp.now(),
    );
  }

  /// Converts a FireStore document snapshot to a ProductModel instance
  factory ProductModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProductModel.fromMap(data, snapshot.id);
  }
}
