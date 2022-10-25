part of 'checkout_bloc.dart';

@immutable
abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class UpdateCheckout extends CheckoutEvent {
  // final String? fullName;
  // final String? email;
  // final String? address;
  // final String? city;
  // final String? country;
  // final String? zipCode;
  // final User? user;
  // final Cart? cart;
  // final PaymentMethod? paymentMethod;
  // final String? paymentMethodId;
  final Checkout checkout;

  const UpdateCheckout({
    // this.fullName,
    // this.email,
    // this.address,
    // this.city,
    // this.country,
    // this.zipCode,
    // this.user,
    // this.cart,
    // this.paymentMethod,
    // this.paymentMethodId,
    required this.checkout,
  });

  @override
  List<Object?> get props => [
        // fullName,
        // email,
        // address,
        // city,
        // country,
        // zipCode,
        // user,
        // cart,
        // paymentMethod,
        // paymentMethodId,
        checkout,
      ];
}

class ConfirmCheckout extends CheckoutEvent {
  // final Checkout checkout;
  final bool isPaymentSuccessful;

  const ConfirmCheckout({
    // required this.checkout,
    required this.isPaymentSuccessful,
  });

  @override
  List<Object?> get props => [
        isPaymentSuccessful,
      ];
}
