import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/common/widgets/custom_button.dart';
import 'package:shoppy/constants/global_vars.dart';
import 'package:shoppy/features/address/screens/address_screen.dart';
import 'package:shoppy/features/cart/widgets/cart_subtotal.dart';
import 'package:shoppy/features/home/widgets/address_box.dart';
import 'package:shoppy/features/search/screens/search_screen.dart';
import 'package:shoppy/providers/user_provider.dart';

import '../widgets/cart_product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void navigateToSearchScreen(String value) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: value);
  }

  void navigateToAddressScreen(int sum) {
    Navigator.pushNamed(context, AddressScreen.routeName,
        arguments: sum.toString());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    int sum = 0;
    user.cart
        .map((el) => sum += el['quantity'] * el["product"]["price"] as int)
        .toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide:
                              BorderSide(color: Colors.black38, width: 1),
                        ),
                        hintText: "Search Shoppy.com",
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: const Icon(
                  Icons.mic,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressBox(),
            const CartSubtotal(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: "Proceed to Buy",
                onPressed: () => navigateToAddressScreen(sum),
                color: Colors.yellow[600],
              ),
            ),
            const SizedBox(height: 16),
            Container(color: Colors.black12.withOpacity(0.08), height: 1),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) => CartProduct(index: index),
              itemCount: user.cart.length,
            )
          ],
        ),
      ),
    );
  }
}
