import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/models/models.dart';

class CustomNavBar extends StatelessWidget {
  final String screen;
  final Product? product;

  const CustomNavBar({
    Key? key,
    required this.screen,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _selectNavBar(context, screen)!,
        ),
      ),
    );
  }

  List<Widget>? _selectNavBar(context, screen) {
    switch (screen) {
      case '/':
        return _buildNavBar(context);
      case '/cart':
        return _buildGoToCheckoutNavBar(context);
      case '/catalog':
        return _buildNavBar(context);
      case '/checkout':
        return _buildOrderNowNavBar(context);
      case '/product':
        return _buildAddToCartNavBar(context, product);
      case '/wishlist':
        return _buildNavBar(context);
      default:
        return _buildNavBar(context);
    }
  }

  List<Widget> _buildNavBar(context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.home,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/home');
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.person,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/user');
        },
      ),
    ];
  }

  List<Widget> _buildAddToCartNavBar(context, product) {
    return [
      IconButton(
        icon: const Icon(
          Icons.share,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          return IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: () {
              context.read<WishlistBloc>().add(AddProductToWishlist(product));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to your Wishlist!'),
                ),
              );
            },
          );
        },
      ),
      BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CartLoaded) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: () {
                context.read<CartBloc>().add(AddProductToCart(product));
                Navigator.pushNamed(context, '/cart');
              },
              child: Text(
                'ADD TO CART',
                style: Theme.of(context).textTheme.headline3,
              ),
            );
          } else {
            return const Center(
              child: Text('Something went wrong.'),
            );
          }
        },
      ),
    ];
  }

  List<Widget> _buildGoToCheckoutNavBar(context) {
    return [
      ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/checkout');
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: const RoundedRectangleBorder(),
        ),
        child: Text(
          'GO TO CHECKOUT',
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    ];
  }

  List<Widget> _buildOrderNowNavBar(context) {
    return [
      BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          if (state is CheckoutLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CheckoutLoaded) {
            return ElevatedButton(
              onPressed: () {
                context.read<CheckoutBloc>().add(
                      ConfirmCheckout(
                        checkout: state.checkout,
                      ),
                    );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: const RoundedRectangleBorder(),
              ),
              child: Text(
                'ORDER NOW',
                style: Theme.of(context).textTheme.headline3,
              ),
            );
          } else {
            return const Center(
              child: Text('Something went wrong.'),
            );
          }
        },
      ),
    ];
  }
}
