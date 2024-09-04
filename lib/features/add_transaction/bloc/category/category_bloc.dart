import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/add_transaction/repositories/add_transaction_repository.dart';
import 'package:expense_tracker/features/add_transaction/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_state.dart';
part 'category_event.dart';

class CategoryBloc extends Bloc<CategoryBlocEvent, CategoryBlocState> {
  final AddTransactionRepository _addTransactionRepository;

  CategoryBloc({required AddTransactionRepository addTransactionRepository})
      : _addTransactionRepository = addTransactionRepository,
        super(const CategoryBlocState.unknown()) {
    on<SelectCategoryEvent>(_onCategorySelectedHandler);
    on<CategoryTypeChangeEvent>(_onCategoryTypeChangeHandler);
  }

  FutureOr<void> _onCategoryTypeChangeHandler(
    CategoryTypeChangeEvent event,
    Emitter<CategoryBlocState> emit,
  ) {
    emit(CategoryBlocState.onCategoryTypeChange(
        CategoryType.values[event.index]));
    _addTransactionRepository.setCategory(Category(
      type: state.categoryType,
      name: state.categoryName,
      index: state.categoryIndex,
    ));
  }

  FutureOr<void> _onCategorySelectedHandler(
    SelectCategoryEvent event,
    Emitter<CategoryBlocState> emit,
  ) {
    emit(CategoryBlocState.onCategoryChange(event.category));
    _addTransactionRepository.setCategory(event.category);
  }
}
