part of calendar;

/// The settings have properties which allow to customize the month view of
/// the [SfCalendar].
///
/// If it is not [null] the month view will be rendered on the basis of the
/// properties set in this settings.

///
/// ```dart
///
///Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.Month,
///        monthViewSettings: MonthViewSettings(
///            dayFormat: 'EEE',
///            numberOfWeeksInView: 4,
///            appointmentDisplayCount: 2,
///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
///            showAgenda: false,
///            navigationDirection: MonthNavigationDirection.horizontal),
///      ),
///    );
///  }
///
/// ```
class MonthViewSettings {
  MonthViewSettings(
      {this.appointmentDisplayCount = 4,
      this.numberOfWeeksInView = 6,
      this.appointmentDisplayMode = MonthAppointmentDisplayMode.indicator,
      this.showAgenda = false,
      this.navigationDirection = MonthNavigationDirection.horizontal,
      this.dayFormat = 'EE',
      this.agendaItemHeight = 50,
      double agendaViewHeight,
      MonthCellStyle monthCellStyle,
      AgendaStyle agendaStyle})
      : monthCellStyle = monthCellStyle ?? MonthCellStyle(),
        agendaStyle = agendaStyle ?? AgendaStyle(),
        agendaViewHeight = agendaViewHeight ?? -1;

  /// Formats a text in the [SfCalendar] month view view header.
  ///
  /// Defaults to `EE`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        dataSource: _getCalendarDataSource(),
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: false,
  ///            navigationDirection: MonthNavigationDirection.horizontal,
  ///            monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///            normal, fontSize: 15, color: Colors.black),
  ///                todayTextStyle: TextStyle(fontStyle: FontStyle.italic,
  ///                    fontSize: 17,
  ///                    color: Colors.red),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  ///  DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(Appointment(
  ///      startTime: DateTime.now(),
  ///      endTime: DateTime.now().add(Duration(hours: 2)),
  ///      isAllDay: true,
  ///      subject: 'Meeting',
  ///      color: Colors.blue,
  ///      startTimeZone: '',
  ///      endTimeZone: '',
  ///    ));
  ///
  ///    return DataSource(appointments);
  ///  }
  ///
  final String dayFormat;

  /// The height in [SfCalendar] month agenda view for each appointment view to
  /// layout within this.
  ///
  /// Defaults to `50`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  /// return Container(
  ///    child: SfCalendar(
  ///      view: CalendarView.Month,
  ///      monthViewSettings: MonthViewSettings(
  ///          dayFormat: 'EEE',
  ///          numberOfWeeksInView: 4,
  ///          appointmentDisplayCount: 2,
  ///          agendaItemHeight: 50,
  ///          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///          showAgenda: false,
  ///          navigationDirection: MonthNavigationDirection.horizontal,
  ///          agendaStyle: AgendaStyle(
  ///              backgroundColor: Colors.transparent,
  ///             appointmentTextStyle: TextStyle(
  ///                  color: Colors.white,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic
  ///              ),
  ///              dayTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic),
  ///              dateTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 25,
  ///                  fontWeight: FontWeight.bold,
  ///                  fontStyle: FontStyle.normal)
  ///         )),
  ///      ),
  ///    );
  /// }
  /// ```
  final double agendaItemHeight;

  /// Sets the style to customize [SfCalendar] month cells.
  ///
  /// If this is not [null] then the style is applied to [SfCalendar] month view
  /// month cells.
  ///
  /// Defaults to instance of `MonthCellStyle`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        dataSource: _getCalendarDataSource(),
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: false,
  ///            navigationDirection: MonthNavigationDirection.horizontal,
  ///            monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///            normal, fontSize: 15, color: Colors.black),
  ///                todayTextStyle: TextStyle(fontStyle: FontStyle.italic,
  ///                    fontSize: 17,
  ///                    color: Colors.red),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  ///  DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(Appointment(
  ///      startTime: DateTime.now(),
  ///      endTime: DateTime.now().add(Duration(hours: 2)),
  ///      isAllDay: true,
  ///      subject: 'Meeting',
  ///      color: Colors.blue,
  ///      startTimeZone: '',
  ///      endTimeZone: '',
  ///    ));
  ///
  ///    return DataSource(appointments);
  ///  }
  ///
  final MonthCellStyle monthCellStyle;

