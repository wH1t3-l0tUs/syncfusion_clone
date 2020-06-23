part of calendar;

/// An object that maintains the data source for [SfCalendar].
///
/// Allows to map the custom appointments to the [Appointment] and set the
/// appointments collection to the [SfCalendar] to render the appointments
/// on view.
///
/// Allows to add and remove an [Appointment] from the collection and also
/// allows to reset the appointment collection for [SfCalendar].
///
/// ```dart
///Widget build(BuildContext context) {
///   return Container(
///      child: SfCalendar(
///        view: CalendarView.day,
///        dataSource: _getCalendarDataSource(),
///      ),
///    );
///  }
///
/// class MeetingDataSource extends CalendarDataSource {
///  MeetingDataSource(List<_Meeting> source) {
///    appointments = source;
///  }
///
///  @override
///  DateTime getStartTime(int index) {
///    return appointments[index].from;
///  }
///
///  @override
///  DateTime getEndTime(int index) {
///    return appointments[index].to;
///  }
///
///  @override
///  Color getColor(int index) {
///    return appointments[index].background;
///  }
///
///  @override
///  String getEndTimeZone(int index) {
///    return appointments[index].toZone;
///  }
///
///  @override
///  List<DateTime> getRecurrenceExceptionDates(int index) {
///    return appointments[index].exceptionDates;
///  }
///
///  @override
///  String getRecurrenceRule(int index) {
///    return appointments[index].recurrenceRule;
///  }
///
///  @override
///  String getStartTimeZone(int index) {
///    return appointments[index].fromZone;
///  }
///
///  @override
///  String getSubject(int index) {
///    return appointments[index].title;
///  }
///
///  @override
///  bool isAllDay(int index) {
///    return appointments[index].isAllDay;
///  }
/// }
///
/// class Meeting {
///  Meeting(
///      {this.from,
///      this.to,
///      this.title,
///      this.isAllDay,
///      this.background,
///      this.fromZone,
///      this.toZone,
///      this.exceptionDates,
///      this.recurrenceRule});
///
///  DateTime from;
///  DateTime to;
///  String title;
///  bool isAllDay;
///  Color background;
///  String fromZone;
///  String toZone;
///  String recurrenceRule;
///  List<DateTime> exceptionDates;
/// }
///
/// final DateTime date = DateTime.now();
///  MeetingDataSource _getCalendarDataSource() {
///    List<Meeting> appointments = <Meeting>[];
///    appointments.add(Meeting(
///     from: date,
///     to: date.add(const Duration(hours: 1)),
///     title: 'General Meeting',
///     isAllDay: false,
///     background: Colors.red,
///     fromZone: '',
///     toZone: '',
///     recurrenceRule: '',
///     exceptionDates: null
///  ));
///
///    return MeetingDataSource(appointments);
///  }
///  ```
abstract class CalendarDataSource extends CalendarDataSourceChangeNotifier {
  /// Tha collection of appointments to be rendered on [SfCalendar].
  ///
  /// Defaults to `null`.
  ///
  /// ```dat
  ///
  /// class _AppointmentDataSource extends CalendarDataSource {
  ///  _AppointmentDataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///```
  List<dynamic> appointments;

  /// Maps the custom appointments start time to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s start time property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// It is mandatory to override this method to set custom appointments collection
  /// to the [appointments].
  ///
  /// See also: [Appointment.startTime]
  ///
  /// ```dart
  ///  @override
  ///  DateTime getStartTime(int index) {
  ///    return appointments[index].from;
  ///  }
  /// ```
  @protected
  DateTime getStartTime(int index) => null;

  /// Maps the custom appointments end time to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s end time property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// It is mandatory to override this method to set custom appointments collection
  /// to the [appointments].
  ///
  /// See also: [Appointment.endTime]
  ///
  /// ```dart
  ///  @override
  ///  DateTime getStartTime(int index) {
  ///    return appointments[index].to;
  ///  }
  /// ```
  @protected
  DateTime getEndTime(int index) => null;

