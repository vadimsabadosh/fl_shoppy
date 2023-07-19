// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'rating.dart';

class Product {
  final String name;
  final String description;
  final int quantity;
  final List<String> images;
  final String category;
  final double price;
  final String? id;
  final List<Rating>? rating;
  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    this.id,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'id': id,
      'price': price,
      'rating': rating,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      description: map['description'],
      quantity: map['quantity'],
      category: map['category'],
      id: map['_id'],
      rating: map['ratings'] != null
          ? List<Rating>.from(
              map["ratings"]?.map(
                (x) => Rating.fromMap(x),
              ),
            )
          : null,
      price: double.parse(map['price'].toString()),
      images: List<String>.from((map['images'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
