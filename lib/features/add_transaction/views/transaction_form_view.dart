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
    _bottomInset.dispose();
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
    void addCreatedDate(DateTime? date) {
      context
          .read<TransactionFormBloc>()
          .add(AddCreatedDateEvent(createdDate: date));
    }

    void requestDecimalValue() {
      context.read<TransactionFormBloc>().add(RequestDecimalValueEvent());
    }

    void addValue(String value) {
      context.read<TransactionFormBloc>().add(AddValueEvent(value: value));
    }

    void deleteValue() {
      context.read<TransactionFormBloc>().add(DeleteValueEvent());
    }

    void submitValue() {
      context.read<TransactionFormBloc>().add(SubmitValueEvent());
    }

    Future<DateTime?> pickDate() async => await showMyDatePicker(
          currentDate: DateTime.now(),
          context: context,
          firstDate: DateTime(1990),
          lastDate: DateTime(DateTime.now().year + 5),
          initialDate: DateTime.now(),
          cancelText: "Batalkan",
          confirmText: "Konfirmasi",
        ).then((date) {
          _currentDate.value = date;
          addCreatedDate(date);
          return null;
        });

    final theme = Theme.of(context).textButtonTheme;
    final defaultForegroundColor = theme.style?.foregroundColor ??
        const WidgetStatePropertyAll(Colors.black);
    final localizations = MaterialLocalizations.of(context);

    Widget createCalendarTile() {
      return ValueListenableBuilder(
          valueListenable: _currentDate,
          builder: (context, date, child) {
            final foregroundColor = date == null
                ? defaultForegroundColor
                : WidgetStatePropertyAll(context.colors.onSecondaryContainer);

            Widget child = Icon(
              Icons.calendar_month,
              color: context.colors.onSecondaryContainer,
            );

            final buttonStyle = ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(context.colors.secondaryContainer),
              foregroundColor: foregroundColor,
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
    }

    Widget createButtonWithChild(Widget child, Color? color,
        [Function()? handler]) {
      return TextButton(
        onPressed: () => handler?.call(),
        clipBehavior: Clip.antiAlias,
        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(color)),
        child: child,
      );
    }

    Widget createTextButton(String text,
        {int value = 0, void Function()? handler}) {
      TextStyle defaultTextStyle = const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w700,
        fontSize: 24,
      );

      return TextButton(
        onPressed: () => handler == null ? addValue(text) : handler.call(),
        child: Text(text, style: defaultTextStyle),
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
          submitValue,
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
      selector: (state) => state.data.formattedValue,
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
    final Widget suffixIcon =
        BlocSelector<TransactionFormBloc, TransactionFormState, List<String>>(
            selector: (state) => state.data.images,
            builder: (context, images) {
              void saveImage(List<XFile> files) {
                List<String> pathsString = files.map((e) => e.path).toList();
                context
                    .read<TransactionFormBloc>()
                    .add(AddImageEvent.success(pathsString));
              }

              void onError(Exception e) {
                context.read<TransactionFormBloc>().add(AddImageEvent.error(e));
              }

              const Widget cameraIcon = Icon(Icons.camera_alt);
              const double iconSize = 24;

              if (images.isEmpty) {
                return IconButton(
                  icon: cameraIcon,
                  iconSize: iconSize,
                  onPressed: () => showImagePickerDialog(
                    context,
                    onSuccess: saveImage,
                    onError: onError,
                  ),
                );
              }

              return IconButton(
                icon: Badge.count(count: images.length, child: cameraIcon),
                iconSize: iconSize,
                onPressed: () => openImagesSheet(context),
              );
            });

    const TextStyle defaultTextStyle = TextStyle(
        color: Colors.black45, fontSize: 16, fontWeight: FontWeight.w600);
    const iconConstraints = BoxConstraints();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _mPadding),
      margin: const EdgeInsets.only(bottom: _noteTextFieldMargin),
      decoration: BoxDecoration(
        color: context.colors.surfaceDim,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: TextField(
          style: defaultTextStyle,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16),
            prefixIcon: const Text(
              "Catatan: ",
              style: defaultTextStyle,
            ),
            hintText: "Masukkan catatan...",
            hintStyle: defaultTextStyle,
            prefixIconConstraints: iconConstraints,
            suffixIconConstraints: iconConstraints,
            suffixIcon: suffixIcon,
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
