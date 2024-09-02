part of 'add_transaction_page.dart';

class _TransactionCategories extends StatelessWidget {
  const _TransactionCategories();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CategoryBloc, CategoryBlocState>(
        builder: (context, state) {
          void selectCategory(
            ({int index, CategoryData categoryData}) data,
          ) {
            context.read<CategoryBloc>().add(
                  SelectCategoryEvent(
                    category: Category(
                      type: data.categoryData.type,
                      name: data.categoryData.name,
                      index: data.index,
                    ),
                  ),
                );
          }

          Widget buildCategoryWidget(
              (int, CategoryData) values, int selectedIndex) {
            return Builder(builder: (context) {
              ({int index, CategoryData categoryData}) mValues =
                  (index: values.$1, categoryData: values.$2);
              return GestureDetector(
                onTap: () => selectCategory(mValues),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: values.$1 == selectedIndex
                            ? Colors.amber
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        values.$2.iconData,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                        child: Text(
                      values.$2.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ))
                  ],
                ),
              );
            });
          }

          return GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            shrinkWrap: true,
            mainAxisSpacing: 0,
            crossAxisSpacing: 8,
            crossAxisCount: 4,
            children: (state.categoryType == CategoryType.expense
                    ? expenseCategory
                    : incomeCategory)
                .indexed
                .map<Widget>((e) => buildCategoryWidget(e, state.categoryIndex))
                .toList(),
          );
        },
      );
}
