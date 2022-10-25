import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/cubits/cubits.dart';
// import 'package:max_ecommerce_app/repositories/repositories.dart';
import 'package:max_ecommerce_app/widgets/widgets.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = '/sign-up';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(
        name: routeName,
      ),
      builder: (context) => const SignUpScreen(),
    );
  }

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Sign Up',
      ),
      bottomNavigationBar: const CustomNavBar(
        screen: routeName,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<SignUpCubit, SignUpState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _UserInput(
                  onChanged: (value) {
                    context.read<SignUpCubit>().userChanged(
                          state.user!.copyWith(
                            email: value,
                          ),
                        );
                  },
                  labelText: 'Email',
                ),
                const SizedBox(height: 10),
                _UserInput(
                  onChanged: (value) {
                    context.read<SignUpCubit>().userChanged(
                          state.user!.copyWith(
                            fullName: value,
                          ),
                        );
                  },
                  labelText: 'Full Name',
                ),
                const SizedBox(height: 10),
                _UserInput(
                  onChanged: (value) {
                    context.read<SignUpCubit>().userChanged(
                          state.user!.copyWith(
                            country: value,
                          ),
                        );
                  },
                  labelText: 'Country',
                ),
                const SizedBox(height: 10),
                _UserInput(
                  onChanged: (value) {
                    context.read<SignUpCubit>().userChanged(
                          state.user!.copyWith(
                            city: value,
                          ),
                        );
                  },
                  labelText: 'City',
                ),
                const SizedBox(height: 10),
                _UserInput(
                  onChanged: (value) {
                    context.read<SignUpCubit>().userChanged(
                          state.user!.copyWith(
                            address: value,
                          ),
                        );
                  },
                  labelText: 'Address',
                ),
                const SizedBox(height: 10),
                _UserInput(
                  onChanged: (value) {
                    context.read<SignUpCubit>().userChanged(
                          state.user!.copyWith(
                            zipCode: value,
                          ),
                        );
                  },
                  labelText: 'ZIP Code',
                ),
                const SizedBox(height: 10),
                const _PasswordInput(),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    context.read<SignUpCubit>().signUpWithCredentials();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    backgroundColor: Colors.black,
                    fixedSize: const Size(200, 40),
                  ),
                  child: Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _UserInput extends StatelessWidget {
  const _UserInput({
    Key? key,
    required this.onChanged,
    required this.labelText,
  }) : super(key: key);

  final Function(String)? onChanged;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: labelText,
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return TextField(
          onChanged: (password) {
            context.read<SignUpCubit>().passwordChanged(password);
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
