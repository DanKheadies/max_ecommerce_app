import 'package:max_ecommerce_app/models/models.dart';

abstract class BaseProductRepository {
  Stream<List<Product>> getAllProducts();
}
