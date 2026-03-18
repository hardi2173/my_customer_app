import 'package:equatable/equatable.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final String? errorMessage;
  final String? successMessage;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, successMessage];
}
