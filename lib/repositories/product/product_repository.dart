import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:max_ecommerce_app/models/product_model.dart';
import 'package:max_ecommerce_app/repositories/repositories.dart';

class ProductRepository extends BaseProductRepository {
  final FirebaseFirestore _firebaseFirestore;

  ProductRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Product>> getAllProducts() {
    return _firebaseFirestore
        .collection('products')
        .snapshots()
        .map((snapshot) {
      // return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      return snapshot.docs
          .map((doc) => Product.fromJson(
                doc.data(),
                doc.id,
              ))
          .toList();
    });
  }
}
