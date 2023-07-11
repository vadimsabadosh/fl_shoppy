import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/common/widgets/custom_button.dart';
import 'package:shoppy/common/widgets/custom_textfield.dart';
import 'package:shoppy/constants/global_vars.dart';
import 'package:shoppy/constants/utils.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = "/add-product";
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _productNameContrl = TextEditingController();
  final TextEditingController _descrNameContrl = TextEditingController();
  final TextEditingController _priceNameContrl = TextEditingController();
  final TextEditingController _quantityNameContrl = TextEditingController();

  List<File> images = [];

  String category = "Mobiles";

  List<String> productCategories = [
    'Mobiles',
    "Essentials",
    "Appliances",
    "Books",
    "Fashion"
  ];

  void selectImages() async {
    var res = await pickImages();

    setState(() {
      images = res;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _productNameContrl.dispose();
    _descrNameContrl.dispose();
    _priceNameContrl.dispose();
    _quantityNameContrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          centerTitle: true,
          title:
              const Text('Add Product', style: TextStyle(color: Colors.black)),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              children: [
                images.isEmpty
                    ? GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open_outlined,
                                  size: 40,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Select Product Images',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade400),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : CarouselSlider(
                        items: images.map((i) {
                          return Builder(
                            builder: (context) => Image.file(
                              i,
                              fit: BoxFit.cover,
                              height: 200,
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ),
                      ),
                const SizedBox(height: 30),
                CustomTextField(
                    controller: _productNameContrl, hintText: 'Product Name'),
                const SizedBox(height: 10),
                CustomTextField(
                    controller: _descrNameContrl,
                    hintText: 'Description',
                    maxLines: 6),
                const SizedBox(height: 10),
                CustomTextField(
                    controller: _priceNameContrl, hintText: 'Price'),
                const SizedBox(height: 10),
                CustomTextField(
                    controller: _quantityNameContrl, hintText: 'Quantity'),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: productCategories.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        category = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(text: 'Sell', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
