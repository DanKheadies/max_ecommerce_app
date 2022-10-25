import 'package:flutter/material.dart';

import 'package:max_ecommerce_app/models/models.dart';
import 'package:max_ecommerce_app/screens/screens.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('This is route: ${settings.name}');

    switch (settings.name) {
      case '/':
        return HomeScreen.route();
      case CartScreen.routeName:
        return CartScreen.route();
      case CatalogScreen.routeName:
        return CatalogScreen.route(
          category: settings.arguments as Category,
        );
      case CheckoutScreen.routeName:
        return CheckoutScreen.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case OrderConfirmation.routeName:
        return OrderConfirmation.route(
          checkoutId: settings.arguments as String,
        );
      case PaymentSelection.routeName:
        return PaymentSelection.route();
      case ProductScreen.routeName:
        return ProductScreen.route(
          product: settings.arguments as Product,
        );
      case ProfileScreen.routeName:
        return ProfileScreen.route();
      case SignUpScreen.routeName:
        return SignUpScreen.route();
      case SplashScreen.routeName:
        return SplashScreen.route();
      case WishlistScreen.routeName:
        return WishlistScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(
        name: '/error',
      ),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
      ),
    );
  }
}
