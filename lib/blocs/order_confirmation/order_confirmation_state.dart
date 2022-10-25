part of 'order_confirmation_bloc.dart';

@immutable
abstract class OrderConfirmationState extends Equatable {
  const OrderConfirmationState();

  @override
  List<Object> get props => [];
}

class OrderConfirmationLoading extends OrderConfirmationState {}

class OrderConfirmationLoaded extends OrderConfirmationState {
  final Checkout checkout;

  const OrderConfirmationLoaded({
    required this.checkout,
  });

  @override
  List<Object> get props => [checkout];
}
