part of calendar;

/// All day appointment views default height
const double _kAllDayLayoutHeight = 60;

//// All day appointment height
const double _kAllDayAppointmentHeight = 20;

/// The settings have properties which allow to customize the time slot views
/// of the [SfCalendar].
///
/// If it is not [null] the time slot views will be rendered on the basis of the
/// properties set in this settings.
///
/// ```dart
///Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.workWeek,
///        timeSlotViewSettings: TimeSlotViewSettings(
///            startHour: 10,
///            endHour: 20,
///            nonWorkingDays: <int>[
///              DateTime.saturday,
///              DateTime.sunday,
///              DateTime.friday
///            ],
///            timeInterval: Duration(minutes: 120),
///            timeIntervalHeight: 80,
///            timeFormat: 'h:mm',
///            dateFormat: 'd',
///            dayFormat: 'EEE',
///            timeRulerSize: 70),
///      ),
///    );
///  }
/// ```
class TimeSlotViewSettings {
  TimeSlotViewSettings(
      {this.startHour = 0,
      this.endHour = 24,
      this.nonWorkingDays = const <int>[DateTime.saturday, DateTime.sunday],
      this.timeFormat = 'h a',
      this.timeInterval = const Duration(minutes: 60),
      this.timeIntervalHeight = 40,
      this.timelineAppointmentHeight = 60,
      this.minimumAppointmentDuration,
      this.dateFormat = 'd',
      this.dayFormat = 'EE',
      this.timeRulerSize = -1,
      this.timeTextStyle});

  /// Sets the start hour for the time slot views in [SfCalendar].
  ///
  /// If it is not [null] the time slot views will render from the time set to
  /// this property.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final double startHour;

  /// Sets the end hour for the time slot views in [SfCalendar].
  ///
  /// If it is not [null] the time slot views will render until the time set to
  /// this property.
  ///
  /// Defaults to `24`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final double endHour;

  /// Sets the non working days for the work week view and time slot work week
  /// view in [SfCalendar].
  ///
  /// Defaults to `<int>[DateTime.saturday, DateTime.sunday]`.
  ///
  /// _Note:_ This is only applicable only when the [SfCalendar.view] set as
  /// [CalendarView.workWeek] or [CalendarView.timelineWorkWeek] view.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final List<int> nonWorkingDays;

  /// Defines the time interval between the time slots for time slot views in
  /// [SfCalendar].
  ///
  /// Defaults to `Duration(minutes: 60)`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Duration timeInterval;

  /// The time interval height to layout the each time slot within this in
  /// [SfCalendar] time slot views.
  ///
  /// Defaults to `40`.
  ///
  /// _Note:_ If this property sets with minutes value, the [timeFormat] need to
  /// be modified to display the time labels with minutes.
  ///
  /// See also: [timeFormat].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final double timeIntervalHeight;

  /// Formats the time text in the time slot views of [SfCalendar].
  ///
  /// Defaults to `h a`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final String timeFormat;

  /// The height for an appointment view to layout within this in time line views
  /// of [SfCalendar].
  ///
  /// Defaults to `60`.
  ///
  /// _Note:_ It is applicable only when the [SfCalendar.view] set as
  /// [CalendarView.timelineDay], [CalendarView.timelineWeek] and
  /// [CalendarView.timelineWorkWeek] view in [SfCalendar].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.timelineWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timelineAppointmentHeight: 50,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final double timelineAppointmentHeight;

  /// Sets an arbitrary height for an appointment when it has minimum duration
  /// in time slot views of [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// _Note:_ The value set to this property will be applicable, only when an
  /// [Appointment] duration value lesser than this property.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 60),
  ///            minimumAppointmentDuration: Duration(minutes: 30),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final Duration minimumAppointmentDuration;

  /// Formats the date text in the view header view of [SfCalendar] time slot
  /// views.
  ///
  /// Defaults to `EE`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final String dateFormat;

  /// Formats the day text in the view header view of [SfCalendar] time slot
  /// views.
  ///
  /// Defaults to `d`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final String dayFormat;

  /// The width for the time ruler view to layout with in this in time slot views
  /// of [SfCalendar].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70),
  ///      ),
  ///    );
  ///  }
  /// ```
  final double timeRulerSize;

  /// Sets the text style for the time text in the time slots view of [SfCalendar]
  /// month agenda view.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.timelineWeek,
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            startHour: 10,
  ///            endHour: 20,
  ///            nonWorkingDays: <int>[
  ///              DateTime.saturday,
  ///              DateTime.sunday,
  ///              DateTime.friday
  ///            ],
  ///            minimumAppointmentDuration: Duration(minutes: 30),
  ///            timeInterval: Duration(minutes: 120),
  ///            timeIntervalHeight: 80,
  ///            timeFormat: 'h:mm',
  ///            dateFormat: 'd',
  ///            dayFormat: 'EEE',
  ///            timeRulerSize: 70,
  ///            timeTextStyle: TextStyle(
  ///                fontSize: 15, fontStyle: FontStyle.italic, color: Colors.grey)),
  ///      ),
  ///    );
  ///  }
  /// ```
  final TextStyle timeTextStyle;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final TimeSlotViewSettings otherStyle = other;
    return otherStyle.startHour == startHour &&
        otherStyle.endHour == endHour &&
        otherStyle.nonWorkingDays == nonWorkingDays &&
        otherStyle.timeInterval == timeInterval &&
        otherStyle.timeIntervalHeight == timeIntervalHeight &&
        otherStyle.timeFormat == timeFormat &&
        otherStyle.timelineAppointmentHeight == timelineAppointmentHeight &&
        otherStyle.minimumAppointmentDuration == minimumAppointmentDuration &&
        otherStyle.dateFormat == dateFormat &&
        otherStyle.dayFormat == dayFormat &&
        otherStyle.timeRulerSize == timeRulerSize &&
        otherStyle.timeTextStyle == timeTextStyle;
  }

  @override
  int get hashCode {
    return hashValues(
        startHour,
        endHour,
        nonWorkingDays,
        timeInterval,
        timeIntervalHeight,
        timeFormat,
        timelineAppointmentHeight,
        minimumAppointmentDuration,
        dateFormat,
        dayFormat,
        timeRulerSize,
        timeTextStyle);
  }
}
