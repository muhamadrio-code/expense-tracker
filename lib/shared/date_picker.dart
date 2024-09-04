// The M3 sizes are coming from the tokens, but are hand coded,
// as the current token DB does not contain landscape versions.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Size _calendarPortraitDialogSizeM2 = Size(378.0, 455.0);
const Size _calendarPortraitDialogSizeM3 = Size(378.0, 450.0);
const Size _calendarLandscapeDialogSize = Size(496.0, 346.0);
const Duration _dialogSizeAnimationDuration = Duration(milliseconds: 200);
const double _kMaxTextScaleFactor = 1.3;

Future<DateTime?> showMyDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTime? currentDate,
  Locale? locale,
  String? cancelText,
  String? confirmText,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  DatePickerMode initialDatePickerMode = DatePickerMode.day,
  Offset? anchorPoint,
  final ValueChanged<DatePickerEntryMode>? onDatePickerModeChange,
}) async {
  initialDate = initialDate ?? DateTime.now();
  firstDate = DateUtils.dateOnly(firstDate);
  lastDate = DateUtils.dateOnly(lastDate);
  assert(
    !lastDate.isBefore(firstDate),
    'lastDate $lastDate must be on or after firstDate $firstDate.',
  );
  assert(
    !initialDate.isBefore(firstDate),
    'initialDate $initialDate must be on or after firstDate $firstDate.',
  );
  assert(
    !initialDate.isAfter(lastDate),
    'initialDate $initialDate must be on or before lastDate $lastDate.',
  );
  assert(debugCheckHasMaterialLocalizations(context));

  Widget dialog = DatePickerDialog(
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    cancelText: cancelText,
    confirmText: confirmText,
    onDatePickerModeChange: onDatePickerModeChange,
  );

  if (textDirection != null) {
    dialog = Directionality(
      textDirection: textDirection,
      child: dialog,
    );
  }

  if (locale != null) {
    dialog = Localizations.override(
      context: context,
      locale: locale,
      child: dialog,
    );
  }

  return showDialog<DateTime>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    anchorPoint: anchorPoint,
  );
}

