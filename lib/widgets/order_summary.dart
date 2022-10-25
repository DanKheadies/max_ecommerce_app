import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/models/models.dart';
// import 'package:max_ecommerce_app/widgets/widgets.dart';

class OrderSummary extends StatelessWidget {
  final Cart cart;

  const OrderSummary({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 10,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    '\$${cart.subtotalString}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DELIVERY FEE',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    '\$${cart.deliveryFeeString}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(5),
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      '\$${cart.totalString}',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
