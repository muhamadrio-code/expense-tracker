part of 'add_transaction_page.dart';

class _AddTransactionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _AddTransactionAppBar();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AppBar(
        title: const Text("Add transaction"),
        bottom: _AddTransactionTabBar(),
        actions: const [
          _SaveButton(),
        ],
        leading: const _BackButton(),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}

class _AddTransactionTabBar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(
          strokeAlign: BorderSide.strokeAlignOutside,
          color: Colors.black12,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        onTap: (index) {
          context
              .read<CategoryBloc>()
              .add(CategoryTypeChangeEvent(index: index));
        },
        tabs: const [
          Text("Expense"),
          Text("Income"),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: IconButton(
        onPressed: () {},
        icon: const Text(
          "Save",
          style: TextStyle(color: Colors.white),
        ),
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.black87),
            padding: WidgetStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            ),
            shape: WidgetStateProperty.all<ContinuousRectangleBorder>(
                ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            minimumSize: WidgetStateProperty.all<Size>(const Size(72, 30))),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.maybePop(context),
      icon: const Icon(Icons.close_rounded),
    );
  }
}
