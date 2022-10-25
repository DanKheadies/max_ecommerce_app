import 'dart:io';

import 'package:pay/pay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/models/models.dart';
import 'package:max_ecommerce_app/widgets/widgets.dart';

class PaymentSelection extends StatelessWidget {
  static const String routeName = '/payment-selection';
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(
        name: routeName,
      ),
      builder: (_) => const PaymentSelection(),
    );
  }

  const PaymentSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Payment',
        hideWishlist: true,
      ),
      bottomNavigationBar: const CustomNavBar(screen: routeName),
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state.status == PaymentStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == PaymentStatus.initial) {
            stripe.CardFormEditController controller =
                stripe.CardFormEditController();
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Add your Credit Card Details',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 10),
                stripe.CardFormField(
                  controller: controller,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final paymentBloc = context.read<PaymentBloc>();

                    if (controller.details.complete) {
                      final stripePaymentMethod =
                          await stripe.Stripe.instance.createPaymentMethod(
                        stripe.PaymentMethodParams.card(
                          paymentMethodData: stripe.PaymentMethodData(
                            billingDetails: stripe.BillingDetails(
                              email: (context.read<CheckoutBloc>().state
                                      as CheckoutLoaded)
                                  .checkout
                                  .user!
                                  .email,
                            ),
                          ),
                        ),
                      );
                      paymentBloc.add(
                        SelectPaymentMethod(
                          paymentMethodId: stripePaymentMethod.id,
                          paymentMethod: PaymentMethod.creditCard,
                        ),
                      );
                      navigator.pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('The form is not complete.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Pay with Credit Card'),
                ),
                const SizedBox(height: 20),
                Text(
                  'Choose a different payment method',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 10),
                Platform.isIOS
                    ? RawApplePayButton(
                        style: ApplePayButtonStyle.black,
                        type: ApplePayButtonType.inStore,
                        onPressed: () {
                          context.read<PaymentBloc>().add(
                                const SelectPaymentMethod(
                                  paymentMethod: PaymentMethod.applePay,
                                ),
                              );
                          Navigator.pop(context);
                        },
                      )
                    : const SizedBox(),
                const SizedBox(height: 10),
                Platform.isAndroid
                    ? RawGooglePayButton(
                        type: GooglePayButtonType.pay,
                        onPressed: () {
                          context.read<PaymentBloc>().add(
                                const SelectPaymentMethod(
                                  paymentMethod: PaymentMethod.googlePay,
                                ),
                              );
                          Navigator.pop(context);
                        },
                      )
                    : const SizedBox(),
              ],
            );
          }
          if (state.status == PaymentStatus.success) {
            return const Center(
              child: Text('Payment successful.'),
            );
          }
          if (state.status == PaymentStatus.failure) {
            return const Center(
              child: Text('Payment failed.'),
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
