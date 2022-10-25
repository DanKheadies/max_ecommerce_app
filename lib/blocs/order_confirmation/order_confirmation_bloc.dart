import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:max_ecommerce_app/repositories/checkout/checkout_repository.dart';
import 'package:meta/meta.dart';

import 'package:max_ecommerce_app/models/models.dart';

part 'order_confirmation_event.dart';
part 'order_confirmation_state.dart';

class OrderConfirmationBloc
    extends Bloc<OrderConfirmationEvent, OrderConfirmationState> {
  final CheckoutRepository _checkoutRepository;

  OrderConfirmationBloc({
    required CheckoutRepository checkoutRepository,
  })  : _checkoutRepository = checkoutRepository,
        super(OrderConfirmationLoading()) {
    on<LoadOrderConfirmation>(_onLoadOrderConfirmation);
  }

  void _onLoadOrderConfirmation(
    LoadOrderConfirmation event,
    Emitter<OrderConfirmationState> emit,
  ) async {
    Checkout checkout = await _checkoutRepository.getCheckout(event.checkoutId);
    emit(
      OrderConfirmationLoaded(
        checkout: checkout,
      ),
    );
  }
}
