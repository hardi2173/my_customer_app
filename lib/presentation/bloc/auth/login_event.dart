import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;
  final String deviceId;

  const LoginSubmitted({
    required this.username,
    required this.password,
    required this.deviceId,
  });

  @override
  List<Object?> get props => [username, password, deviceId];
}

class LogoutRequested extends LoginEvent {
  const LogoutRequested();
}