  /// Sets the style to customize [SfCalendar] month agenda view.
  ///
  /// If this is not [null] then the style is applied to [SfCalendar] month
  /// agenda view.
  ///
  /// Defaults to instance of `AgendaStyle`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  /// return Container(
  ///    child: SfCalendar(
  ///      view: CalendarView.Month,
  ///      monthViewSettings: MonthViewSettings(
  ///          dayFormat: 'EEE',
  ///          numberOfWeeksInView: 4,
  ///          appointmentDisplayCount: 2,
  ///          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///          showAgenda: false,
  ///          navigationDirection: MonthNavigationDirection.horizontal,
  ///          agendaStyle: AgendaStyle(
  ///              backgroundColor: Colors.transparent,
  ///             appointmentTextStyle: TextStyle(
  ///                  color: Colors.white,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic
  ///              ),
  ///              dayTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic),
  ///              dateTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 25,
  ///                  fontWeight: FontWeight.bold,
  ///                  fontStyle: FontStyle.normal)
  ///         )),
  ///      ),
  ///    );
  /// }
  /// ```

  final AgendaStyle agendaStyle;

  /// Sets the number of weeks to display in [ SfCalendar ]'s month view.
  ///
  /// Defaults to `6`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: false,
  ///            navigationDirection: MonthNavigationDirection.horizontal),
  ///      ),
  ///    );
  ///  }
  /// ```
  final int numberOfWeeksInView;

  /// Sets the number of appointments to be displayed in month cell of [SfCalendar].
  ///
  /// Defaults to `4`.
  ///
  /// _Note:_ if the appointment count is less than the value set to this property
  /// in a particular day, then the month cell will display the appointments
  /// according to the number of appointments available on that day.
  ///
  /// Appointment indicator will be shown on the basis of date meetings, usable
  /// month cell size and indicator count. For eg, if the month cell size is less
  /// (available for only 4 dots) and the indicator count is 10, then 4
  /// indicators will be shown
  ///
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: false,
  ///            navigationDirection: MonthNavigationDirection.horizontal),
  ///      ),
  ///    );
  ///  }
  /// ```
  final int appointmentDisplayCount;

  /// Defines the appointment display mode for the month cell in [SfCalendar].
  ///
  /// Defaults to `MonthAppointmentDisplayMode.indicator`.
  ///
  /// Also refer: [MonthAppointmentDisplayMode].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: false,
  ///            navigationDirection: MonthNavigationDirection.horizontal),
  ///      ),
  ///    );
  ///  }
  /// ```
  final MonthAppointmentDisplayMode appointmentDisplayMode;

  /// The [SfCalendar] month view will render without agenda view on screen by
  /// default.
  ///
  /// if it is set as [true] the month view of [SfCalendar] will render agenda
  /// view along with month, to display the selected date's appointments.
  ///
  /// the [agendaHeight] property used to customize the height of the agenda view
  /// in month view.
  ///
  /// Defaults to `false`.
  ///
  /// see also: [agendaHeight].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: true,
  ///            navigationDirection: MonthNavigationDirection.horizontal),
  ///      ),
  ///    );
  ///  }
  /// ```
  final bool showAgenda;

  /// The height for agenda view to layout within this in [SfCalendar] month
  /// view.
  ///
  /// If it is not [null] the agenda view will layout within the given height.
  ///
  /// Defaults to `-1`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: true,
  ///            agendaViewHeight: 120,
  ///            navigationDirection: MonthNavigationDirection.horizontal),
  ///      ),
  ///    );
  ///  }
  /// ```
  final double agendaViewHeight;

