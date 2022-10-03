import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/config/config.dart';
import 'package:max_ecommerce_app/firebase_options.dart';
import 'package:max_ecommerce_app/repositories/repositories.dart';
import 'package:max_ecommerce_app/screens/screens.dart';
import 'package:max_ecommerce_app/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CartBloc()..add(StartCart()),
        ),
        BlocProvider(
          create: (_) => CategoryBloc(
            categoryRepository: CategoryRepository(),
          )..add(LoadCategories()),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(
            cartBloc: context.read<CartBloc>(),
            checkoutRepository: CheckoutRepository(),
          ),
        ),
        BlocProvider(
          create: (_) => ProductBloc(
            productRepository: ProductRepository(),
          )..add(LoadProducts()),
        ),
        BlocProvider(
          create: (_) => WishlistBloc()..add(StartWishlist()),
        ),
      ],
      child: MaterialApp(
        title: 'The Dankery',
        theme: theme(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        // initialRoute: SplashScreen.routeName,
        initialRoute: HomeScreen.routeName,
      ),
    );
  }
}
