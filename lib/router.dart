import 'package:flutter/material.dart';
import 'package:shoppy/features/admin/screens/add_product_screen.dart';
import 'package:shoppy/features/auth/screens/auth_screen.dart';
import 'package:shoppy/features/home/screens/home_screen.dart';
import 'package:shoppy/features/product_details/screens/product_details_screen.dart';
import 'package:shoppy/models/product.dart';

import 'common/widgets/bottom_bar.dart';
import 'features/home/screens/category_deals_screen.dart';
import 'features/search/screens/search_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );
    case CategoryDealsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>
            CategoryDealsScreen(category: routeSettings.arguments as String),
      );
    case SearchScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>
            SearchScreen(searchQuery: routeSettings.arguments as String),
      );
    case ProductDetailsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>
            ProductDetailsScreen(product: routeSettings.arguments as Product),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(child: Text('This page does not exist')),
        ),
      );
  }
}
