import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/constants/utils.dart';

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
      final cloudinary = CloudinaryPublic('dhi9lh1i7', 'lewjnig8');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
