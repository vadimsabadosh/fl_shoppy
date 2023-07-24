import 'package:flutter/material.dart';
import 'package:shoppy/common/widgets/loader.dart';
import 'package:shoppy/features/account/widgets/single_product.dart';
import 'package:shoppy/features/order_details/screens/order_details_screen.dart';
import 'package:shoppy/models/order.dart';

import '../services/admin_services.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final AdminServices adminServices = AdminServices();
  List<Order>? orders;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  fetchOrders() async {
    orders = await adminServices.fetchAllOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GridView.builder(
              itemCount: orders!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                var order = orders![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OrderDetailsScreen.routeName,
                        arguments: order);
                  },
                  child: SizedBox(
                    height: 140,
                    child: SingleProduct(image: order.products[0].images[0]),
                  ),
                );
              },
            ),
          );
  }
}
