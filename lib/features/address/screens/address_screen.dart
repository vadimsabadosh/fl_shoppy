// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/common/widgets/custom_button.dart';
import 'package:shoppy/common/widgets/custom_textfield.dart';
import 'package:shoppy/constants/global_vars.dart';
import 'package:shoppy/constants/utils.dart';
import 'package:shoppy/features/address/services/address_services.dart';
import 'package:shoppy/providers/user_provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({
    Key? key,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _flatController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  late final Future<PaymentConfiguration> _googlePayConfigFuture;
  List<PaymentItem> items = [];
  String addressToBeUsed = "";
  final AddressServices addressServices = AddressServices();

  @override
  void initState() {
    super.initState();
    _googlePayConfigFuture = PaymentConfiguration.fromAsset('gpay.json');
    items.add(PaymentItem(
      amount: widget.totalAmount,
      label: "Total amount",
      status: PaymentItemStatus.final_price,
    ));
  }

  void clearFields() {
    _flatController.text = "";
    _areaController.text = "";
    _zipcodeController.text = "";
    _townController.text = "";
  }

  @override
  void dispose() {
    super.dispose();
    _flatController.dispose();
    _areaController.dispose();
    _zipcodeController.dispose();
    _townController.dispose();
  }

  void onGooglePayResult(Map<String, dynamic> val) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    addressServices.placeOrder(
        context: context,
        address: addressToBeUsed,
        totalSum: double.parse(widget.totalAmount));
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";
    bool isForm = _flatController.text.isNotEmpty ||
        _areaController.text.isNotEmpty ||
        _zipcodeController.text.isNotEmpty ||
        _townController.text.isNotEmpty;

    if (isForm) {
      var valid = _addressFormKey.currentState!.validate();
      if (valid) {
        addressToBeUsed =
            '${_flatController.text}, ${_areaController.text}, ${_zipcodeController.text}, ${_townController.text}';
      } else {
        throw Exception("Error");
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, "ERROR");
    }
  }

  void onOrderPressed(String addressFromProvider) {
    payPressed(addressFromProvider);
    onGooglePayResult({"": ""});

    clearFields();
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text(address, style: const TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('OR',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    const SizedBox(height: 20),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: 'Flat, house, building',
                      controller: _flatController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Area, street',
                      controller: _areaController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Zipcode',
                      controller: _zipcodeController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Town, city',
                      controller: _townController,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              CustomButton(
                  text: "Order", onPressed: () => onOrderPressed(address)),
              FutureBuilder<PaymentConfiguration>(
                  future: _googlePayConfigFuture,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? GooglePayButton(
                            onPressed: () => payPressed(address),
                            width: double.infinity,
                            height: 50,
                            paymentConfiguration: snapshot.data!,
                            paymentItems: items,
                            type: GooglePayButtonType.buy,
                            margin: const EdgeInsets.only(top: 15.0),
                            onPaymentResult: onGooglePayResult,
                            loadingIndicator: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : const SizedBox.shrink();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
