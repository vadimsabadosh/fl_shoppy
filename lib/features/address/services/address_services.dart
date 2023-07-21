// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/constants/error_handling.dart';
import 'package:shoppy/constants/global_vars.dart';
import 'package:shoppy/constants/utils.dart';
import 'package:shoppy/models/user.dart';
import 'package:shoppy/providers/user_provider.dart';

class AddressServices {
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      http.Response resp = await http.post(
        Uri.parse('$uri/api/save-user-address'),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": userProvider.user.token,
        },
        body: jsonEncode({"address": address}),
      );
      httpErrorHandle(
          response: resp,
          context: context,
          onSuccess: () {
            User user = userProvider.user
                .copyWith(address: jsonDecode(resp.body)["address"]);

            userProvider.setUserFromModel(user);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response resp = await http.post(
        Uri.parse('$uri/api/order'),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": userProvider.user.token,
        },
        body: jsonEncode({
          "cart": userProvider.user.cart,
          "totalPrice": totalSum,
          "address": address
        }),
      );
      httpErrorHandle(
          response: resp,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Order has been placed!');
            User user = userProvider.user.copyWith(cart: []);
            userProvider.setUserFromModel(user);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
