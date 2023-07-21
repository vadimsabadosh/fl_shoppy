// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/constants/error_handling.dart';
import 'package:shoppy/constants/global_vars.dart';
import 'package:shoppy/constants/utils.dart';
import 'package:shoppy/models/user.dart';
import 'package:shoppy/providers/user_provider.dart';
import "package:http/http.dart" as http;

class ProductDetailsServices {
  void rateProduct({
    required BuildContext context,
    required String id,
    required double rating,
  }) async {
    try {
      final userProdiver = Provider.of<UserProvider>(context, listen: false);

      http.Response resp = await http.post(
        Uri.parse('$uri/api/rate-product'),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": userProdiver.user.token,
        },
        body: jsonEncode({
          "id": id,
          "rating": rating,
        }),
      );
      httpErrorHandle(response: resp, context: context, onSuccess: () {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void addToCart({
    required BuildContext context,
    required String id,
  }) async {
    try {
      final userProdiver = Provider.of<UserProvider>(context, listen: false);

      http.Response resp = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": userProdiver.user.token,
        },
        body: jsonEncode({
          "id": id,
        }),
      );
      httpErrorHandle(
          response: resp,
          context: context,
          onSuccess: () {
            User user =
                userProdiver.user.copyWith(cart: jsonDecode(resp.body)['cart']);

            userProdiver.setUserFromModel(user);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
