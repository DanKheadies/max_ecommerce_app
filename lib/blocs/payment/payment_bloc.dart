import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'package:max_ecommerce_app/models/models.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(const PaymentState()) {
    on<StartPayment>(_onStartPayment);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<CreatePaymentIntent>(_onCreatePaymentIntent);
    on<PaymentConfirmIntent>(_onPaymentConfirmIntent);
  }

  void _onStartPayment(
    StartPayment event,
    Emitter<PaymentState> emit,
  ) {
    emit(
      state.copyWith(
        status: PaymentStatus.initial,
      ),
    );
  }

  void _onSelectPaymentMethod(
    SelectPaymentMethod event,
    Emitter<PaymentState> emit,
  ) {
    emit(
      state.copyWith(
        paymentMethod: event.paymentMethod,
        paymentMethodId: event.paymentMethodId,
      ),
    );
  }

  void _onCreatePaymentIntent(
    CreatePaymentIntent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PaymentStatus.loading,
      ),
    );

    final paymentIntentResult = await _callPayEndpointMethodId(
      useStripeSdk: true,
      paymentMethodId: event.paymentMethodId,
      currency: 'usd',
      amount: event.amount,
    );

    if (paymentIntentResult['error'] != null) {
      print(paymentIntentResult['error']);
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
        ),
      );
    }
    if (paymentIntentResult['clientSecret'] != null &&
        paymentIntentResult['requiresAction'] == null) {
      emit(
        state.copyWith(
          status: PaymentStatus.success,
        ),
      );
    }
    if (paymentIntentResult['clientSecret'] != null &&
        paymentIntentResult['requiresAction'] == true) {
      final String clientSecret = paymentIntentResult['clientSecret'];
      add(
        PaymentConfirmIntent(
          clientSecret: clientSecret,
        ),
      );
    }
  }

  void _onPaymentConfirmIntent(
    PaymentConfirmIntent event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      final paymentIntent = await stripe.Stripe.instance.handleNextAction(
        event.clientSecret,
      );

      if (paymentIntent.status ==
          stripe.PaymentIntentsStatus.RequiresConfirmation) {
        Map<String, dynamic> results = await _callPayEndpointIntentId(
          paymentIntentId: paymentIntent.id,
        );
        if (results['error'] != null) {
          emit(state.copyWith(
            status: PaymentStatus.failure,
          ));
        } else {
          emit(state.copyWith(
            status: PaymentStatus.success,
          ));
        }
      }
    } catch (e) {
      print(e);
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _callPayEndpointMethodId({
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
    required int amount,
  }) async {
    final url = Uri.parse(
        'https://us-central1-max-ecommerce-app.cloudfunctions.net/StripePayEndpointMethodId');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'useStripeSdk': useStripeSdk,
        'paymentMethodId': paymentMethodId,
        'currency': currency,
        'amount': amount,
      }),
    );
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> _callPayEndpointIntentId({
    required String paymentIntentId,
  }) async {
    final url = Uri.parse(
        'https://us-central1-max-ecommerce-app.cloudfunctions.net/StripePayEndpointIntentId');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'paymentIntentId': paymentIntentId,
      }),
    );

    return json.decode(response.body);
  }
}
