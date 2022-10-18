import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/models/models.dart';
import 'package:max_ecommerce_app/widgets/widgets.dart';

class SearchBox extends StatelessWidget {
  final Category? category;
  const SearchBox({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }
        if (state is SearchLoaded) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 10,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Search for a Product',
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          context.read<SearchBloc>().add(
                                SearchProduct(
                                  productName: value,
                                  category: category,
                                ),
                              );
                        },
                      ),
                    ),
                  ],
                ),
                state.products.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            child: ProductCard.catalog(
                              product: state.products[index],
                              widthFactor: 1.1,
                            ),
                          );
                        })
                    : const SizedBox()
              ],
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
