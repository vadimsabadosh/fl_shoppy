// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/constants/error_handling.dart';
import 'package:shoppy/constants/global_vars.dart';
import 'package:shoppy/constants/utils.dart';
import 'package:shoppy/models/order.dart';
import 'package:shoppy/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class AccountServices {
  Future<List<Order>> fetchOrders({
    required BuildContext context,
  }) async {
    List<Order> orders = [];
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response resp = await http.get(
        Uri.parse('$uri/api/orders/me'),
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
              orders.add(Order.fromJson(jsonEncode(decodedJson[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orders;
  }
}
