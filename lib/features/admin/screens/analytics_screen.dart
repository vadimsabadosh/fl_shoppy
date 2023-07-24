import 'package:flutter/material.dart';
import 'package:shoppy/common/widgets/loader.dart';
import 'package:shoppy/features/admin/models/sales.dart';
import 'package:shoppy/features/admin/services/admin_services.dart';
import 'package:shoppy/features/admin/widgets/category_products_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int? totalSales;
  List<Sales>? sales;
  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  getEarnings() async {
    var earningData = await adminServices.getEarnings(context: context);
    totalSales = earningData['totalEarning'];
    sales = earningData['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return sales == null || totalSales == null
        ? const Loader()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$$totalSales',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              CategoryProductsChart(
                sales: sales!,
              ),
            ],
          );
  }
}
