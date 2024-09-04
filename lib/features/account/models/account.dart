import 'package:expense_tracker/features/account/models/account_type.dart';

final class Account {
  final String name;
  final AccountType accountType;
  final String currency;
  final String amount;
  final String notes;

  const Account({
    required this.name,
    required this.accountType,
    required this.currency,
    required this.amount,
    required this.notes,
  });

  const Account.initial()
      : this(
          name: "",
          accountType: AccountType.cash,
          currency: "",
          amount: "0",
          notes: "",
        );

  Account copyWith({
    String? name,
    AccountType? accountType,
    String? currency,
    String? amount,
    String? notes,
  }) =>
      Account(
        name: name ?? this.name,
        accountType: accountType ?? this.accountType,
        currency: currency ?? this.currency,
        amount: amount ?? this.amount,
        notes: notes ?? this.notes,
      );
}