class DatePickerDialog extends StatefulWidget {
  /// A Material-style date picker dialog.
  DatePickerDialog({
    super.key,
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? currentDate,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.restorationId,
    this.onDatePickerModeChange,
  })  : initialDate = initialDate ?? DateTime.now(),
        firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate),
        currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now()) {
    assert(
      !this.lastDate.isBefore(this.firstDate),
      'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      initialDate == null || !this.initialDate!.isBefore(this.firstDate),
      'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      initialDate == null || !this.initialDate!.isAfter(this.lastDate),
      'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.',
    );
  }

  /// The initially selected [DateTime] that the picker should display.
  ///
  /// If this is null, there is no selected date. A date must be selected to
  /// submit the dialog.
  final DateTime? initialDate;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// The text that is displayed on the cancel button.
  final String? cancelText;

  /// The text that is displayed on the confirm button.
  final String? confirmText;

  /// The text that is displayed at the top of the header.
  ///
  /// This is used to indicate to the user what they are selecting a date for.
  final String? helpText;

  /// Restoration ID to save and restore the state of the [DatePickerDialog].
  ///
  /// If it is non-null, the date picker will persist and restore the
  /// date selected on the dialog.
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  final String? restorationId;

  /// Called when the [DatePickerDialog] is toggled between
  /// [DatePickerEntryMode.calendar],[DatePickerEntryMode.input].
  ///
  /// An example of how this callback might be used is an app that saves the
  /// user's preferred entry mode and uses it to initialize the
  /// `initialEntryMode` parameter the next time the date picker is shown.
  final ValueChanged<DatePickerEntryMode>? onDatePickerModeChange;

  @override
  State<DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<DatePickerDialog>
    with RestorationMixin {
  late final RestorableDateTimeN _selectedDate =
      RestorableDateTimeN(widget.initialDate);

  @override
  void dispose() {
    _selectedDate.dispose();
    super.dispose();
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
  }

  final GlobalKey _calendarPickerKey = GlobalKey();

  void _handleOk() {
    Navigator.pop(context, _selectedDate.value);
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleDateChanged(DateTime date) {
    setState(() {
      _selectedDate.value = date;
    });
  }

  Size _dialogSize(BuildContext context) {
    final bool useMaterial3 = Theme.of(context).useMaterial3;
    final Orientation orientation = MediaQuery.orientationOf(context);

    return switch ((orientation)) {
      (Orientation.portrait) when useMaterial3 => _calendarPortraitDialogSizeM3,
      (Orientation.portrait) => _calendarPortraitDialogSizeM2,
      (Orientation.landscape) => _calendarLandscapeDialogSize,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool useMaterial3 = theme.useMaterial3;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final Orientation orientation = MediaQuery.orientationOf(context);
    final DatePickerThemeData datePickerTheme = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);
    final TextTheme textTheme = theme.textTheme;

    // There's no M3 spec for a landscape layout input (not calendar)
    // date picker. To ensure that the date displayed in the input
    // date picker's header fits in landscape mode, we override the M3
    // default here.
    TextStyle? headlineStyle = textTheme.headlineSmall;
    final Color? headerForegroundColor =
        datePickerTheme.headerForegroundColor ?? defaults.headerForegroundColor;
    headlineStyle = headlineStyle?.copyWith(
        color: headerForegroundColor, fontWeight: FontWeight.w700);

    final Widget actions = Container(
      alignment: AlignmentDirectional.topStart,
      constraints: const BoxConstraints(minHeight: 52.0),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextButton(
              style: datePickerTheme.cancelButtonStyle ??
                  defaults.cancelButtonStyle,
              onPressed: _handleCancel,
              child: Text(widget.cancelText ??
                  (useMaterial3
                      ? localizations.cancelButtonLabel
                      : localizations.cancelButtonLabel.toUpperCase())),
            ),
          ),
          Flexible(
            child: TextButton(
              style: datePickerTheme.confirmButtonStyle ??
                  defaults.confirmButtonStyle,
              onPressed: _handleOk,
              child: Text(widget.confirmText ?? localizations.okButtonLabel),
            ),
          ),
        ],
      ),
    );

    CalendarDatePicker calendarDatePicker() {
      return CalendarDatePicker(
        key: _calendarPickerKey,
        initialDate: _selectedDate.value,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        currentDate: widget.currentDate,
        onDateChanged: _handleDateChanged,
        initialCalendarMode: DatePickerMode.day,
      );
    }

    final Widget picker = calendarDatePicker();
    final Widget header = _DatePickerHeader(
      helpText: widget.helpText ??
          (useMaterial3
              ? localizations.datePickerHelpText
              : localizations.datePickerHelpText.toUpperCase()),
      titleText: _selectedDate.value == null
          ? ''
          : localizations.formatShortDate(_selectedDate.value!),
      titleStyle: headlineStyle,
      orientation: orientation,
      isShort: orientation == Orientation.landscape,
    );

    // Constrain the textScaleFactor to the largest supported value to prevent
    // layout issues.
    // 14 is a common font size used to compute the effective text scale.
    const double fontSizeToScale = 14.0;
    final double textScaleFactor = MediaQuery.textScalerOf(context)
            .clamp(maxScaleFactor: _kMaxTextScaleFactor)
            .scale(fontSizeToScale) /
        fontSizeToScale;
    final Size dialogSize = _dialogSize(context) * textScaleFactor;
    final DialogTheme dialogTheme = theme.dialogTheme;
    return Dialog(
      backgroundColor:
          datePickerTheme.backgroundColor ?? defaults.backgroundColor,
      elevation: useMaterial3
          ? datePickerTheme.elevation ?? defaults.elevation!
          : datePickerTheme.elevation ?? dialogTheme.elevation ?? 24,
      shadowColor: datePickerTheme.shadowColor ?? defaults.shadowColor,
      surfaceTintColor:
          datePickerTheme.surfaceTintColor ?? defaults.surfaceTintColor,
      shape: useMaterial3
          ? datePickerTheme.shape ?? defaults.shape
          : datePickerTheme.shape ?? dialogTheme.shape ?? defaults.shape,
      insetPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
      clipBehavior: Clip.antiAlias,
      child: AnimatedContainer(
        width: dialogSize.width,
        height: dialogSize.height,
        duration: _dialogSizeAnimationDuration,
        curve: Curves.easeIn,
        child: MediaQuery.withClampedTextScaling(
          // Constrain the textScaleFactor to the largest supported value to prevent
          // layout issues.
          maxScaleFactor: _kMaxTextScaleFactor,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            // Make sure the portrait dialog can fit the contents comfortably when
            // resized from the landscape dialog.
            final bool isFullyPortrait =
                constraints.maxHeight >= dialogSize.height;

            switch (orientation) {
              case Orientation.portrait:
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    header,
                    if (useMaterial3)
                      Divider(height: 0, color: datePickerTheme.dividerColor),
                    if (isFullyPortrait) ...<Widget>[
                      Expanded(child: picker),
                      actions,
                    ],
                  ],
                );
              case Orientation.landscape:
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    header,
                    if (useMaterial3)
                      VerticalDivider(
                          width: 0, color: datePickerTheme.dividerColor),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(child: picker),
                          actions,
                        ],
                      ),
                    ),
                  ],
                );
            }
          }),
        ),
      ),
    );
  }
}

