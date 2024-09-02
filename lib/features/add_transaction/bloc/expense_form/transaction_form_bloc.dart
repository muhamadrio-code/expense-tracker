import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:expense_tracker/shared/constants.dart' as constants;
import 'package:expense_tracker/shared/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

sealed class TransactionFormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AddValueEvent extends TransactionFormEvent {
  final String value;
  AddValueEvent({required this.value});

  @override
  List<Object?> get props => [value];
}

final class GetFormattedValueEvent extends TransactionFormEvent {
  final String formattedValue;
  GetFormattedValueEvent({required this.formattedValue});

  @override
  List<Object?> get props => [formattedValue];
}

final class DeleteValueEvent extends TransactionFormEvent {}

final class RequestDecimalValueEvent extends TransactionFormEvent {}

final class SubmitValueEvent extends TransactionFormEvent {}

final class TransactionFormState extends Equatable {
  final String value;
  final String formattedValue;

  const TransactionFormState._({
    required this.value,
    required this.formattedValue,
  });

  const TransactionFormState.initial()
      : this._(
          value: "0",
          formattedValue: "0",
        );

  TransactionFormState copyWith({
    String? value,
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

final class TransactionFormBloc
    extends Bloc<TransactionFormEvent, TransactionFormState> {
  TransactionFormBloc({required NumberFormat formatter})
      : _numberFormat = formatter,
        super(const TransactionFormState.initial()) {
    _numberFormat.minimumFractionDigits = 0;
    on<AddValueEvent>(_onAddValueEventHandler);
    on<DeleteValueEvent>(_onDeleteValueEventHandler);
    on<GetFormattedValueEvent>(_onGetDoubleValueEventHandler);
    on<SubmitValueEvent>(_onSubmitValueEventHandler);
    on<RequestDecimalValueEvent>(_onRequestDecimalValueEventHandler);
    on<TransactionFormEvent>(_onTransactionFormEventHandler);
  }

  final NumberFormat _numberFormat;

  void _onAddValueEventHandler(
    AddValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    var newValue = "${state.value}${event.value}";
    if (state.value == "0") {
      newValue = event.value == "00" ? "0" : event.value;
    }
    final dotIndex = newValue.indexOf(".");
    final isDecimal = dotIndex >= 0;
    final isMaxDecimalDigits = isDecimal &&
        state.value.substring(dotIndex).length >
            (requireNotNull(_numberFormat.decimalDigits));

    final isMaxLength =
        !isDecimal && newValue.length > constants.MAX_STRING_LENGTH;

    if (isMaxDecimalDigits || isMaxLength) {
      newValue =
          "${state.value.substring(0, min(state.value.length - 1, constants.MAX_STRING_LENGTH - event.value.length))}${event.value}";
    }

    emit(state.copyWith(value: newValue));
  }

  void _onGetDoubleValueEventHandler(
    GetFormattedValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {}

  void _onDeleteValueEventHandler(
    DeleteValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    if (state.value == "0") return;
    if (state.value.length == 1) {
      emit(state.copyWith(value: "0"));
      return;
    }
    emit(state.copyWith(
      value: state.value.substring(0, state.value.length - 1),
    ));
  }

  void _onSubmitValueEventHandler(
    SubmitValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    throw UnimplementedError();
  }

  void _onRequestDecimalValueEventHandler(
    RequestDecimalValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    if (!state.value.contains(".")) {
      final value = "${state.value}.";
      final formattedValue = "${state.formattedValue}.";
      emit(state.copyWith(value: value, formattedValue: formattedValue));
    }
  }

  FutureOr<void> _onTransactionFormEventHandler(
    TransactionFormEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    if (event is AddValueEvent || event is DeleteValueEvent) {
      final value = state.value;
      final dotIndex = value.indexOf(".");
      final isDecimal = dotIndex >= 0;
      final intValue = isDecimal
          ? int.parse(value.substring(0, dotIndex))
          : int.parse(value);

      final digits = isDecimal ? value.substring(dotIndex) : "";
      final formattedValue = _numberFormat.format(intValue) + digits;
      emit(state.copyWith(formattedValue: formattedValue));
    }
  }
}
