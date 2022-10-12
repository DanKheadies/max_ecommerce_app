part of 'payment_bloc.dart';

@immutable
abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final PaymentMethod paymentMethod;

  const PaymentLoaded({
    this.paymentMethod = PaymentMethod.googlePay,
  });

  @override
  List<Object> get props => [paymentMethod];
}
