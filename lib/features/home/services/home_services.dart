import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/constants/error_handling.dart';
import 'package:shoppy/constants/global_vars.dart';
import 'package:shoppy/constants/utils.dart';
import 'package:shoppy/models/product.dart';
import 'package:shoppy/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class HomeServices {
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    List<Product> products = [];
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response resp = await http.get(
        Uri.parse('$uri/api/products?category=$category'),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": userProvider.user.token,
        },
      );
      httpErrorHandle(
          response: resp,
          context: context,
          onSuccess: () {
            var decodedJson = jsonDecode(resp.body);
            for (var i = 0; i < decodedJson.length; i++) {
              products.add(Product.fromJson(jsonEncode(decodedJson[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return products;
  }

  Future<Product> fetchDealOfDay({
    required BuildContext context,
  }) async {
    Product product = Product(
        name: '',
        description: '',
        quantity: 0,
        images: [],
        category: '',
        price: 0);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response resp = await http.get(
        Uri.parse('$uri/api/deal-of-the-day'),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": userProvider.user.token,
        },
      );
      httpErrorHandle(
          response: resp,
          context: context,
          onSuccess: () {
            product = Product.fromJson(resp.body);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return product;
  }
}
