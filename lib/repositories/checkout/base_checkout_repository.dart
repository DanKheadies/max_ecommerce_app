import 'package:max_ecommerce_app/models/models.dart';

abstract class BaseCheckoutRepository {
  Future<String> addCheckout(Checkout checkout);
  Future<Checkout> getCheckout(String checkoutId);
}
