import 'package:equatable/equatable.dart';

import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/models/models.dart';

class Checkout extends Equatable {
  final String? id;
  // final String? fullName;
  // final String? email;
  // final String? address;
  // final String? city;
  // final String? country;
  // final String? zipCode;
  final User? user;
  // final List<Product>? products;
  // final String? subtotal;
  // final String? deliveryFee;
  // final String? total;
  final Cart cart;
  final PaymentMethod paymentMethod;
  final String? paymentMethodId;
  final bool isPaymentSuccessful;

  const Checkout({
    this.id = '',
    // required this.fullName,
    // required this.email,
    // required this.address,
    // required this.city,
    // required this.country,
    // required this.zipCode,
    this.user = User.empty,
    // required this.products,
    // required this.subtotal,
    // required this.deliveryFee,
    // required this.total,
    required this.cart,
    this.paymentMethod = PaymentMethod.creditCard,
    this.paymentMethodId,
    this.isPaymentSuccessful = false,
  });

  int get total {
    double subtotal = this.cart.products.fold(
          0,
          (total, current) => total + current.price,
        );
    if (subtotal >= 30.0) {
      return (subtotal * 100).toInt();
    } else {
      return ((subtotal + 10) * 100).toInt();
    }
  }

  @override
  List<Object?> get props => [
        id,
        // fullName,
        // email,
        // address,
        // city,
        // country,
        // zipCode,
        user,
        // products,
        // subtotal,
        // deliveryFee,
        // total,
        cart,
        paymentMethod,
        paymentMethodId,
        isPaymentSuccessful,
      ];

  Checkout copyWith({
    String? id,
    User? user,
    Cart? cart,
    PaymentMethod? paymentMethod,
    String? paymentMethodId,
    bool? isPaymentSuccessful,
  }) {
    return Checkout(
      id: id ?? this.id,
      user: user ?? this.user,
      cart: cart ?? this.cart,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      isPaymentSuccessful: isPaymentSuccessful ?? this.isPaymentSuccessful,
    );
  }

  Map<String, Object> toDocument() {
    // Map customerAddress = {};
    // customerAddress['address'] = address;
    // customerAddress['city'] = city;
    // customerAddress['country'] = country;
    // customerAddress['zipCode'] = zipCode;

    return {
      // 'customerAddress': customerAddress,
      // 'customerName': fullName!,
      // 'customerEmail': email!,
      'user': user?.toDocument() ?? User.empty.toDocument(),
      // 'products': products!.map((product) => product.name).toList(),
      // 'subtotal': subtotal!,
      // 'deliveryFee': deliveryFee!,
      // 'total': total!,
      'cart': cart.toDocument(),
      'paymentMethod': paymentMethod.name,
      'paymentMethodId': paymentMethodId ?? '',
      'isPaymentSuccessful': isPaymentSuccessful,
    };
  }

  static Checkout fromJson(
    Map<String, dynamic> json, [
    String? id,
  ]) {
    Checkout checkout = Checkout(
      id: id ?? json['id'],
      user: User.fromJson(json['user']),
      cart: Cart.fromJson(json['cart']),
      paymentMethod: PaymentMethod.values.firstWhere(
        (value) {
          return value.toString().split('.').last == json['paymentMethod'];
        },
      ),
      paymentMethodId: json['paymentMethodId'],
      isPaymentSuccessful: json['isPaymentSuccessful'],
    );
    return checkout;
  }
}
