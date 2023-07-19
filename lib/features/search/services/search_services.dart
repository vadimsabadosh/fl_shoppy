import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/constants/error_handling.dart';
import 'package:shoppy/constants/global_vars.dart';
import 'package:shoppy/constants/utils.dart';
import 'package:shoppy/models/product.dart';
import 'package:shoppy/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class SearchServices {
  Future<List<Product>> fetchSearchProducts({
    required BuildContext context,
    required String searchQuery,
  }) async {
    List<Product> products = [];
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response resp = await http.get(
        Uri.parse('$uri/api/products/search/$searchQuery'),
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
}
