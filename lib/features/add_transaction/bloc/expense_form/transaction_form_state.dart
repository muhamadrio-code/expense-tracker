part of 'transaction_form_bloc.dart';

final class TransactionFormState extends Equatable {
  final FormData data;
  final String? error;

  const TransactionFormState._({
    this.data = const FormData.empty(),
    this.error,
  });

  const TransactionFormState.initial() : this._();
  const TransactionFormState.error(String error) : this._(error: error);

  TransactionFormState copyWith({
    String? value,
    String? formattedValue,
    DateTime? createdDate,
    String? error,
    List<String>? images,
  }) {
    return TransactionFormState._(
      data: data.copyWith(
        value: value,
        formattedValue: formattedValue,
        createdDate: createdDate,
        images: images,
      ),
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, error];
}
