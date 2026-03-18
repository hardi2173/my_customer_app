import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_mapper.dart';
import '../../../data/repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final response = await _authRepository.login(
        username: event.username,
        password: event.password,
        deviceId: event.deviceId,
      );

      _authRepository.setAuthToken(response.accessToken);

      final user = UserMapper.fromModel(response.user);

      emit(
        state.copyWith(
          status: AuthStatus.success,
          user: user,
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
