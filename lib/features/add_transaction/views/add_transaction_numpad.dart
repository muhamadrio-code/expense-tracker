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
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                const _ExpenseTextField(),
                const _AddTransactionNoteTextField(),
                GridView.count(
                  padding: const EdgeInsets.only(bottom: 16),
                  childAspectRatio: 2 / 1.2,
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  shrinkWrap: true,
                  children: List.generate(
                    16,
                    (i) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 245, 241, 241),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "$i",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _ExpenseTextField extends StatelessWidget {
  const _ExpenseTextField();

  @override
  Widget build(BuildContext context) {
    return const IntrinsicHeight(
      child: TextField(
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w800,
          fontSize: 32,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          hintText: "0",
          hintStyle: TextStyle(
            color: Colors.black87,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
          prefixIconConstraints: BoxConstraints(),
          prefixIcon: Icon(
            Icons.wallet,
            size: 35,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
        keyboardType: TextInputType.number,
        maxLines: 2,
        minLines: 1,
        autocorrect: false,
        showCursor: false,
        textAlign: TextAlign.end,
      ),
    );
  }
}
