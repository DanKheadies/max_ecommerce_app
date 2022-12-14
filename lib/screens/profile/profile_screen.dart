import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:max_ecommerce_app/blocs/blocs.dart';
import 'package:max_ecommerce_app/repositories/repositories.dart';
import 'package:max_ecommerce_app/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(
        name: routeName,
      ),
      // builder: (context) => BlocProvider(
      builder: (context) => BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(
          authBloc: context.read<AuthBloc>(),
          userRepository: context.read<UserRepository>(),
        )..add(
            LoadProfile(
              context.read<AuthBloc>().state.authUser,
            ),
          ),
        child: const ProfileScreen(),
      ),
    );
  }

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Profile',
      ),
      bottomNavigationBar: const CustomNavBar(
        screen: routeName,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          if (state is ProfileLoaded) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CUSOMTER INFORMATION',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    title: 'Email',
                    initialValue: state.user.email,
                    onChanged: (value) {
                      context.read<ProfileBloc>().add(
                            UpdateProfile(
                              user: state.user.copyWith(
                                email: value,
                              ),
                            ),
                          );
                    },
                  ),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    title: 'Full Name',
                    initialValue: state.user.fullName,
                    onChanged: (value) {
                      context.read<ProfileBloc>().add(
                            UpdateProfile(
                              user: state.user.copyWith(
                                fullName: value,
                              ),
                            ),
                          );
                    },
                  ),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    title: 'Address',
                    initialValue: state.user.address,
                    onChanged: (value) {
                      context.read<ProfileBloc>().add(
                            UpdateProfile(
                              user: state.user.copyWith(
                                address: value,
                              ),
                            ),
                          );
                    },
                  ),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    title: 'City',
                    initialValue: state.user.city,
                    onChanged: (value) {
                      context.read<ProfileBloc>().add(
                            UpdateProfile(
                              user: state.user.copyWith(
                                city: value,
                              ),
                            ),
                          );
                    },
                  ),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    title: 'Country',
                    initialValue: state.user.country,
                    onChanged: (value) {
                      context.read<ProfileBloc>().add(
                            UpdateProfile(
                              user: state.user.copyWith(
                                country: value,
                              ),
                            ),
                          );
                    },
                  ),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    title: 'ZIP Code',
                    initialValue: state.user.zipCode,
                    onChanged: (value) {
                      context.read<ProfileBloc>().add(
                            UpdateProfile(
                              user: state.user.copyWith(
                                zipCode: value,
                              ),
                            ),
                          );
                    },
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthRepository>().signOut();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: Colors.black,
                        fixedSize: const Size(200, 40),
                      ),
                      child: Text(
                        'Sign Out',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is ProfileUnauthenticated) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'You\'re not logged in.',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign-up');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    backgroundColor: Colors.white,
                    fixedSize: const Size(200, 40),
                  ),
                  child: Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('Something went wrong.'),
            );
          }
        },
      ),
    );
  }
}
