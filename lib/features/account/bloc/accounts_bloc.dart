import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/account/models/account.dart';
import 'package:expense_tracker/features/account/models/account_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsState extends Equatable {
  final List<Account> accounts;
  final String? error;
  final bool isError;

  const AccountsState._({required this.accounts, this.error})
      : isError = error == null;

  const AccountsState.initial()
      : this._(accounts: const [
          Account(
            name: "Account index",
            accountType: AccountType.card,
            currency: "IDR",
            amount: "500000",
            notes: "notes",
          ),
          Account(
            name: "Account index",
            accountType: AccountType.card,
            currency: "IDR",
            amount: "500000",
            notes: "notes",
          ),
          Account(
            name: "Account index",
            accountType: AccountType.card,
            currency: "IDR",
            amount: "500000",
            notes: "notes",
          ),
          Account(
            name: "Account index",
            accountType: AccountType.card,
            currency: "IDR",
            amount: "500000",
            notes: "notes",
          ),
          Account(
            name: "Account index",
            accountType: AccountType.card,
            currency: "IDR",
            amount: "500000",
            notes: "notes",
          ),
        ]);
  const AccountsState.error(String error)
      : this._(accounts: const [], error: error);
  const AccountsState.success(List<Account> data) : this._(accounts: data);

  // AccountsState copyWith({List<Account> accounts = const [], String? error}) =>
  //     AccountsState._(accounts: accounts, error: error ?? this.error);

  // AccountState copyWith(
  //     {String? name,
  //     AccountType? accountType,
  //     String? currency,
  //     String? amount,
  //     String? notes,
  //     String? error}) {

  //   Account account = this.account.copyWith(
  //         name: name,
  //         accountType: accountType,
  //         currency: currency,
  //         amount: amount,
  //         notes: notes,
  //       );
  //   return AccountState._(account: account, error: error ?? this.error);
  // }

  @override
  List<Object?> get props => [accounts, error];
}

sealed class AccountsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class GetAccountsEvent extends AccountsEvent {}

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc() : super(const AccountsState.initial()) {
    on<GetAccountsEvent>(_onGetAllAccountEvent);
  }

  FutureOr<void> _onGetAllAccountEvent(
    GetAccountsEvent event,
    Emitter<AccountsState> emit,
  ) {
    List<Account> accounts = List.generate(
      5,
      (index) => Account(
        name: "Account $index",
        accountType: AccountType.card,
        currency: "IDR",
        amount: "${index * 500000}",
        notes: "notes $index",
      ),
    );

    emit(AccountsState.success(accounts));
  }
}
