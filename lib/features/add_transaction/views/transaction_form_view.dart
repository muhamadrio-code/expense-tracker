part of 'add_transaction_page.dart';

class _TransactionFormView extends StatelessWidget {
  const _TransactionFormView();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          const _ExpenseTextField(),
          const _NoteTextField(),
          GridView.count(
            padding: const EdgeInsets.only(bottom: 16),
            childAspectRatio: 2 / 1.1,
            crossAxisCount: 4,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            shrinkWrap: true,
            children: List.generate(
              16,
              _createNumpadTile,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createNumpadTile(int index) {
    return switch (index) {
      0 || 1 || 2 => _createTextButton(
          "${index + 1}",
          (context) {
            context.read<TransactionFormBloc>().add(
                  AddValueEvent(
                    value: (index + 1),
                  ),
                );
          },
        ),
      4 || 5 || 6 => _createTextButton(
          "$index",
          (context) {
            context.read<TransactionFormBloc>().add(
                  AddValueEvent(
                    value: (index),
                  ),
                );
          },
        ),
      8 || 9 || 10 => _createTextButton(
          "${index - 1}",
          (context) {
            context.read<TransactionFormBloc>().add(
                  AddValueEvent(
                    value: (index - 1),
                  ),
                );
          },
        ),
      3 => _createButtonWithChild(
          const Icon(Icons.backspace_outlined),
          Colors.red[50],
          (context) =>
              context.read<TransactionFormBloc>().add(DeleteValueEvent())),
      7 => _createButtonWithChild(
          const Icon(Icons.calendar_month_outlined),
          Colors.blue[50],
        ),
      11 => _createButtonWithChild(
          const Icon(Icons.wallet_outlined),
          Colors.yellow[50],
        ),
      12 => _createTextButton("00"),
      13 => _createTextButton(
          "0",
          (context) {
            context.read<TransactionFormBloc>().add(
                  AddValueEvent(value: 10),
                );
          },
        ),
      14 => _createTextButton(
          ".",
          (context) {
            context.read<TransactionFormBloc>().add(RequestDecimalValueEvent());
          },
        ),
      15 => _createButtonWithChild(
          const Icon(
            Icons.check_rounded,
            color: Colors.white,
          ),
          Colors.black87,
          (context) =>
              context.read<TransactionFormBloc>().add(SubmitValueEvent()),
        ),
      int() => const Placeholder(),
    };
  }

  Widget _createButtonWithChild(Widget child, Color? color,
      [Function(BuildContext)? handler]) {
    return Builder(builder: (context) {
      return TextButton(
        onPressed: () => handler?.call(context),
        clipBehavior: Clip.antiAlias,
        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(color)),
        child: child,
      );
    });
  }

  Widget _createTextButton(String text, [Function(BuildContext)? handler]) {
    return Builder(builder: (context) {
      return TextButton(
        onPressed: () => handler?.call(context),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
      );
    });
  }
}

class _ExpenseTextField extends StatelessWidget {
  const _ExpenseTextField();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransactionFormBloc, TransactionFormState, String>(
      selector: (state) => state.formattedValue,
      builder: (context, state) {
        return Text(
          state,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 32,
          ),
          maxLines: 1,
        );
      },
    );
  }
}

class _NoteTextField extends StatelessWidget {
  const _NoteTextField();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.colors.surfaceDim,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const IntrinsicHeight(
        child: TextField(
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16),
            prefixIcon: Text(
              "Catatan: ",
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            hintText: "Masukkan catatan...",
            hintStyle: TextStyle(
                color: Colors.black45,
                fontSize: 16,
                fontWeight: FontWeight.w600),
            prefixIconConstraints: BoxConstraints(),
            suffixIconConstraints: BoxConstraints(),
            suffixIcon: Icon(
              Icons.camera_alt_outlined,
              size: 24,
            ),
            border: InputBorder.none,
            isDense: true,
          ),
          keyboardType: TextInputType.multiline,
          maxLines: 2,
          minLines: 1,
          autocorrect: false,
        ),
      ),
    );
  }
}
