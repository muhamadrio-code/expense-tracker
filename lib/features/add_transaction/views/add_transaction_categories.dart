part of 'add_transaction_page.dart';

class _TransactionCategories extends StatelessWidget {
  const _TransactionCategories();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CategoryBloc, CategoryBlocState>(
        builder: (context, state) {
          return GridView.count(
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            crossAxisCount: 4,
            children: state.categoryType == CategoryType.expense
                ? _expenseCategoriesGrid(state.categoryIndex)
                : _incomeCategoriesGrid(state.categoryIndex),
          );
        },
      );

  Widget _buildCategoryWidget((int, CategoryData) e, int selectedIndex) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () => context.read<CategoryBloc>()
          ..add(
            SelectCategoryEvent(
              category: Category(
                type: e.$2.type,
                name: e.$2.name,
                index: e.$1,
              ),
            ),
          ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: e.$1 == selectedIndex ? Colors.amber : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(e.$2.iconData),
              const SizedBox(height: 8),
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
