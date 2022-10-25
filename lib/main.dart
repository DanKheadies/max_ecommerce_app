import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:max_ecommerce_app/.env';
import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/config/config.dart';
import 'package:max_ecommerce_app/cubits/cubits.dart';
import 'package:max_ecommerce_app/firebase_options.dart';
import 'package:max_ecommerce_app/models/models.dart';
import 'package:max_ecommerce_app/repositories/repositories.dart';
import 'package:max_ecommerce_app/screens/screens.dart';
import 'package:max_ecommerce_app/simple_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Dankery',
      theme: theme(),
      debugShowCheckedModeBanner: false,
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => UserRepository(),
          ),
          RepositoryProvider(
            create: (context) => AuthRepository(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          RepositoryProvider(
            create: (context) => CheckoutRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc(
                authRepository: context.read<AuthRepository>(),
                userRepository: context.read<UserRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) => CartBloc()..add(LoadCart()),
            ),
            BlocProvider(
              create: (context) => CategoryBloc(
                categoryRepository: CategoryRepository(),
              )..add(LoadCategories()),
            ),
            // PaymentBloc must come before CheckoutBloc
            BlocProvider(
              create: (context) => PaymentBloc()
                ..add(
                  StartPayment(),
                ),
            ),
            BlocProvider(
              create: (context) => CheckoutBloc(
                authBloc: context.read<AuthBloc>(),
                cartBloc: context.read<CartBloc>(),
                paymentBloc: context.read<PaymentBloc>(),
                checkoutRepository: context.read<CheckoutRepository>(),
              ),
            ),
            // ProductBloc must come before SearchBloc
            BlocProvider(
              create: (context) => ProductBloc(
                productRepository: ProductRepository(),
              )..add(LoadProducts()),
            ),
            BlocProvider(
              create: (context) => SearchBloc(
                productBloc: context.read<ProductBloc>(),
              )..add(LoadSearch()),
            ),
            BlocProvider(
              create: (context) => WishlistBloc(
                localStorageRepository: LocalStorageRepository(),
              )..add(LoadWishlist()),
            ),
            BlocProvider(
              create: (context) => LoginCubit(
                authRepository: context.read<AuthRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) => SignUpCubit(
                authRepository: context.read<AuthRepository>(),
              ),
            ),
          ],
          child: MaterialApp(
            title: 'Dank?',
            debugShowCheckedModeBanner: false,
            theme: theme(),
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: SplashScreen.routeName,
            // initialRoute: HomeScreen.routeName,
          ),
        ),
      ),
    );
  }
}
