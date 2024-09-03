part of "transaction_form_bloc.dart";

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

final class AddImageEvent extends TransactionFormEvent {
  AddImageEvent._({required this.images, this.error});

  AddImageEvent.success(List<String> images) : this._(images: images);
  AddImageEvent.error(Exception exception)
      : this._(images: [], error: exception);

  final List<String> images;
  final Exception? error;

  @override
  List<Object?> get props => [images, error];
}

final class DeleteImageEvent extends TransactionFormEvent {
  DeleteImageEvent({required this.index});
  final int index;

  @override
  List<Object?> get props => [index];
}
