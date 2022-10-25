import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/models/models.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int? quantity;
  final double widthFactor;
  final double height;
  final String subType;
  final Color iconColor;
  final Color fontColor;

  const ProductCard.cart({
    Key? key,
    required this.product,
    this.quantity,
    this.widthFactor = 2.2, // 1.1  or 1.5
    this.height = 80,
    this.subType = 'cart',
    this.iconColor = Colors.black,
    this.fontColor = Colors.black,
  }) : super(key: key);

  const ProductCard.catalog({
    Key? key,
    required this.product,
    this.quantity,
    this.widthFactor = 2.25, // 2.5
    this.height = 150,
    this.subType = 'catalog',
    this.iconColor = Colors.white,
    this.fontColor = Colors.white,
  }) : super(key: key);

  const ProductCard.summary({
    Key? key,
    required this.product,
    this.quantity,
    this.widthFactor = 2.25, // 2.5
    this.height = 80,
    this.subType = 'summary',
    this.iconColor = Colors.black,
    this.fontColor = Colors.black,
  }) : super(key: key);

  const ProductCard.wishlist({
    Key? key,
    required this.product,
    this.quantity,
    this.widthFactor = 1.1,
    this.height = 150,
    this.subType = 'wishlist',
    this.iconColor = Colors.white,
    this.fontColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double adjWidth = width / widthFactor;

    return InkWell(
      onTap: () {
        if (subType == 'catalog' || subType == 'wishlist') {
          Navigator.pushNamed(
            context,
            '/product',
            arguments: product,
          );
        }
      },
      child: subType == 'cart' || subType == 'summary'
          ? Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  ProductImage(
                    // width: adjWidth,
                    width: 100,
                    product: product,
                    height: height,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ProductInformation(
                      product: product,
                      fontColor: fontColor,
                      quantity: quantity,
                      subType: subType,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ProductActions(
                    product: product,
                    quantity: quantity,
                    subType: subType,
                    iconColor: iconColor,
                  ),
                ],
              ),
            )
          : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ProductImage(
                  height: height,
                  width: adjWidth,
                  product: product,
                ),
                ProductBackground(
                  adjWidth: adjWidth,
                  widgets: [
                    Expanded(
                      flex: 3,
                      child: ProductInformation(
                        product: product,
                        fontColor: fontColor,
                        subType: subType,
                      ),
                    ),
                    ProductActions(
                      product: product,
                      subType: subType,
                      iconColor: iconColor,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class ProductActions extends StatelessWidget {
  const ProductActions({
    Key? key,
    required this.product,
    required this.subType,
    required this.iconColor,
    this.quantity,
  }) : super(key: key);

  final Product product;
  final String subType;
  final Color iconColor;
  final int? quantity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(
            child: CircularProgressIndicator(
                // color: Colors.white,
                ),
          );
        }
        if (state is CartLoaded) {
          IconButton addProduct = IconButton(
            icon: Icon(
              Icons.add_circle,
              color: iconColor,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to your Cart!'),
                ),
              );
              context.read<CartBloc>().add(AddProductToCart(product));
            },
          );

          IconButton removeProduct = IconButton(
            icon: Icon(
              Icons.remove_circle,
              color: iconColor,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Removed from your Cart!'),
                ),
              );
              context.read<CartBloc>().add(RemoveProductFromCart(product));
            },
          );

          IconButton removeFromWishlist = IconButton(
            icon: Icon(
              Icons.delete,
              color: iconColor,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Removed from your Wishlist!'),
                ),
              );
              context
                  .read<WishlistBloc>()
                  .add(RemoveProductFromWishlist(product));
            },
          );

          Text productQuantity = Text(
            '$quantity',
            style: Theme.of(context).textTheme.headline4,
          );

          if (subType == 'cart') {
            return Row(
              children: [
                removeProduct,
                productQuantity,
                addProduct,
              ],
            );
          } else if (subType == 'catalog') {
            return Row(
              children: [
                addProduct,
              ],
            );
          } else if (subType == 'wishlist') {
            return Row(
              children: [
                addProduct,
                removeFromWishlist,
              ],
            );
          } else {
            return const SizedBox();
          }
        } else {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }
      },
    );
  }
}

class ProductInformation extends StatelessWidget {
  const ProductInformation({
    Key? key,
    required this.product,
    required this.fontColor,
    required this.subType,
    this.quantity,
  }) : super(key: key);

  final Product product;
  final Color fontColor;
  final String subType;
  final int? quantity;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: fontColor,
              ),
        ),
        Row(
          children: [
            subType == 'summary'
                ? Text(
                    'Qty. $quantity @ ',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: fontColor,
                        ),
                  )
                : const SizedBox(),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: fontColor,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({
    Key? key,
    required this.height,
    required this.width,
    required this.product,
  }) : super(key: key);

  final double height;
  final double width;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(bottom: 10),
      child: Image.network(
        product.imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ProductBackground extends StatelessWidget {
  const ProductBackground({
    Key? key,
    required this.adjWidth,
    required this.widgets,
  }) : super(key: key);

  final double adjWidth;
  final List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: adjWidth - 10,
      height: 80,
      margin: const EdgeInsets.only(bottom: 15),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(50),
      ),
      child: Container(
        width: adjWidth - 20,
        height: 70,
        margin: const EdgeInsets.only(bottom: 5),
        alignment: Alignment.bottomCenter,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...widgets,
            ],
          ),
        ),
      ),
    );
  }
}
