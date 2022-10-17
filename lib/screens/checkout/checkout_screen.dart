import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/widgets/widgets.dart';

class CheckoutScreen extends StatelessWidget {
  static const String routeName = '/checkout';
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(
        name: routeName,
      ),
      builder: (_) => const CheckoutScreen(),
    );
  }

  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Checkout',
        hideWishlist: true,
      ),
      bottomNavigationBar: const CustomNavBar(screen: '/checkout'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            if (state is CheckoutLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is CheckoutLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CUSTOMER INFORMATION',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  CustomTextFormField(
                    onChanged: (value) {
                      context.read<CheckoutBloc>().add(
                            UpdateCheckout(
                              email: value,
                            ),
                          );
                    },
                    title: 'Email',
                  ),
                  CustomTextFormField(
                    onChanged: (value) {
                      context.read<CheckoutBloc>().add(
                            UpdateCheckout(
                              fullName: value,
                            ),
                          );
                    },
                    title: 'Full Name',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'DELIVERY INFORMATION',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  CustomTextFormField(
                    onChanged: (value) {
                      context.read<CheckoutBloc>().add(
                            UpdateCheckout(
                              address: value,
                            ),
                          );
                    },
                    title: 'Address',
                  ),
                  CustomTextFormField(
                    onChanged: (value) {
                      context.read<CheckoutBloc>().add(
                            UpdateCheckout(
                              city: value,
                            ),
                          );
                    },
                    title: 'City',
                  ),
                  CustomTextFormField(
                    onChanged: (value) {
                      context.read<CheckoutBloc>().add(
                            UpdateCheckout(
                              country: value,
                            ),
                          );
                    },
                    title: 'Country',
                  ),
                  CustomTextFormField(
                    onChanged: (value) {
                      context.read<CheckoutBloc>().add(
                            UpdateCheckout(
                              zipCode: value,
                            ),
                          );
                    },
                    title: 'Zip Code',
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 60,
                    alignment: Alignment.bottomCenter,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/payment-selection',
                              );
                            },
                            child: Text(
                              'SELECT A PAYMENT METHOD',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'ORDER SUMMARY',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const OrderSummary(),
                ],
              );
            } else {
              return const Center(
                child: Text('Something went wrong.'),
              );
            }
          },
        ),
      ),
    );
  }
}