  /// Defines the navigation direction for the [SfCalendar] month view.
  ///
  /// If it this property set as [MonthNavigationDirection.vertical] the
  /// [SfCalendar] month view will navigate to the previous/next views in the
  /// vertical direction instead of the horizontal direction.
  ///
  /// Defaults to `MonthNavigationDirection.horizontal`.

  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: false,
  ///            navigationDirection: MonthNavigationDirection.horizontal),
  ///      ),
  ///    );
  ///  }
  /// ```
  final MonthNavigationDirection navigationDirection;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final MonthViewSettings otherStyle = other;
    return otherStyle.dayFormat == dayFormat &&
        otherStyle.monthCellStyle == monthCellStyle &&
        otherStyle.agendaStyle == agendaStyle &&
        otherStyle.numberOfWeeksInView == numberOfWeeksInView &&
        otherStyle.appointmentDisplayCount == appointmentDisplayCount &&
        otherStyle.appointmentDisplayMode == appointmentDisplayMode &&
        otherStyle.agendaItemHeight == agendaItemHeight &&
        otherStyle.showAgenda == showAgenda &&
        otherStyle.agendaViewHeight == agendaViewHeight &&
        otherStyle.navigationDirection == navigationDirection;
  }

  @override
  int get hashCode {
    return hashValues(
      dayFormat,
      monthCellStyle,
      agendaStyle,
      numberOfWeeksInView,
      appointmentDisplayCount,
      appointmentDisplayMode,
      showAgenda,
      agendaViewHeight,
      agendaItemHeight,
      navigationDirection,
    );
  }
}

/// Sets the style to customize [SfCalendar] month agenda view.
///
/// If this is not [null] then the style is applied to [SfCalendar] month
/// agenda view.
///
/// ```dart
/// Widget build(BuildContext context) {
/// return Container(
///    child: SfCalendar(
///      view: CalendarView.Month,
///      monthViewSettings: MonthViewSettings(
///          dayFormat: 'EEE',
///          numberOfWeeksInView: 4,
///          appointmentDisplayCount: 2,
///          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
///          showAgenda: true,
///          navigationDirection: MonthNavigationDirection.horizontal,
///          agendaStyle: AgendaStyle(
///              backgroundColor: Colors.transparent,
///             appointmentTextStyle: TextStyle(
///                  color: Colors.white,
///                  fontSize: 13,
///                  fontStyle: FontStyle.italic
///              ),
///              dayTextStyle: TextStyle(color: Colors.red,
///                  fontSize: 13,
///                  fontStyle: FontStyle.italic),
///              dateTextStyle: TextStyle(color: Colors.red,
///                  fontSize: 25,
///                  fontWeight: FontWeight.bold,
///                  fontStyle: FontStyle.normal)
///         )),
///      ),
///    );
/// }
/// ```

class AgendaStyle {
  AgendaStyle(
      {this.appointmentTextStyle,
      this.dayTextStyle,
      this.dateTextStyle,
      this.backgroundColor});

  /// Sets the text style for the text in the Appointment view of [SfCalendar]
  /// month agenda view.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  /// return Container(
  ///    child: SfCalendar(
  ///      view: CalendarView.Month,
  ///      monthViewSettings: MonthViewSettings(
  ///          dayFormat: 'EEE',
  ///          numberOfWeeksInView: 4,
  ///          appointmentDisplayCount: 2,
  ///          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///          showAgenda: true,
  ///          navigationDirection: MonthNavigationDirection.horizontal,
  ///          agendaStyle: AgendaStyle(
  ///              backgroundColor: Colors.transparent,
  ///             appointmentTextStyle: TextStyle(
  ///                  color: Colors.white,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic
  ///              ),
  ///              dayTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic),
  ///              dateTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 25,
  ///                  fontWeight: FontWeight.bold,
  ///                  fontStyle: FontStyle.normal)
  ///         )),
  ///      ),
  ///    );
  /// }
  /// ```
  final TextStyle appointmentTextStyle;

