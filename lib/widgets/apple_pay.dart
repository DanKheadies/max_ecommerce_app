import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

import 'package:max_ecommerce_app/models/models.dart';

class ApplePay extends StatelessWidget {
  final String total;
  final List<Product> products;

  const ApplePay({
    Key? key,
    required this.total,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var paymentItems = products
        .map(
          (product) => PaymentItem(
            label: product.name,
            amount: product.price.toString(),
            type: PaymentItemType.item,
            status: PaymentItemStatus.final_price,
          ),
        )
        .toList();

    paymentItems.add(
      PaymentItem(
        label: 'Total',
        amount: total,
        type: PaymentItemType.total,
        status: PaymentItemStatus.final_price,
      ),
    );

    void onApplePayResult(paymentResult) {
      debugPrint(paymentResult.toString());
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width - 50,
      child: ApplePayButton(
        paymentConfigurationAsset: 'payment_profile_apple_pay.json',
        onPaymentResult: onApplePayResult,
        paymentItems: paymentItems,
        style: ApplePayButtonStyle.white,
        type: ApplePayButtonType.inStore,
        margin: const EdgeInsets.only(top: 10),
        loadingIndicator: const CircularProgressIndicator(),
      ),
    );
  }
}
