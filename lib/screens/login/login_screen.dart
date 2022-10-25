import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/cubits/cubits.dart';
import 'package:max_ecommerce_app/repositories/repositories.dart';
import 'package:max_ecommerce_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(
        name: routeName,
      ),
      builder: (context) => const LoginScreen(),
    );
  }

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Login',
      ),
      bottomNavigationBar: const CustomNavBar(
        screen: routeName,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _EmailInput(),
            const SizedBox(height: 10),
            const _PasswordInput(),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                context.read<LoginCubit>().logInWithCredentials();
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
                backgroundColor: Colors.black,
                fixedSize: const Size(200, 40),
              ),
              child: Text(
                'Login',
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            const SizedBox(height: 10),
            const _GoogleLoginButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return TextField(
          onChanged: (email) {
            context.read<LoginCubit>().emailChanged(email);
          },
          decoration: const InputDecoration(
            labelText: 'Email',
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return TextField(
          onChanged: (password) {
            context.read<LoginCubit>().passwordChanged(password);
          },
          decoration: const InputDecoration(
            labelText: 'Password',
          ),
          obscureText: true,
        );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  const _GoogleLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<LoginCubit>().logInWithGoogles();
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(),
        backgroundColor: Colors.white,
        fixedSize: const Size(200, 40),
      ),
      child: Text(
        'Sign In with Google',
        style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Colors.black,
            ),
      ),
    );
  }
}
