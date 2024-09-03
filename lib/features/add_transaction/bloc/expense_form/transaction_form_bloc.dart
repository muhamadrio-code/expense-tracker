import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/add_transaction/models/form_data.dart';
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

final class DeleteValueEvent extends TransactionFormEvent {}

final class RequestDecimalValueEvent extends TransactionFormEvent {}

final class SubmitValueEvent extends TransactionFormEvent {}

final class AddCreatedDateEvent extends TransactionFormEvent {
  AddCreatedDateEvent({this.createdDate});
  final DateTime? createdDate;

  @override
  List<Object?> get props => [createdDate];
}

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
  }) {
    return TransactionFormState._(
        data: data.copyWith(
            value: value,
            formattedValue: formattedValue,
            createdDate: createdDate),
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [data, error];
}

final class TransactionFormBloc
    extends Bloc<TransactionFormEvent, TransactionFormState> {
  TransactionFormBloc({required NumberFormat formatter})
      : _numberFormat = formatter,
        super(const TransactionFormState.initial()) {
    _numberFormat.minimumFractionDigits = 0;
    on<AddValueEvent>(_onAddValueEventHandler);
    on<DeleteValueEvent>(_onDeleteValueEventHandler);
    on<SubmitValueEvent>(_onSubmitValueEventHandler);
    on<RequestDecimalValueEvent>(_onRequestDecimalValueEventHandler);
    on<AddCreatedDateEvent>(_onAddCreatedDateEvent);

    //!Make sure this event handler at the very bottom.
    on<TransactionFormEvent>(_onTransactionFormEventHandler);
  }

  final NumberFormat _numberFormat;

  void _onAddValueEventHandler(
    AddValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    var newValue = "${state.data.value}${event.value}";

    if (state.data.value == "0") {
      newValue = event.value == "00" ? "0" : event.value;
    }
    final dotIndex = newValue.indexOf(".");
    final isDecimal = dotIndex >= 0;
    final digits = requireNotNull(_numberFormat.decimalDigits);
    final isMaxLengthReached = newValue.length > constants.MAX_STRING_LENGTH;

    if (event.value == "00" && isDecimal ||
        event.value == "00" && isMaxLengthReached) {
      emit(state);
      return;
    }

    if (!isDecimal && isMaxLengthReached) {
      newValue =
          "${state.data.value.substring(0, min(state.data.value.length - 1, constants.MAX_STRING_LENGTH - event.value.length))}${event.value}";
    }

    if (isDecimal && state.data.value.substring(dotIndex).length > digits) {
      newValue =
          "${state.data.value.substring(0, state.data.value.length - 1)}${event.value}";
    }

    emit(state.copyWith(value: newValue));
  }

  void _onDeleteValueEventHandler(
    DeleteValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    if (state.data.value == "0") return;
    if (state.data.value.length == 1) {
      emit(state.copyWith(value: "0"));
      return;
    }
    emit(state.copyWith(
      value: state.data.value.substring(0, state.data.value.length - 1),
    ));
  }

  void _onSubmitValueEventHandler(
    SubmitValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    final createdDate = state.data.createdDate ?? DateTime.now();
    final hasValue = state.data.value != "0";
    if (!hasValue) {
      emit(const TransactionFormState.error("Masukkan jumlah"));
    } else {
      emit(state.copyWith(createdDate: createdDate));
    }

    print(state);
  }

  void _onRequestDecimalValueEventHandler(
    RequestDecimalValueEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    if (!state.data.value.contains(".")) {
      final value = "${state.data.value}.";
      final formattedValue = "${state.data.formattedValue}.";
      emit(state.copyWith(value: value, formattedValue: formattedValue));
    }
  }

  FutureOr<void> _onTransactionFormEventHandler(
    TransactionFormEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    if (event is AddValueEvent || event is DeleteValueEvent) {
      final value = state.data.value;
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

  FutureOr<void> _onAddCreatedDateEvent(
    AddCreatedDateEvent event,
    Emitter<TransactionFormState> emit,
  ) {
    emit(state.copyWith(createdDate: event.createdDate));
  }
}