/// Re-usable widget that displays the selected date (in large font) and the
/// help text above it.
///
/// These types include:
///
/// * Single Date picker with calendar mode.
/// * Single Date picker with text input mode.
/// * Date Range picker with text input mode.
///
/// [helpText], [orientation], [icon], [onIconPressed] are required and must be
/// non-null.
class _DatePickerHeader extends StatelessWidget {
  /// Creates a header for use in a date picker dialog.
  const _DatePickerHeader({
    required this.helpText,
    required this.titleText,
    required this.titleStyle,
    required this.orientation,
    this.isShort = false,
  });

  static const double _datePickerHeaderLandscapeWidth = 152.0;
  // static const double _datePickerHeaderPortraitHeight = 40.0;
  static const double _headerPaddingLandscape = 16.0;

  /// The text that is displayed at the top of the header.
  ///
  /// This is used to indicate to the user what they are selecting a date for.
  final String helpText;

  /// The text that is displayed at the center of the header.
  final String titleText;

  /// The [TextStyle] that the title text is displayed with.
  final TextStyle? titleStyle;

  /// The orientation is used to decide how to layout its children.
  final Orientation orientation;

  /// Indicates the header is being displayed in a shorter/narrower context.
  ///
  /// This will be used to tighten up the space between the help text and date
  /// text if `true`. Additionally, it will use a smaller typography style if
  /// `true`.
  ///
  /// This is necessary for displaying the manual input mode in
  /// landscape orientation, in order to account for the keyboard height.
  final bool isShort;

  @override
  Widget build(BuildContext context) {
    final DatePickerThemeData themeData = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);
    final Color? backgroundColor =
        themeData.headerBackgroundColor ?? defaults.headerBackgroundColor;

    final Text title = Text(
      titleText,
      semanticsLabel: titleText,
      style: titleStyle,
      maxLines: orientation == Orientation.portrait ? 1 : 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );

    switch (orientation) {
      case Orientation.portrait:
        return Semantics(
          container: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: title,
          ),
        );
      case Orientation.landscape:
        return Semantics(
          container: true,
          child: SizedBox(
            width: _datePickerHeaderLandscapeWidth,
            child: Material(
              color: backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16),
                  SizedBox(height: isShort ? 16 : 56),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: _headerPaddingLandscape,
                      ),
                      child: title,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}
