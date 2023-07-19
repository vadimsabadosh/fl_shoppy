import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/constants/error_handling.dart';
import 'package:shoppy/constants/global_vars.dart';
import 'package:shoppy/constants/utils.dart';
import 'package:shoppy/models/product.dart';
import 'package:shoppy/providers/user_provider.dart';

class AdminServices {
  void sellProduct(
      {required BuildContext context,
      required String name,
      required String description,
      required double price,
      required int quantity,
      required String category,
      required List<File> images}) async {
    try {
      final userProdiver = Provider.of<UserProvider>(context, listen: false);
      final cloudinary = CloudinaryPublic('dhi9lh1i7', 'lewjnig8');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            images[i].path,
            folder: name,
            resourceType: CloudinaryResourceType.Image,
          ),
        );
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );
      http.Response resp = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": userProdiver.user.token,
        },
        body: product.toJson(),
      );
      httpErrorHandle(
          response: resp,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Product successfuly added');
            Navigator.pop(context);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Product>> getAllProducts({required BuildContext context}) async {
    List<Product> products = [];
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response resp = await http.get(
        Uri.parse('$uri/admin/get-products'),
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

  void deleteProduct(
      {required BuildContext context,
      required String id,
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response resp = await http.delete(
        Uri.parse('$uri/admin/delete-product'),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": userProvider.user.token,
        },
        body: jsonEncode({"id": id}),
      );
      httpErrorHandle(
          response: resp,
          context: context,
          onSuccess: () {
            onSuccess();
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