  /// Sets the text style for the text in the day text of [SfCalendar]
  /// month agenda view.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  /// return Container(
  ///    child: SfCalendar(
  ///      view: CalendarView.Month,
  ///      monthViewSettings: MonthViewSettings(
  ///          dayFormat: 'EEE',
  ///          numberOfWeeksInView: 4,
  ///          appointmentDisplayCount: 2,
  ///          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///          showAgenda: true,
  ///          navigationDirection: MonthNavigationDirection.horizontal,
  ///          agendaStyle: AgendaStyle(
  ///              backgroundColor: Colors.transparent,
  ///             appointmentTextStyle: TextStyle(
  ///                  color: Colors.white,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic
  ///              ),
  ///              dayTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic),
  ///              dateTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 25,
  ///                  fontWeight: FontWeight.bold,
  ///                  fontStyle: FontStyle.normal)
  ///         )),
  ///      ),
  ///    );
  /// }
  /// ```
  final TextStyle dayTextStyle;

  /// Sets the text style for the text in the date view of [SfCalendar]
  /// month agenda view.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  /// return Container(
  ///    child: SfCalendar(
  ///      view: CalendarView.Month,
  ///      monthViewSettings: MonthViewSettings(
  ///          dayFormat: 'EEE',
  ///          numberOfWeeksInView: 4,
  ///          appointmentDisplayCount: 2,
  ///          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///          showAgenda: true,
  ///          navigationDirection: MonthNavigationDirection.horizontal,
  ///          agendaStyle: AgendaStyle(
  ///              backgroundColor: Colors.transparent,
  ///             appointmentTextStyle: TextStyle(
  ///                  color: Colors.white,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic
  ///              ),
  ///              dayTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic),
  ///              dateTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 25,
  ///                  fontWeight: FontWeight.bold,
  ///                  fontStyle: FontStyle.normal)
  ///         )),
  ///      ),
  ///    );
  /// }
  /// ```
  final TextStyle dateTextStyle;

  /// The background color to fill the background of the [SfCalendar] month
  /// agenda view.
  ///
  /// if it is not [null] the color to be applied to the background of the
  /// [SfCalendar] month agenda view.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  /// return Container(
  ///    child: SfCalendar(
  ///      view: CalendarView.Month,
  ///      monthViewSettings: MonthViewSettings(
  ///          dayFormat: 'EEE',
  ///          numberOfWeeksInView: 4,
  ///          appointmentDisplayCount: 2,
  ///          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///          showAgenda: true,
  ///          navigationDirection: MonthNavigationDirection.horizontal,
  ///          agendaStyle: AgendaStyle(
  ///              backgroundColor: Colors.transparent,
  ///             appointmentTextStyle: TextStyle(
  ///                  color: Colors.white,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic
  ///              ),
  ///              dayTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 13,
  ///                  fontStyle: FontStyle.italic),
  ///              dateTextStyle: TextStyle(color: Colors.red,
  ///                  fontSize: 25,
  ///                  fontWeight: FontWeight.bold,
  ///                  fontStyle: FontStyle.normal)
  ///         )),
  ///      ),
  ///    );
  /// }
  ///```
  final Color backgroundColor;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AgendaStyle otherStyle = other;
    return otherStyle.appointmentTextStyle == appointmentTextStyle &&
        otherStyle.dayTextStyle == dayTextStyle &&
        otherStyle.dateTextStyle == dateTextStyle &&
        otherStyle.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode {
    return hashValues(
      appointmentTextStyle,
      dayTextStyle,
      dateTextStyle,
      backgroundColor,
    );
  }
}

