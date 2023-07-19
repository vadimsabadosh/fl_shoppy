import 'package:flutter/material.dart';
import 'package:shoppy/common/widgets/stars.dart';
import 'package:shoppy/features/product_details/screens/product_details_screen.dart';
import 'package:shoppy/models/product.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;
  const SearchedProduct({super.key, required this.product});

  void navigateToProductScreen(context) {
    Navigator.pushNamed(context, ProductDetailsScreen.routeName,
        arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    double totalRating = 0;
    for (int i = 0; i < product.rating!.length; i++) {
      totalRating += product.rating![i].rating;
    }

    double avgRating = 0;
    if (totalRating != 0) {
      avgRating = totalRating / product.rating!.length;
    }
    return GestureDetector(
      onTap: () {
        navigateToProductScreen(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Image.network(
              product.images[0],
              fit: BoxFit.contain,
              height: 135,
              width: 135,
            ),
            Column(
              children: [
                Container(
                  width: 235,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    product.name,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 2,
                  ),
                ),
                Container(
                  width: 235,
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Stars(rating: avgRating),
                ),
                Container(
                  width: 235,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    '\$${product.price.toString()}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 235,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    'Eligible for FREE Shipping',
                  ),
                ),
                Container(
                  width: 235,
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: const Text(
                    'In Stock',
                    style: TextStyle(color: Colors.teal),
                    maxLines: 2,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
