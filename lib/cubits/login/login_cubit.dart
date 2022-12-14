import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:max_ecommerce_app/repositories/repositories.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(LoginState.initial());

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: LoginStatus.initial,
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        status: LoginStatus.initial,
      ),
    );
  }

  Future<void> logInWithCredentials() async {
    if (state.status == LoginStatus.submitting) return;
    emit(
      state.copyWith(
        status: LoginStatus.submitting,
      ),
    );
    try {
      await _authRepository.logInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(
        state.copyWith(
          status: LoginStatus.success,
        ),
      );
    } catch (_) {}
  }

  Future<void> logInWithGoogles() async {
    if (state.status == LoginStatus.submitting) return;
    emit(
      state.copyWith(
        status: LoginStatus.submitting,
      ),
    );
    try {
      await _authRepository.logInWithGoogles();

      emit(
        state.copyWith(
          status: LoginStatus.success,
        ),
      );
      // TODO: update UI by refreshing or navigating and/or snackbar
    } catch (_) {}
  }
}
