import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/models/models.dart';
import 'package:max_ecommerce_app/widgets/widgets.dart';

class ProductCarousel extends StatelessWidget {
  const ProductCarousel({
    Key? key,
    required this.isPopular,
  }) : super(key: key);

  final bool isPopular;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ProductLoaded) {
          List<Product> products = isPopular
              ? state.products.where((product) => product.isPopular).toList()
              : state.products
                  .where((product) => product.isRecommended)
                  .toList();
          products.sort((a, b) => a.name.compareTo(b.name));

          return Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 165,
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: ProductCard.catalog(
                      product: products[index],
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }
      },
    );
  }
}
