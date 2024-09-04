part of "category_bloc.dart";

class CategoryBlocState extends Equatable {
  final CategoryType categoryType;
  final int categoryIndex;
  final String categoryName;

  const CategoryBlocState._({
    this.categoryType = CategoryType.expense,
    this.categoryIndex = -1,
    this.categoryName = "",
  });

  const CategoryBlocState.unknown() : this._();

  CategoryBlocState.onCategoryChange(Category category)
      : this._(categoryIndex: category.index, categoryType: category.type);

  const CategoryBlocState.onCategoryTypeChange(CategoryType categoryType)
      : this._(categoryType: categoryType);

  @override
  List<Object?> get props => [categoryType, categoryIndex];
}
