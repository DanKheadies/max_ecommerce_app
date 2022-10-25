import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/models/models.dart';
import 'package:max_ecommerce_app/repositories/checkout/checkout_repository.dart';
import 'package:max_ecommerce_app/widgets/widgets.dart';

class OrderConfirmation extends StatelessWidget {
  static const String routeName = '/order-confirmation';
  static Route route({
    required String checkoutId,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(
        name: routeName,
      ),
      builder: (context) => BlocProvider(
        create: (context) => OrderConfirmationBloc(
          checkoutRepository: context.read<CheckoutRepository>(),
        )..add(
            LoadOrderConfirmation(
              checkoutId: checkoutId,
            ),
          ),
        child: OrderConfirmation(
          checkoutId: checkoutId,
        ),
      ),
    );
  }

  final String checkoutId;

  const OrderConfirmation({
    Key? key,
    required this.checkoutId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Order Confirmation',
        hideBack: true,
        hideWishlist: true,
      ),
      bottomNavigationBar: const CustomNavBar(
        screen: routeName,
      ),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<OrderConfirmationBloc, OrderConfirmationState>(
        builder: (context, state) {
          if (state is OrderConfirmationLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is OrderConfirmationLoaded) {
            List<Product> products = state.checkout.cart.products;
            Map cart = state.checkout.cart.productQuantity(products);

            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        color: Colors.black,
                        width: double.infinity,
                        height: 300,
                      ),
                      Positioned(
                        left: (MediaQuery.of(context).size.width) / 2.65,
                        top: 125,
                        child: SvgPicture.asset(
                          'assets/images/dankery-white.svg',
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Positioned(
                        top: 250,
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Your order is complete!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi ${state.checkout.user!.fullName},',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Thank you for purchasing from The Dankery.',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'ORDER CODE: #$checkoutId',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        OrderSummary(
                          cart: state.checkout.cart,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'ORDER DETAILS',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const Divider(thickness: 2),
                        const SizedBox(height: 5),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cart.keys.length,
                          itemBuilder: (context, index) {
                            return ProductCard.summary(
                              product: cart.keys.elementAt(index),
                              quantity: cart.values.elementAt(index),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Something went wrong.'),
            );
          }
        },
      ),
    );
  }
}
