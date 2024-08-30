part of 'add_transaction_page.dart';

class _AddTransactionTabItem extends StatelessWidget {
  const _AddTransactionTabItem();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(child: _TransactionCategories()),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 300,
            decoration: const BoxDecoration(color: Colors.amber),
          ),
        )
      ],
    );
  }
}
