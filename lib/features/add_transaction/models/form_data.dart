import 'package:equatable/equatable.dart';

final class FormData extends Equatable {
  const FormData({
    required this.value,
    required this.formattedValue,
    this.createdDate,
  });

  final String value;
  final String formattedValue;
  final DateTime? createdDate;

  const FormData.empty() : this(value: "0", formattedValue: "0");

  FormData copyWith({
    String? value,
    String? formattedValue,
    DateTime? createdDate,
  }) =>
      FormData(
        value: value ?? this.value,
        formattedValue: formattedValue ?? this.formattedValue,
        createdDate: createdDate ?? this.createdDate,
      );

  @override
  List<Object?> get props => [value, formattedValue, createdDate];
}
