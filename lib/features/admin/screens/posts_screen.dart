import 'package:flutter/material.dart';
import 'package:shoppy/common/widgets/loader.dart';
import 'package:shoppy/features/account/widgets/single_product.dart';
import 'package:shoppy/features/admin/screens/add_product_screen.dart';
import 'package:shoppy/models/product.dart';

import '../services/admin_services.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final AdminServices adminServices = AdminServices();
  List<Product>? products;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  void deleteProduct(String id) {
    adminServices.deleteProduct(
      context: context,
      id: id,
      onSuccess: () {
        setState(() {
          products =
              products!.where((Product element) => element.id != id).toList();
        });
      },
    );
  }

  fetchProducts() async {
    products = await adminServices.getAllProducts(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            body: GridView.builder(
                itemCount: products!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  final product = products![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 140,
                          child: SingleProduct(image: product.images[0]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                deleteProduct(product.id!);
                              },
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: navigateToAddProduct,
              tooltip: 'Add a product',
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
