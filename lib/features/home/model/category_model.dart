import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  late final String name;
  final String image;

  CategoryModel({
    this.id = '',
    required this.name,
    required this.image,
  });

  /// Converts a ProductModel instance into a Map (for FireStore)
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "image": image,
    };
  }

  /// Creates a ProductModel instance from a FireStore document snapshot
  factory CategoryModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CategoryModel(
      id: documentId,
      name: map["name"] ?? '',
      image: map["image"],
    );
  }

  /// Converts a FireStore document snapshot to a ProductModel instance
  factory CategoryModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CategoryModel.fromMap(data, snapshot.id);
  }
}