/// Sets the style to customize [SfCalendar] month cells.
///
/// If this is not [null] then the style is applied to [SfCalendar] month view
/// month cells.
///
/// ```dart
///Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.Month,
///        dataSource: _getCalendarDataSource(),
///        monthViewSettings: MonthViewSettings(
///            dayFormat: 'EEE',
///            numberOfWeeksInView: 4,
///            appointmentDisplayCount: 2,
///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
///            showAgenda: false,
///            navigationDirection: MonthNavigationDirection.horizontal,
///            monthCellStyle
///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
///            normal, fontSize: 15, color: Colors.black),
///                todayTextStyle: TextStyle(fontStyle: FontStyle.italic,
///                    fontSize: 17,
///                    color: Colors.red),
///                trailingDatesTextStyle: TextStyle(
///                    fontStyle: FontStyle.normal,
///                    fontSize: 15,
///                    color: Colors.black),
///                leadingDatesTextStyle: TextStyle(
///                    fontStyle: FontStyle.normal,
///                    fontSize: 15,
///                    color: Colors.black),
///                backgroundColor: Colors.red,
///                todayBackgroundColor: Colors.blue,
///                leadingDatesBackgroundColor: Colors.grey,
///                trailingDatesBackgroundColor: Colors.grey)),
///      ),
///    );
///  }
///
/// class DataSource extends CalendarDataSource {
///  DataSource(List<Appointment> source) {
///    appointments = source;
///  }
/// }
///
///  DataSource _getCalendarDataSource() {
///    List<Appointment> appointments = <Appointment>[];
///    appointments.add(Appointment(
///      startTime: DateTime.now(),
///      endTime: DateTime.now().add(Duration(hours: 2)),
///      isAllDay: true,
///      subject: 'Meeting',
///      color: Colors.blue,
///      startTimeZone: '',
///      endTimeZone: '',
///    ));
///
///    return DataSource(appointments);
///  }
///
class MonthCellStyle {
  MonthCellStyle({
    this.backgroundColor,
    this.todayBackgroundColor,
    this.trailingDatesBackgroundColor,
    this.leadingDatesBackgroundColor,
    this.textStyle,
    this.todayTextStyle,
    this.trailingDatesTextStyle,
    this.leadingDatesTextStyle,
  });

  /// Sets the text style for the text in the [SfCalendar] month cells.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: false,
  ///            navigationDirection: MonthNavigationDirection.horizontal,
  ///            monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///            normal, fontSize: 15, color: Colors.black),
  ///                todayTextStyle: TextStyle(fontStyle: FontStyle.italic,
  ///                    fontSize: 17,
  ///                    color: Colors.red),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final TextStyle textStyle;

  /// Sets the text style for the text in the today cell of [SfCalendar]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: false,
  ///            navigationDirection: MonthNavigationDirection.horizontal,
  ///            monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///            normal, fontSize: 15, color: Colors.black),
  ///                todayTextStyle: TextStyle(fontStyle: FontStyle.italic,
  ///                    fontSize: 17,
  ///                    color: Colors.red),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final TextStyle todayTextStyle;

  /// Sets the text style for the text in the trailing dates cell of [SfCalendar]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: false,
  ///            navigationDirection: MonthNavigationDirection.horizontal,
  ///            monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///            normal, fontSize: 15, color: Colors.black),
  ///                todayTextStyle: TextStyle(fontStyle: FontStyle.italic,
  ///                    fontSize: 17,
  ///                    color: Colors.red),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final TextStyle trailingDatesTextStyle;

  /// Sets the text style for the text in the leading dates cell of [SfCalendar]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: false,
  ///            navigationDirection: MonthNavigationDirection.horizontal,
  ///            monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///            normal, fontSize: 15, color: Colors.black),
  ///                todayTextStyle: TextStyle(fontStyle: FontStyle.italic,
  ///                    fontSize: 17,
  ///                    color: Colors.red),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final TextStyle leadingDatesTextStyle;

