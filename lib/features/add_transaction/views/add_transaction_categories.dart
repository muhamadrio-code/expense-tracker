part of 'add_transaction_page.dart';

class _TransactionCategories extends StatelessWidget {
  const _TransactionCategories();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CategoryBloc, CategoryBlocState>(
        builder: (context, state) {
          return GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            shrinkWrap: true,
            mainAxisSpacing: 16,
            crossAxisSpacing: 8,
            crossAxisCount: 3,
            childAspectRatio: 2,
            children: state.categoryType == CategoryType.expense
                ? _expenseCategoriesGrid(state.categoryIndex)
                : _incomeCategoriesGrid(state.categoryIndex),
          );
        },
      );

  Widget _buildCategoryWidget((int, CategoryData) e, int selectedIndex) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          context.read<CategoryBloc>().add(
                SelectCategoryEvent(
                  category: Category(
                    type: e.$2.type,
                    name: e.$2.name,
                    index: e.$1,
                  ),
                ),
              );
        },
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      e.$1 == selectedIndex ? Colors.amber : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  e.$2.iconData,
                  size: 35,
                ),
              ),
              const SizedBox(height: 4),
              Text(e.$2.name)
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _incomeCategoriesGrid(int selectedIndex) {
    return incomeCategory.indexed
        .map<Widget>((e) => _buildCategoryWidget(e, selectedIndex))
        .toList();
  }

  List<Widget> _expenseCategoriesGrid(int selectedIndex) {
    return expenseCategory.indexed
        .map<Widget>((e) => _buildCategoryWidget(e, selectedIndex))
        .toList();
  }
}
