import 'package:equatable/equatable.dart';

import '../../../data/models/account_detail_model.dart';

enum AccountStatus { initial, loading, success, failure }

class AccountState extends Equatable {
  final AccountStatus status;
  final AccountDetailModel? account;
  final String? errorMessage;

  const AccountState({
    this.status = AccountStatus.initial,
    this.account,
    this.errorMessage,
  });

  AccountState copyWith({
    AccountStatus? status,
    AccountDetailModel? account,
    String? errorMessage,
  }) {
    return AccountState(
      status: status ?? this.status,
      account: account ?? this.account,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, account, errorMessage];
}
