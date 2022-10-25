part of 'checkout_bloc.dart';

@immutable
abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  // final String? fullName;
  // final String? email;
  // final String? address;
  // final String? city;
  // final String? country;
  // final String? zipCode;
  // final User? user;
  // final List<Product>? products;
  // final String? subtotal;
  // final String? deliveryFee;
  // final String? total;
  // final Checkout checkout;
  // final PaymentMethod paymentMethod;
  // final String? paymentMethodId;
  final Checkout checkout;

  const CheckoutLoaded({
    // this.fullName,
    // this.email,
    // this.address,
    // this.city,
    // this.country,
    // this.zipCode,
    // this.user,
    // this.products,
    // this.subtotal,
    // this.deliveryFee,
    // this.total,
    // this.paymentMethod = PaymentMethod.googlePay,
    // this.paymentMethodId,
    // }) : checkout = Checkout(
    //         // fullName: fullName,
    //         // email: email,
    //         // address: address,
    //         // city: city,
    //         // country: country,
    //         // zipCode: zipCode,
    //         user: user,
    //         products: products,
    //         subtotal: subtotal,
    //         deliveryFee: deliveryFee,
    //         total: total,
    //       );
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
        // products,
        // subtotal,
        // deliveryFee,
        // total,
        // paymentMethod,
        // paymentMethodId,
        checkout,
      ];
}
