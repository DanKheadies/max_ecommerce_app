import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/models/models.dart';
import 'package:max_ecommerce_app/screens/screens.dart';
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
        child: BlocConsumer<CheckoutBloc, CheckoutState>(
          listener: ((context, state) {
            if ((state as CheckoutLoaded).checkout.isPaymentSuccessful) {
              Navigator.pushNamed(
                context,
                OrderConfirmation.routeName,
                arguments: state.checkout.id,
              );
            }
          }),
          builder: (context, state) {
            if (state is CheckoutLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is CheckoutLoaded) {
              var user = state.checkout.user ?? User.empty;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CUSTOMER INFORMATION',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  CustomTextFormField(
                    initialValue: user.email,
                    onChanged: (value) {
                      User user = state.checkout.user!.copyWith(
                        email: value,
                      );
                      context.read<CheckoutBloc>().add(
                            UpdateCheckout(
                              // user: state.checkout.user!.copyWith(
                              //   email: value,
                              // ),
                              checkout: state.checkout.copyWith(
                                user: user,
                              ),
                            ),
                          );
                    },
                    title: 'Email',
                  ),
                  CustomTextFormField(
                    initialValue: user.fullName,
                    onChanged: (value) {
                      User user = state.checkout.user!.copyWith(
                        fullName: value,
                      );
                      context.read<CheckoutBloc>().add(
                            UpdateCheckout(
                              checkout: state.checkout.copyWith(
                                user: user,
                              ),
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
                    initialValue: user.address,
                    onChanged: (value) {
                      User user = state.checkout.user!.copyWith(
                        address: value,
                      );
                      context.read<CheckoutBloc>().add(
                            UpdateCheckout(
                              checkout: state.checkout.copyWith(
                                user: user,
                              ),
                            ),
                          );
                    },
                    title: 'Address',
                  ),
                  CustomTextFormField(
                    initialValue: user.city,
                    onChanged: (value) {
                      User user = state.checkout.user!.copyWith(
                        city: value,
                      );
                      context.read<CheckoutBloc>().add(
                            UpdateCheckout(
                              checkout: state.checkout.copyWith(
                                user: user,
                              ),
                            ),
                          );
                    },
                    title: 'City',
                  ),
                  CustomTextFormField(
                    initialValue: user.country,
                    onChanged: (value) {
                      User user = state.checkout.user!.copyWith(
                        country: value,
                      );
                      context.read<CheckoutBloc>().add(
                            UpdateCheckout(
                              checkout: state.checkout.copyWith(
                                user: user,
                              ),
                            ),
                          );
                    },
                    title: 'Country',
                  ),
                  CustomTextFormField(
                    initialValue: user.zipCode,
                    onChanged: (value) {
                      User user = state.checkout.user!.copyWith(
                        zipCode: value,
                      );
                      context.read<CheckoutBloc>().add(
                            UpdateCheckout(
                              checkout: state.checkout.copyWith(
                                user: user,
                              ),
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
                  OrderSummary(
                    cart: state.checkout.cart,
                  ),
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
