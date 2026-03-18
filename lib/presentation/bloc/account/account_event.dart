import 'package:equatable/equatable.dart';

import '../../../data/models/account_detail_model.dart';
import '../../../data/models/register_model.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class LoadAccountDetail extends AccountEvent {
  const LoadAccountDetail();
}

class UpdateProfile extends AccountEvent {
  final UpdateProfileRequest request;

  const UpdateProfile({required this.request});

  @override
  List<Object?> get props => [request];
}

class CreateAddress extends AccountEvent {
  final AddressRequest request;

  const CreateAddress({required this.request});

  @override
  List<Object?> get props => [request];
}

class UpdateAddress extends AccountEvent {
  final String id;
  final AddressRequest request;

  const UpdateAddress({required this.id, required this.request});

  @override
  List<Object?> get props => [id, request];
}

class DeleteAddress extends AccountEvent {
  final String id;

  const DeleteAddress({required this.id});

  @override
  List<Object?> get props => [id];
}

class CreateContact extends AccountEvent {
  final ContactRequest request;

  const CreateContact({required this.request});

  @override
  List<Object?> get props => [request];
}

class UpdateContact extends AccountEvent {
  final String id;
  final ContactRequest request;

  const UpdateContact({required this.id, required this.request});

  @override
  List<Object?> get props => [id, request];
}

class DeleteContact extends AccountEvent {
  final String id;

  const DeleteContact({required this.id});

  @override
  List<Object?> get props => [id];
}
