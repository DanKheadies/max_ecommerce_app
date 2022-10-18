import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/models/models.dart';
import 'package:max_ecommerce_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(
        name: routeName,
      ),
      builder: (_) => const HomeScreen(),
    );
  }

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'The Dankery',
        hideBack: true,
      ),
      bottomNavigationBar: const CustomNavBar(screen: '/'),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeroCarousel(),
            SearchBox(),
            SectionTitle(
              title: 'RECOMMENDED',
            ),
            ProductCarousel(
              isPopular: false,
            ),
            SectionTitle(
              title: 'MOST POPULAR',
            ),
            ProductCarousel(
              isPopular: true,
            ),
          ],
        ),
      ),
    );
  }
}
