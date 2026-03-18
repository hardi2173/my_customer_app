import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/auth_repository.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AuthRepository _authRepository;

  AccountBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AccountState()) {
    on<LoadAccountDetail>(_onLoadAccountDetail);
    on<UpdateProfile>(_onUpdateProfile);
    on<CreateAddress>(_onCreateAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<DeleteAddress>(_onDeleteAddress);
    on<CreateContact>(_onCreateContact);
    on<UpdateContact>(_onUpdateContact);
    on<DeleteContact>(_onDeleteContact);
  }

  Future<void> _onLoadAccountDetail(
    LoadAccountDetail event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    try {
      final account = await _authRepository.getAccountDetail();
      emit(state.copyWith(status: AccountStatus.success, account: account));
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    try {
      final account = await _authRepository.updateProfile(event.request);
      emit(state.copyWith(status: AccountStatus.success, account: account));
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onCreateAddress(
    CreateAddress event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    try {
      await _authRepository.createAddress(event.request);
      final account = await _authRepository.getAccountDetail();
      emit(state.copyWith(status: AccountStatus.success, account: account));
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onUpdateAddress(
    UpdateAddress event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    try {
      await _authRepository.updateAddress(event.id, event.request);
      final account = await _authRepository.getAccountDetail();
      emit(state.copyWith(status: AccountStatus.success, account: account));
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddress event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    try {
      await _authRepository.deleteAddress(event.id);
      final account = await _authRepository.getAccountDetail();
      emit(state.copyWith(status: AccountStatus.success, account: account));
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onCreateContact(
    CreateContact event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    try {
      await _authRepository.createContact(event.request);
      final account = await _authRepository.getAccountDetail();
      emit(state.copyWith(status: AccountStatus.success, account: account));
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onUpdateContact(
    UpdateContact event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    try {
      await _authRepository.updateContact(event.id, event.request);
      final account = await _authRepository.getAccountDetail();
      emit(state.copyWith(status: AccountStatus.success, account: account));
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onDeleteContact(
    DeleteContact event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    try {
      await _authRepository.deleteContact(event.id);
      final account = await _authRepository.getAccountDetail();
      emit(state.copyWith(status: AccountStatus.success, account: account));
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
