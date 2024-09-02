part of 'add_transaction_page.dart';

class _TransactionFormView extends StatelessWidget {
  const _TransactionFormView();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Colors.white),
      child: const Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: _ExpenseTextField(),
            ),
          ),
          _NoteTextField(),
          _NumpadTiles(),
        ],
      ),
    );
  }
}

class _NumpadTiles extends StatelessWidget {
  const _NumpadTiles();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.only(bottom: 16),
      childAspectRatio: 2 / 1.1,
      crossAxisCount: 4,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      shrinkWrap: true,
      children: List.generate(
        16,
        (index) => _NumpadTile(index: index),
      ),
    );
  }
}

class _NumpadTile extends StatelessWidget {
  _NumpadTile({required this.index});

  final int index;
  final ValueNotifier<DateTime?> _currentDate = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    Future<DateTime?> pickDate(BuildContext context) async =>
        await showMyDatePicker(
          currentDate: DateTime.now(),
          context: context,
          firstDate: DateTime(1990),
          lastDate: DateTime(DateTime.now().year + 5),
          initialDate: DateTime.now(),
          cancelText: "Batalkan",
          confirmText: "Konfirmasi",
        ).then((date) => _currentDate.value = date);

    void requestDecimalValue(BuildContext context) {
      context.read<TransactionFormBloc>().add(RequestDecimalValueEvent());
    }

    void addValue(BuildContext context, String value) {
      context.read<TransactionFormBloc>().add(AddValueEvent(value: value));
    }

    void deleteValue(BuildContext context) {
      context.read<TransactionFormBloc>().add(DeleteValueEvent());
    }

    Widget createCalendarTile() {
      return Builder(builder: (context) {
        return ValueListenableBuilder(
            valueListenable: _currentDate,
            builder: (context, date, child) {
              final theme = Theme.of(context).textButtonTheme;
              final defaultForegroundColor = theme.style?.foregroundColor ??
                  const WidgetStatePropertyAll(Colors.black);
              final localizations = MaterialLocalizations.of(context);
              final WidgetStateProperty<Color?> foregroundColor = date == null
                  ? defaultForegroundColor
                  : WidgetStatePropertyAll(context.colors.primary);

              return TextButton(
                  onPressed: () => pickDate(context),
                  clipBehavior: Clip.hardEdge,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue[100]),
                    foregroundColor: foregroundColor,
                  ),
                  child: date == null
                      ? const Icon(Icons.calendar_month)
                      : Text(
                          localizations.formatShortDate(date),
                          textAlign: TextAlign.center,
                        ));
            });
      });
    }

    Widget createButtonWithChild(Widget child, Color? color,
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

    Widget createTextButton(String text,
        {int value = 0, Function(BuildContext)? handler}) {
      TextStyle defaultTextStyle = const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w700,
        fontSize: 24,
      );

      return Builder(
        builder: (context) => TextButton(
          onPressed: () =>
              handler == null ? addValue(context, text) : handler.call(context),
          child: Text(text, style: defaultTextStyle),
        ),
      );
    }

    return switch (index) {
      0 || 1 || 2 => createTextButton("${index + 1}"),
      4 || 5 || 6 => createTextButton("$index"),
      8 || 9 || 10 => createTextButton("${index - 1}"),
      12 => createTextButton("00", value: 100),
      13 => createTextButton("0", value: 10),
      14 => createTextButton(".", handler: requestDecimalValue),
      3 => createButtonWithChild(
          const Icon(Icons.backspace_outlined),
          Colors.red[100],
          deleteValue,
        ),
      7 => createCalendarTile(),
      11 => createButtonWithChild(
          const Icon(Icons.wallet_outlined),
          Colors.yellow[100],
        ),
      15 => createButtonWithChild(
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
            fontWeight: FontWeight.w700,
            fontSize: 32,
          ),
          maxLines: 1,
          textAlign: TextAlign.end,
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
