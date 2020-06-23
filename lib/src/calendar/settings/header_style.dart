part of calendar;

/// Sets the style for customizing the [SfCalendar] header view.
///
/// If this is not [null] then the style is applied to the calendar
/// header view.
///
/// ```dart
///Widget build(BuildContext context) {
///  return Container(
///  child: SfCalendar(
///      view: CalendarView.week,
///      headerStyle: CalendarHeaderStyle(
///          textStyle: TextStyle(color: Colors.red, fontSize: 20),
///          textAlign: TextAlign.center,
///          backgroundColor: Colors.blue),
///    ),
///  );
///}
/// ```
class CalendarHeaderStyle {
  CalendarHeaderStyle({this.textAlign, this.backgroundColor, this.textStyle});

  /// Sets the text style for the text in the [SfCalendar] header view.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///  return Container(
  ///  child: SfCalendar(
  ///      view: CalendarView.week,
  ///      headerStyle: CalendarHeaderStyle(
  ///          textStyle: TextStyle(color: Colors.red, fontSize: 20),
  ///          textAlign: TextAlign.center,
  ///          backgroundColor: Colors.blue),
  ///    ),
  ///  );
  ///}
  /// ```
  final TextStyle textStyle;

  /// Align the header text in the [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///  return Container(
  ///  child: SfCalendar(
  ///      view: CalendarView.week,
  ///      headerStyle: CalendarHeaderStyle(
  ///          textStyle: TextStyle(color: Colors.red, fontSize: 20),
  ///          textAlign: TextAlign.center,
  ///          backgroundColor: Colors.blue),
  ///    ),
  ///  );
  ///}
  /// ```
  final TextAlign textAlign;

  /// The background color which fills the [SfCalendar] header view background.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///  return Container(
  ///  child: SfCalendar(
  ///      view: CalendarView.week,
  ///      headerStyle: CalendarHeaderStyle(
  ///          textStyle: TextStyle(color: Colors.red, fontSize: 20),
  ///          textAlign: TextAlign.center,
  ///          backgroundColor: Colors.blue),
  ///    ),
  ///  );
  ///}
  /// ```
  final Color backgroundColor;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CalendarHeaderStyle otherStyle = other;
    return otherStyle.textStyle == textStyle &&
        otherStyle.textAlign == textAlign &&
        otherStyle.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode {
    return hashValues(
      textStyle,
      textAlign,
      backgroundColor,
    );
  }
}
