part of calendar;

/// Sets the style to customize [SfCalendar] view header.
///
/// If this is not [null] then the style is applied to [SfCalendar] view header
/// for all applicable views.
///
/// ```dart
///
///Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.week,
///        viewHeaderStyle: ViewHeaderStyle(
///            backgroundColor: Colors.blue,
///            dayTextStyle: TextStyle(color: Colors.grey, fontSize: 20),
///            dateTextStyle: TextStyle(color: Colors.grey, fontSize: 25)),
///      ),
///    );
///  }
///
/// ```
class ViewHeaderStyle {
  ViewHeaderStyle(
      {this.backgroundColor, this.dateTextStyle, this.dayTextStyle});

  /// The background color which fills the [SfCalendar] view header view background.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        viewHeaderStyle: ViewHeaderStyle(
  ///            backgroundColor: Colors.blue,
  ///            dayTextStyle: TextStyle(color: Colors.grey, fontSize: 20),
  ///            dateTextStyle: TextStyle(color: Colors.grey, fontSize: 25)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Color backgroundColor;

  /// Sets the text style for the date text in the view header of [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// _Note:_ This property doesn't applicable when the [SfCalendar.view] set as
  /// [CalendarView.month].
  ///
  /// The text color set to this doesn't apply for the today cell in view header
  /// of day/week/workweek view.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        viewHeaderStyle: ViewHeaderStyle(
  ///            backgroundColor: Colors.blue,
  ///            dayTextStyle: TextStyle(color: Colors.grey, fontSize: 20),
  ///            dateTextStyle: TextStyle(color: Colors.grey, fontSize: 25)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final TextStyle dateTextStyle;

  /// Sets the text style for the day text in the view header of [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        viewHeaderStyle: ViewHeaderStyle(
  ///            backgroundColor: Colors.blue,
  ///            dayTextStyle: TextStyle(color: Colors.grey, fontSize: 20),
  ///            dateTextStyle: TextStyle(color: Colors.grey, fontSize: 25)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final TextStyle dayTextStyle;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ViewHeaderStyle otherStyle = other;
    return otherStyle.backgroundColor == backgroundColor &&
        otherStyle.dayTextStyle == dayTextStyle &&
        otherStyle.dateTextStyle == dateTextStyle;
  }

  @override
  int get hashCode {
    return hashValues(
      backgroundColor,
      dayTextStyle,
      dateTextStyle,
    );
  }
}
