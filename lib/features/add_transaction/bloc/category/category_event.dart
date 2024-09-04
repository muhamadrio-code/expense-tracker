part of 'category_bloc.dart';

sealed class CategoryBlocEvent {}

class CategoryTypeChangeEvent extends CategoryBlocEvent {
  final int index;
  CategoryTypeChangeEvent({required this.index});
}

class SelectCategoryEvent extends CategoryBlocEvent {
  final Category category;
  SelectCategoryEvent({required this.category});
}
