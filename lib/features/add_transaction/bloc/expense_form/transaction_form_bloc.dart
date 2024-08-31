import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:expense_tracker/shared/constants.dart' as constants;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

sealed class TransactionFormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddValueEvent extends TransactionFormEvent {
  final int value;
  AddValueEvent({required this.value});

  @override
  List<Object?> get props => [value];
}

class GetFormattedValueEvent extends TransactionFormEvent {
  final String formattedValue;
  GetFormattedValueEvent({required this.formattedValue});

  @override
  List<Object?> get props => [formattedValue];
}

class DeleteValueEvent extends TransactionFormEvent {}

class RequestDecimalValueEvent extends TransactionFormEvent {}

class SubmitValueEvent extends TransactionFormEvent {}

final class TransactionFormState extends Equatable {
  final int value;
  final String formattedValue;

  const TransactionFormState._({
    required this.value,
    required this.formattedValue,
  });

  const TransactionFormState._opt({
    int? value,
    String? formattedValue,
  }) : this._(
          value: value ?? 0,
          formattedValue: formattedValue ?? "0",
        );

  const TransactionFormState.initial() : this._opt();

  const TransactionFormState.commitValue({
    int value = 0,
    String formattedValue = "",
  }) : this._opt(
          value: value,
          formattedValue: formattedValue,
        );

  const TransactionFormState.commitDecimalValue({
    int value = 0,
    String formattedValue = "",
  }) : this._opt(
          value: value,
          formattedValue: formattedValue,
        );

  const TransactionFormState.requestFormattedValue(String formattedValue)
      : this._opt(formattedValue: formattedValue);

  TransactionFormState copyWith({
    int? value,
    String? formattedValue,
  }) {
    return TransactionFormState._(
      value: value ?? this.value,
      formattedValue: formattedValue ?? this.formattedValue,
    );
  }

  @override
  List<Object?> get props => [value, formattedValue];
}

class TransactionFormBloc
    extends Bloc<TransactionFormEvent, TransactionFormState> {
  TransactionFormBloc({required NumberFormat formatter})
      : _numberFormat = formatter,
        super(const TransactionFormState.initial()) {
    formatter.maximumFractionDigits = 0;
    on<AddValueEvent>(_onAddValueEventHandler);
    on<DeleteValueEvent>(_onDeleteValueEventHandler);
    on<GetFormattedValueEvent>(_onGetFormattedValueEventHandler);
    on<SubmitValueEvent>(_onSubmitValueEventHandler);
    on<RequestDecimalValueEvent>(_onRequestDecimalValueEventHandler);
  }

  final NumberFormat _numberFormat;

  FutureOr<void> _onAddValueEventHandler(
    AddValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    bool isDecimal = _numberFormat.minimumFractionDigits > 0;
    int currDecimalDigits = _numberFormat.maximumFractionDigits;
    int decimalDigits = _numberFormat.decimalDigits ?? 0;

    int x = state.value * 10;
    int v = event.value % 10;
    int z = pow(10, currDecimalDigits).toInt();

    int newValue;
    if (x < constants.MAX_TRANSACTION && !isDecimal) {
      newValue = x + v;
    } else if (x > constants.MAX_TRANSACTION && !isDecimal) {
      newValue = (state.value ~/ 10) * 10 + v;
    } else if (x < constants.MAX_TRANSACTION * z && isDecimal) {
      newValue = (state.value * 10) + v;
    } else {
      newValue = (state.value ~/ 10) * 10 + v;
    }

    emit(TransactionFormState.commitValue(
      value: newValue,
      formattedValue: _numberFormat.format(newValue / z),
    ));

    if (isDecimal && currDecimalDigits < decimalDigits) {
      _numberFormat.maximumFractionDigits =
          min(decimalDigits, currDecimalDigits + 1);
      _numberFormat.minimumFractionDigits =
          min(decimalDigits, currDecimalDigits + 1);
    }
  }

  FutureOr<void> _onGetFormattedValueEventHandler(
    GetFormattedValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    emit(TransactionFormState.requestFormattedValue(state.formattedValue));
  }

  FutureOr<void> _onDeleteValueEventHandler(
    DeleteValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    if (_numberFormat.minimumFractionDigits > 0) {
      int min = _numberFormat.minimumFractionDigits;
      _numberFormat.maximumFractionDigits = min - 1;
      _numberFormat.minimumFractionDigits = min - 1;
    }

    int z = pow(10, _numberFormat.minimumFractionDigits).toInt();
    int newValue = state.value ~/ 10;
    emit(TransactionFormState.commitValue(
      value: newValue,
      formattedValue: _numberFormat.format(newValue / z),
    ));
  }

  FutureOr<void> _onSubmitValueEventHandler(
    SubmitValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    print(state);
    // close();
  }

  FutureOr<void> _onRequestDecimalValueEventHandler(
    RequestDecimalValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    _numberFormat.maximumFractionDigits = 1;
    _numberFormat.minimumFractionDigits = 1;

    emit(TransactionFormState.commitDecimalValue(
      value: state.value,
      formattedValue: _numberFormat.format(state.value),
    ));
  }
}