  /// Maps the custom appointments subject to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s subject property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also: [Appointment.subject]
  ///
  /// ```dart
  ///  @override
  ///  DateTime getStartTime(int index) {
  ///    return appointments[index].title;
  ///  }
  /// ```
  @protected
  String getSubject(int index) => '';

  /// Maps the custom appointments isAllDay to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s isAllDay property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also: [Appointment.isAllDay]
  ///
  /// ```dart
  ///  @override
  ///  DateTime getStartTime(int index) {
  ///    return appointments[index].isAllDay;
  ///  }
  /// ```
  @protected
  bool isAllDay(int index) => false;

  /// Maps the custom appointments color to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s color property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also: [Appointment.color]
  ///
  /// ```dart
  ///  @override
  ///  DateTime getStartTime(int index) {
  ///    return appointments[index].background;
  ///  }
  /// ```
  @protected
  Color getColor(int index) => Colors.lightBlue;

  /// Maps the custom appointments notes to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s notes property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also: [Appointment.notes]
  ///
  /// ```dart
  ///  @override
  ///  DateTime getStartTime(int index) {
  ///    return appointments[index].notes;
  ///  }
  /// ```
  @protected
  String getNotes(int index) => '';

  /// Maps the custom appointments location to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s location property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also: [Appointment.location].
  ///
  /// ```dart
  ///  @override
  ///  DateTime getStartTime(int index) {
  ///    return appointments[index].place;
  ///  }
  /// ```
  @protected
  String getLocation(int index) => '';

  /// Maps the custom appointments start time zone to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s start time zone property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also: [Appointment.startTimeZone].
  ///
  /// ```dart
  ///  @override
  ///  DateTime getStartTime(int index) {
  ///    return appointments[index].fromZone;
  ///  }
  /// ```
  @protected
  String getStartTimeZone(int index) => '';

  /// Maps the custom appointments end time zone to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s end time zone property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also: [Appointment.endTimeZone].
  ///
  /// ```dart
  ///  @override
  ///  DateTime getStartTime(int index) {
  ///    return appointments[index].toZone;
  ///  }
  /// ```
  @protected
  String getEndTimeZone(int index) => '';

  /// Maps the custom appointments recurrence rule to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s recurrence rule property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also: [Appointment.recurrenceRule].
  ///
  /// ```dart
  ///  @override
  ///  DateTime getStartTime(int index) {
  ///    return appointments[index].recurrenceRule;
  ///  }
  /// ```
  @protected
  String getRecurrenceRule(int index) => '';

  /// Maps the custom appointments recurrenceExceptionDates to the [Appointment].
  ///
  /// Allows to set the custom appointments corresponding property to the
  /// [Appointment]'s recurrenceExceptionDates property.
  ///
  /// _Note:_ It is applicable only when the custom appointments set to the
  /// [appointments].
  ///
  /// See also: [Appointment.recurrenceExceptionDates].
  ///
  /// ```dart
  ///  @override
  ///  DateTime getStartTime(int index) {
  ///    return appointments[index].exceptionDates;
  ///  }
  /// ```
  @protected
  List<DateTime> getRecurrenceExceptionDates(int index) => null;
}

//// Data source callback used to perform operation while data source changed.
typedef CalendarDataSourceCallback = void Function(
    CalendarDataSourceAction, List<dynamic>);

//// Data source notifier used to notify the action performed in data source
class CalendarDataSourceChangeNotifier {
  List<CalendarDataSourceCallback> _listeners;

  //// Add the listener used to callback when data source changed.
  void addListener(CalendarDataSourceCallback _listener) {
    _listeners ??= <CalendarDataSourceCallback>[];
    _listeners.add(_listener);
  }

  //// remove the listener used for notify the data source changes.
  void removeListener(CalendarDataSourceCallback _listener) {
    if (_listeners == null) {
      return;
    }

    _listeners.remove(_listener);
  }

  //// Notify to the listener while data source changed.
  void notifyListeners(CalendarDataSourceAction type, List<dynamic> data) {
    if (_listeners == null) {
      return;
    }

    for (CalendarDataSourceCallback listener in _listeners) {
      if (listener != null) {
        listener(type, data);
      }
    }
  }

  @mustCallSuper
  void dispose() {
    _listeners = null;
  }
}