  /// The background color to fill the background of the [SfCalendar] month cell.
  ///
  /// if it is not [null] the color to be applied to the background of the
  /// [SfCalendar] month cell.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: false,
  ///            navigationDirection: MonthNavigationDirection.horizontal,
  ///            monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///            normal, fontSize: 15, color: Colors.black),
  ///                todayTextStyle: TextStyle(fontStyle: FontStyle.italic,
  ///                    fontSize: 17,
  ///                    color: Colors.red),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Color backgroundColor;

  /// The background color to fill the background of the [SfCalendar] today month
  /// cell.
  ///
  /// if it is not [null] the color to be applied to the background of the today
  /// cell of [SfCalendar] month view.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: false,
  ///            navigationDirection: MonthNavigationDirection.horizontal,
  ///            monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///            normal, fontSize: 15, color: Colors.black),
  ///                todayTextStyle: TextStyle(fontStyle: FontStyle.italic,
  ///                    fontSize: 17,
  ///                    color: Colors.red),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Color todayBackgroundColor;

  /// The background color to fill the background of the [SfCalendar] trailing
  /// dates month cell.
  ///
  /// if it is not [null] the color to be applied to the background of the trailing
  /// dates cells of [SfCalendar] month view.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: false,
  ///            navigationDirection: MonthNavigationDirection.horizontal,
  ///            monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///            normal, fontSize: 15, color: Colors.black),
  ///                todayTextStyle: TextStyle(fontStyle: FontStyle.italic,
  ///                    fontSize: 17,
  ///                    color: Colors.red),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Color trailingDatesBackgroundColor;

  /// The background color to fill the background of the [SfCalendar] leading
  /// dates month cell.
  ///
  /// if it is not [null] the color to be applied to the background of the leading
  /// dates cells of [SfCalendar] month view.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        monthViewSettings: MonthViewSettings(
  ///            dayFormat: 'EEE',
  ///            numberOfWeeksInView: 4,
  ///            appointmentDisplayCount: 2,
  ///            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ///            showAgenda: false,
  ///            navigationDirection: MonthNavigationDirection.horizontal,
  ///            monthCellStyle
  ///                : MonthCellStyle(textStyle: TextStyle(fontStyle: FontStyle.
  ///            normal, fontSize: 15, color: Colors.black),
  ///                todayTextStyle: TextStyle(fontStyle: FontStyle.italic,
  ///                    fontSize: 17,
  ///                    color: Colors.red),
  ///                trailingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                leadingDatesTextStyle: TextStyle(
  ///                    fontStyle: FontStyle.normal,
  ///                    fontSize: 15,
  ///                    color: Colors.black),
  ///                backgroundColor: Colors.red,
  ///                todayBackgroundColor: Colors.blue,
  ///                leadingDatesBackgroundColor: Colors.grey,
  ///                trailingDatesBackgroundColor: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Color leadingDatesBackgroundColor;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final MonthCellStyle otherStyle = other;
    return otherStyle.textStyle == textStyle &&
        otherStyle.todayTextStyle == todayTextStyle &&
        otherStyle.trailingDatesTextStyle == trailingDatesTextStyle &&
        otherStyle.leadingDatesTextStyle == leadingDatesTextStyle &&
        otherStyle.backgroundColor == backgroundColor &&
        otherStyle.todayBackgroundColor == todayBackgroundColor &&
        otherStyle.trailingDatesBackgroundColor ==
            trailingDatesBackgroundColor &&
        otherStyle.leadingDatesBackgroundColor == leadingDatesBackgroundColor;
  }

  @override
  int get hashCode {
    return hashValues(
      textStyle,
      todayTextStyle,
      trailingDatesTextStyle,
      leadingDatesTextStyle,
      backgroundColor,
      todayBackgroundColor,
      trailingDatesBackgroundColor,
      leadingDatesBackgroundColor,
    );
  }
}
