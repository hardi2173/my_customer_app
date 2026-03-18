import 'package:equatable/equatable.dart';

import '../../../data/models/register_model.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final RegisterRequestModel request;

  const RegisterSubmitted({required this.request});

  @override
  List<Object?> get props => [request];
}

class RegisterReset extends RegisterEvent {
  const RegisterReset();
}
