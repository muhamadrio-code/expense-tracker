part of 'add_transaction_page.dart';

const double _noteTextFieldMargin = 8.0;
const double _mPadding = 8.0;
const double _numpadWidgetHeight = 180;

class _TransactionFormView extends StatefulWidget {
  const _TransactionFormView();

  @override
  State<_TransactionFormView> createState() => _TransactionFormViewState();
}

class _TransactionFormViewState extends State<_TransactionFormView>
    with WidgetsBindingObserver {
  final ValueNotifier<double> _bottomInset = ValueNotifier(_mPadding);

  Future<double> get bottomInset async {
    check() => MediaQuery.of(context).viewInsets.bottom;
    return await Future.delayed(
        const Duration(milliseconds: 50), () => check());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    bottomInset.then((value) => _bottomInset.value = value);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _bottomInset,
        builder: (context, bottomInset, _) {
          var bottomPadding = _mPadding;
          // double bottomInset = MediaQuery.of(context).viewInsets.bottom;
          double newInset = bottomInset -
              (_numpadWidgetHeight + bottomPadding + _noteTextFieldMargin);
          bottomPadding = max(bottomPadding, newInset);

          return DecoratedBox(
            decoration:
                BoxDecoration(color: context.colors.surfaceContainerLowest),
            child: Padding(
              padding: EdgeInsets.only(
                top: _mPadding,
                left: _mPadding,
                right: _mPadding,
                bottom: bottomPadding,
              ),
              child: const Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(_mPadding),
                      child: _ExpenseTextField(),
                    ),
                  ),
                  _NoteTextField(),
                  _NumpadTiles(
                    height: _numpadWidgetHeight,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class _NumpadTiles extends StatelessWidget {
  const _NumpadTiles({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double hRatio = height / width;
    return GridView.count(
      padding: const EdgeInsets.only(bottom: 16),
      childAspectRatio: 1 / hRatio,
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
    Future<DateTime?> pickDate() async => await showMyDatePicker(
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
                  : WidgetStatePropertyAll(context.colors.onSecondaryContainer);
              final buttonStyle = ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(context.colors.secondaryContainer),
                foregroundColor: foregroundColor,
              );

              Widget child = Icon(
                Icons.calendar_month,
                color: context.colors.onSecondaryContainer,
              );

              if (date != null) {
                child = Text(
                  localizations.formatShortDate(date),
                  textAlign: TextAlign.center,
                );
              }

              return TextButton(
                onPressed: pickDate,
                clipBehavior: Clip.hardEdge,
                style: buttonStyle,
                child: child,
              );
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
        {int value = 0, void Function(BuildContext)? handler}) {
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
      12 => createTextButton("00"),
      13 => createTextButton("0"),
      14 => createTextButton(".", handler: requestDecimalValue),
      3 => createButtonWithChild(
          Icon(
            Icons.backspace_outlined,
            color: context.colors.onSecondaryContainer,
          ),
          context.colors.secondaryContainer,
          deleteValue,
        ),
      7 => createCalendarTile(),
      11 => createButtonWithChild(
          Icon(
            Icons.wallet_outlined,
            color: context.colors.onSecondaryContainer,
          ),
          context.colors.secondaryContainer),
      15 => createButtonWithChild(
          Icon(
            Icons.check_rounded,
            color: context.colors.surfaceContainerHighest,
          ),
          context.colors.onSurface.withOpacity(.87),
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
      padding: const EdgeInsets.symmetric(horizontal: _mPadding),
      margin: const EdgeInsets.only(bottom: _noteTextFieldMargin),
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
