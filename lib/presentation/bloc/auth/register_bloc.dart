import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/auth_repository.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;

  RegisterBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const RegisterState()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<RegisterReset>(_onRegisterReset);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    try {
      await _authRepository.register(request: event.request);

      emit(
        state.copyWith(
          status: RegisterStatus.success,
          successMessage: 'Registration successful! Please login.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void _onRegisterReset(RegisterReset event, Emitter<RegisterState> emit) {
    emit(const RegisterState());
  }
}
