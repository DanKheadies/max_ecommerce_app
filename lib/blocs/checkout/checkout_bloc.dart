import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:max_ecommerce_app/repositories/repositories.dart';
import 'package:meta/meta.dart';

import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/models/models.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final AuthBloc _authBloc;
  final CartBloc _cartBloc;
  final PaymentBloc _paymentBloc;
  final CheckoutRepository _checkoutRepository;
  StreamSubscription? _authSubscription;
  StreamSubscription? _cartSubscription;
  // StreamSubscription? _checkoutSubscription;
  StreamSubscription? _paymentSubscription;

  CheckoutBloc({
    required AuthBloc authBloc,
    required CartBloc cartBloc,
    required CheckoutRepository checkoutRepository,
    required PaymentBloc paymentBloc,
  })  : _authBloc = authBloc,
        _cartBloc = cartBloc,
        _checkoutRepository = checkoutRepository,
        _paymentBloc = paymentBloc,
        super(cartBloc.state is CartLoaded
            ? CheckoutLoaded(
                checkout: Checkout(
                  user: authBloc.state.user,
                  cart: (cartBloc.state as CartLoaded).cart,
                ),
                // user: authBloc.state.user,
                // products: (cartBloc.state as CartLoaded).cart.products,
                // subtotal: (cartBloc.state as CartLoaded).cart.subtotalString,
                // deliveryFee:
                //     (cartBloc.state as CartLoaded).cart.deliveryFeeString,
                // total: (cartBloc.state as CartLoaded).cart.totalString,
              )
            : CheckoutLoading()) {
    on<UpdateCheckout>(_onUpdateCheckout);
    on<ConfirmCheckout>(_onConfirmCheckout);

    _authSubscription = _authBloc.stream.listen((state) {
      if (state.status == AuthStatus.unauthenticated) {
        Checkout checkout = (this.state as CheckoutLoaded).checkout.copyWith(
              user: User.empty,
            );
        add(
          // const UpdateCheckout(
          //   user: User.empty,
          // ),
          UpdateCheckout(
            checkout: checkout,
          ),
        );
      } else {
        Checkout checkout = (this.state as CheckoutLoaded).checkout.copyWith(
              user: state.user,
            );
        add(
          UpdateCheckout(
            checkout: checkout,
          ),
        );
      }
    });

    _cartSubscription = cartBloc.stream.listen((state) {
      if (state is CartLoaded) {
        Checkout checkout = (this.state as CheckoutLoaded).checkout.copyWith(
              cart: state.cart,
            );
        add(
          // const UpdateCheckout(
          //   user: User.empty,
          // ),
          UpdateCheckout(
            checkout: checkout,
          ),
        );
      }
    });

    _paymentSubscription = _paymentBloc.stream.listen((state) {
      if (state.status == PaymentStatus.initial) {
        Checkout checkout = (this.state as CheckoutLoaded).checkout.copyWith(
              paymentMethod: state.paymentMethod,
              paymentMethodId: state.paymentMethodId,
            );
        add(
          UpdateCheckout(
            checkout: checkout,
          ),
        );
      }
      if (state.status == PaymentStatus.success) {
        add(
          const ConfirmCheckout(
            isPaymentSuccessful: true,
          ),
        );
      }
    });
  }

  void _onUpdateCheckout(
    UpdateCheckout event,
    Emitter<CheckoutState> emit,
  ) {
    final state = this.state;
    if (state is CheckoutLoaded) {
      // try {
      emit(
        CheckoutLoaded(
          // email: event.email ?? state.email,
          // fullName: event.fullName ?? state.fullName,
          // user: event.user ?? state.user,
          // products: event.cart?.products ?? state.products,
          // deliveryFee: event.cart?.deliveryFeeString ?? state.deliveryFee,
          // subtotal: event.cart?.subtotalString ?? state.subtotal,
          // total: event.cart?.totalString ?? state.total,
          // address: event.address ?? state.address,
          // city: event.city ?? state.city,
          // country: event.country ?? state.country,
          // zipCode: event.zipCode ?? state.zipCode,
          // paymentMethod: event.paymentMethod ?? state.paymentMethod,
          // paymentMethodId: event.paymentMethodId ?? state.paymentMethodId,
          checkout: event.checkout,
        ),
      );
      // } catch (_) {}
    }
  }

  void _onConfirmCheckout(
    ConfirmCheckout event,
    Emitter<CheckoutState> emit,
  ) async {
    // _checkoutSubscription?.cancel();
    final state = this.state;
    if (state is CheckoutLoaded) {
      try {
        Checkout checkout = state.checkout.copyWith(
          isPaymentSuccessful: true,
        );
        String checkoutId = await _checkoutRepository.addCheckout(checkout);

        emit(
          CheckoutLoaded(
            checkout: checkout.copyWith(
              id: checkoutId,
            ),
          ),
        );
      } catch (_) {}
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _cartSubscription?.cancel();
    _paymentSubscription?.cancel();
    return super.close();
  }
}
