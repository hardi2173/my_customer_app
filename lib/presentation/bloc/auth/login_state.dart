import 'package:equatable/equatable.dart';

import '../../../domain/entities/user.dart';

enum AuthStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? accessToken;
  final String? refreshToken;
  final String? errorMessage;

  const LoginState({
    this.status = AuthStatus.initial,
    this.user,
    this.accessToken,
    this.refreshToken,
    this.errorMessage,
  });

  LoginState copyWith({
    AuthStatus? status,
    User? user,
    String? accessToken,
    String? refreshToken,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    accessToken,
    refreshToken,
    errorMessage,
  ];
}
