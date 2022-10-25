import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/models/models.dart';
import 'package:max_ecommerce_app/widgets/widgets.dart';

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
        child: screen == '/product'
            ? AddToCartNavBar(product: product!)
            : screen == '/cart'
                ? const GoToCheckoutNavBar()
                : screen == '/checkout'
                    ? const OrderNowNavBar()
                    : const HomeNavBar(),
      ),
    );
  }
}

class AddToCartNavBar extends StatelessWidget {
  const AddToCartNavBar({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.share,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            if (state is WishlistLoading) {
              return const CircularProgressIndicator();
            }
            if (state is WishlistLoaded) {
              return IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                onPressed: () {
                  context
                      .read<WishlistBloc>()
                      .add(AddProductToWishlist(product));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to your Wishlist!'),
                    ),
                  );
                },
              );
            } else {
              return const Icon(
                Icons.error_outline,
                color: Colors.red,
              );
            }
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
                  backgroundColor: Colors.white,
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
      ],
    );
  }
}

class GoToCheckoutNavBar extends StatelessWidget {
  const GoToCheckoutNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/checkout');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(),
          ),
          child: Text(
            'GO TO CHECKOUT',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ],
    );
  }
}

class HomeNavBar extends StatelessWidget {
  const HomeNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ],
    );
  }
}

class OrderNowNavBar extends StatelessWidget {
  const OrderNowNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            if (state is CheckoutLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is CheckoutLoaded) {
              if (state.checkout.paymentMethod == PaymentMethod.creditCard &&
                  state.checkout.paymentMethodId != null) {
                return SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<PaymentBloc>().add(
                            CreatePaymentIntent(
                              paymentMethodId: state.checkout.paymentMethodId!,
                              amount: state.checkout.total,
                            ),
                          );
                      // Navigator.pushNamed(context, '/order-confirmation');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'Pay with Credit Card',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                );
              }
              if (Platform.isAndroid &&
                  state.checkout.paymentMethod == PaymentMethod.googlePay) {
                return GooglePay(
                  products: state.checkout.cart.products,
                  total: state.checkout.total.toString(),
                );
              }
              if (Platform.isIOS &&
                  state.checkout.paymentMethod == PaymentMethod.applePay) {
                return ApplePay(
                  products: state.checkout.cart.products,
                  total: state.checkout.total.toString(),
                );
              } else {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/payment-selection');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    'CHOOSE PAYMENT',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                );
              }
            } else {
              return const Center(
                child: Text('Something went wrong.'),
              );
            }
          },
        ),
      ],
    );
  }
}
