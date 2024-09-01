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
  final int maxValue;
  final int decimalDigits;
  final String formattedValue;

  const TransactionFormState._({
    required this.value,
    required this.maxValue,
    required this.decimalDigits,
    required this.formattedValue,
  });

  const TransactionFormState.initial()
      : this._(
          value: 0,
          maxValue: constants.MAX_TRANSACTION,
          decimalDigits: 0,
          formattedValue: "0",
        );

  TransactionFormState copyWith({
    int? value,
    int? maxValue,
    int? decimalDigits,
    String? formattedValue,
  }) {
    return TransactionFormState._(
      value: value ?? this.value,
      maxValue: maxValue ?? this.maxValue,
      decimalDigits: decimalDigits ?? this.decimalDigits,
      formattedValue: formattedValue ?? this.formattedValue,
    );
  }

  @override
  List<Object?> get props => [value, formattedValue, maxValue, decimalDigits];
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
    int currDecimalDigits = _numberFormat.minimumFractionDigits;
    int decimalDigits = _numberFormat.decimalDigits ?? 0;

    int x = state.value * 10;
    int v = event.value % 10;
    int z = pow(10, currDecimalDigits).toInt();

    int newValue = state.value;
    if (x < state.maxValue && !isDecimal) {
      newValue = x + v;
    } else if (x < state.maxValue * z && isDecimal) {
      newValue = (state.value * 10) + v;
    } else {
      newValue = (state.value ~/ 10) * 10 + v;
    }

    emit(state.copyWith(
      value: newValue,
      formattedValue: _numberFormat.format(newValue / z),
      decimalDigits: currDecimalDigits,
    ));

    if (isDecimal && currDecimalDigits < decimalDigits) {
      _numberFormat.minimumFractionDigits =
          min(decimalDigits, currDecimalDigits + 1);
    }
  }

  FutureOr<void> _onGetFormattedValueEventHandler(
    GetFormattedValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    emit(state.copyWith(formattedValue: state.formattedValue));
  }

  FutureOr<void> _onDeleteValueEventHandler(
    DeleteValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    int requiredDigits = _numberFormat.decimalDigits ?? 0;
    int preDecimalDigits = state.decimalDigits;
    if (preDecimalDigits == requiredDigits) {
      _numberFormat.minimumFractionDigits = preDecimalDigits - 1;
    } else {
      _numberFormat.minimumFractionDigits = 0;
    }

    int postDecimalDigits = _numberFormat.minimumFractionDigits;
    int z = pow(10, postDecimalDigits).toInt();
    int newValue = state.value ~/ 10;

    emit(state.copyWith(
      value: newValue,
      formattedValue: _numberFormat.format(newValue / z),
      decimalDigits: postDecimalDigits,
      maxValue:
          postDecimalDigits == 0 ? constants.MAX_TRANSACTION : state.maxValue,
    ));

    if (postDecimalDigits < requiredDigits &&
        preDecimalDigits == requiredDigits) {
      _numberFormat.minimumFractionDigits =
          max(requiredDigits, postDecimalDigits + 1);
    }
  }

  FutureOr<void> _onSubmitValueEventHandler(
    SubmitValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    throw UnimplementedError();
  }

  FutureOr<void> _onRequestDecimalValueEventHandler(
    RequestDecimalValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    int? newMaxValue;
    if (_numberFormat.minimumFractionDigits == 0) {
      _numberFormat.minimumFractionDigits = 1;

      newMaxValue = 10;
      while (state.value ~/ newMaxValue! > 0) {
        newMaxValue *= 10;
      }
    }

    emit(state.copyWith(
      formattedValue: _numberFormat.format(state.value),
      maxValue: newMaxValue ?? state.maxValue,
      decimalDigits: _numberFormat.minimumFractionDigits,
    ));
  }
}
