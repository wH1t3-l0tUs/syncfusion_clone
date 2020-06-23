part of calendar;

/// Appointment data for calendar.
///
/// An object that contains properties to hold the detailed information about
/// the data, which will be rendered in [SfCalendar].
///
/// _Note:_ The [StartTime] and [EndTime] properties must not be null to render
/// an appointment.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Container(
///      child: SfCalendar(
///        view: CalendarView.day,
///        dataSource: _getCalendarDataSource(),
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
/// DataSource _getCalendarDataSource() {
///    List<Appointment> appointments = <Appointment>[];
///    appointments.add(
///        Appointment(
///          startTime: DateTime.now(),
///          endTime: DateTime.now().add(
///              Duration(hours: 2)),
///          isAllDay: true,
///          subject: 'Meeting',
///          color: Colors.blue,
///          startTimeZone: '',
///          endTimeZone: ''
///        ));
///
///   return DataSource(appointments);
/// }
///  ```
class Appointment {
  Appointment({
    this.startTimeZone,
    this.endTimeZone,
    this.recurrenceRule,
    this.isAllDay = false,
    this.notes,
    this.location,
    DateTime startTime,
    DateTime endTime,
    String subject,
    Color color,
    List<DateTime> recurrenceExceptionDates,
  })  : startTime = startTime ?? DateTime.now(),
        endTime = endTime ?? DateTime.now(),
        subject = subject == null ? '' : subject,
        _actualStartTime = startTime,
        _actualEndTime = endTime,
        color = color ?? Colors.lightBlue,
        recurrenceExceptionDates = recurrenceExceptionDates ?? <DateTime>[],
        _isSpanned = false;

  /// Defines the start time for an [Appointment] in [SfCalendar].
  ///
  /// If it is not [null] the appointment will start from the time set to this
  /// property.
  ///
  /// Defaults to `DateTime.now()`.
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
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: ''
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  DateTime startTime;

  /// Defines the end time for an [Appointment] in [SfCalendar].
  ///
  /// If it is not [null] the appointment will end on the time set to this
  /// property.
  ///
  /// Defaults to `DateTime.now()`.
  ///
  /// _Note:_ If this property set with the time prior to the [startTime], then
  /// the [Appointment] will render with half hour time period from the
  /// [startTime].
  ///
  /// If the difference between [startTime] and [endTime] is greater than 24 hourt
  /// the appointment will be rendered on the all day panel of the time slot views
  /// in [SfCalendar].
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
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: ''
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  DateTime endTime;

  /// An [Appointment] rendered between the given [startTime] and [endTime]
  /// in the time slots of the time slot view in [SfCalendar] by default.
  ///
  /// If it is set as [true] the appointment's [startTime] and [endTime] will be
  /// ignored and the appointment will be rendered on the all day panel area of
  /// the time slot views.
  ///
  /// Defaults to `false`.
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
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: ''
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  bool isAllDay = false;

  /// Defines the subject of calendar appointment.
  ///
  /// Defines the subject for the [Appointment] in [SfCalendar].
  ///
  /// If it is not [null] the appointment view will display the text set to this
  /// property.
  ///
  /// Defaults to ` ` represents empty string.
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
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///   appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: ''
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  String subject;

  /// The color that fills the background of the [Appointment] view in [SfCalendar].
  ///
  /// Defaults to `Colors.lightBlue`.
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
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: ''
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  Color color;

  /// The appointment will render based on the devices local time zone by default
  /// in [SfCalendar].
  ///
  /// Defines the start time zone for an [Appointment] in [SfCalendar].
  ///
  /// If it is not [null] the appointment start time will be calculated based on
  /// the time zone set to this property and [SfCalendar.timeZone] property.
  ///
  /// Defaults to null.
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
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: ''
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  String startTimeZone;

  /// The appointment will render based on the devices local time zone by default
  /// in [SfCalendar].
  ///
  /// Defines the end time zone for an [Appointment] in [SfCalendar].
  ///
  /// If it is not [null] the appointment end time will be calculated based on the
  /// time zone set to this property and [SfCalendar.timeZone] property.
  ///
  /// Defaults to null.
  ///
  /// _Note:_ If the [startTimeZone] and [endTimeZone] set as different time zone's
  /// and it's value falls invalid, the appointment will render with half an hour
  /// duration from the start time of the appointment.
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
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: ''
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  String endTimeZone;

  /// An [Appointment] will render the one appointment view for the given [startTime]
  /// and [endTime] in [SfCalendar].
  ///
  /// If it is not [null] the appointment will be recurred multiple times based
  /// on the [RecurrenceProperties] set to this property.
  ///
  /// The recurrence rule can be generated using the [SfCalendar.rRuleGenerator]
  /// method in [Calendar].
  ///
  /// The recurrence rule can be directly set this property like
  /// 'FREQ=DAILY;INTERVAL=1;COUNT=3'.
  ///
  /// Defaults to null.
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
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  /// }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    RecurrenceProperties recurrence = new RecurrenceProperties();
  ///    recurrence.recurrenceType = RecurrenceType.daily;
  ///    recurrence.interval = 2;
  ///    recurrence.recurrenceRange = RecurrenceRange.count;
  ///    recurrence.recurrenceCount = 10;
  ///    appointments.add(
  ///        Appointment(
  ///          startTime: DateTime.now(),
  ///          endTime: DateTime.now().add(
  ///              Duration(hours: 2)),
  ///          isAllDay: true,
  ///          subject: 'Meeting',
  ///          color: Colors.blue,
  ///          startTimeZone: '',
  ///          endTimeZone: '',
  ///          recurrenceRule: SfCalendar.rRuleGenerator(recurrence, DateTime.now(), DateTime.now().add(
  ///              Duration(hours: 2)))
  ///        ));
  ///
  ///   return DataSource(appointments);
  /// }
  ///  ```
  String recurrenceRule;

  /// An [Appointment] with [recurrenceRule] will recur on all the possible dates
  /// given by the [recurrenceRule].
  ///
  /// If it is not [null] the recurrence appointment occurrence can be deleted
  /// and the appointment will not occur on the dates set to this property in
  /// [Calendar].
  ///
  /// Defaults to `<DateTime>[]`.
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
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    RecurrenceProperties recurrence = new RecurrenceProperties();
  ///    recurrence.recurrenceType = RecurrenceType.daily;
  ///    recurrence.interval = 2;
  ///    recurrence.recurrenceRange = RecurrenceRange.noEndDate;
  ///    recurrence.recurrenceCount = 10;
  ///    appointments.add(
  ///        Appointment(
  ///            startTime: DateTime.now(),
  ///            endTime: DateTime.now().add(
  ///                Duration(hours: 2)),
  ///            isAllDay: true,
  ///            subject: 'Meeting',
  ///            color: Colors.blue,
  ///            startTimeZone: '',
  ///            notes: '',
  ///            location: '',
  ///            endTimeZone: '',
  ///            recurrenceRule: RecurrenceHelper.rRuleGenerator(
  ///                recurrence, DateTime.now(), DateTime.now().add(
  ///                Duration(hours: 2))),
  ///            recurrenceExceptionDates: [
  ///              DateTime.now().add(Duration(days: 2))
  ///            ]
  ///        ));
  ///
  ///    return DataSource(appointments);
  ///  }
  ///  ```
  List<DateTime> recurrenceExceptionDates;

  /// Defines the notes for an [Appointment] in [SfCalendar].
  ///
  /// Allow to store additional information about the [Appointment] and can be
  /// obtained through the [Appointment] object.
  ///
  /// Defaults to null.
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
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    RecurrenceProperties recurrence = new RecurrenceProperties();
  ///    recurrence.recurrenceType = RecurrenceType.daily;
  ///    recurrence.interval = 2;
  ///    recurrence.recurrenceRange = RecurrenceRange.noEndDate;
  ///    recurrence.recurrenceCount = 10;
  ///    appointments.add(
  ///        Appointment(
  ///            startTime: DateTime.now(),
  ///            endTime: DateTime.now().add(
  ///                Duration(hours: 2)),
  ///            isAllDay: true,
  ///            subject: 'Meeting',
  ///            color: Colors.blue,
  ///            startTimeZone: '',
  ///            notes: '',
  ///            location: '',
  ///            endTimeZone: '',
  ///            recurrenceRule: RecurrenceHelper.rRuleGenerator(
  ///                recurrence, DateTime.now(), DateTime.now().add(
  ///                Duration(hours: 2))),
  ///            recurrenceExceptionDates: [
  ///              DateTime.now().add(Duration(days: 2))
  ///            ]
  ///        ));
  ///
  ///    return DataSource(appointments);
  ///  }
  ///  ```
  String notes;

  /// Defines the location for an [Appointment] in [SfCalendar].
  ///
  /// Allow to store locaion information about the [Appointment] and can be
  /// obtained through the [Appointment] object.
  ///
  /// Defaults to null.
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
  /// class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source) {
  ///    appointments = source;
  ///  }
  /// }
  ///
  /// DataSource _getCalendarDataSource() {
  ///    List<Appointment> appointments = <Appointment>[];
  ///    RecurrenceProperties recurrence = new RecurrenceProperties();
  ///    recurrence.recurrenceType = RecurrenceType.daily;
  ///    recurrence.interval = 2;
  ///    recurrence.recurrenceRange = RecurrenceRange.noEndDate;
  ///    recurrence.recurrenceCount = 10;
  ///    appointments.add(
  ///        Appointment(
  ///            startTime: DateTime.now(),
  ///            endTime: DateTime.now().add(
  ///                Duration(hours: 2)),
  ///            isAllDay: true,
  ///            subject: 'Meeting',
  ///            color: Colors.blue,
  ///            startTimeZone: '',
  ///            notes: '',
  ///            location: '',
  ///            endTimeZone: '',
  ///            recurrenceRule: RecurrenceHelper.rRuleGenerator(
  ///                recurrence, DateTime.now(), DateTime.now().add(
  ///                Duration(hours: 2))),
  ///            recurrenceExceptionDates: [
  ///              DateTime.now().add(Duration(days: 2))
  ///            ]
  ///        ));
  ///
  ///    return DataSource(appointments);
  ///  }
  ///  ```
  String location;

  //Used for referring items in ItemsSource of Schedule.
  Object _data;

  // ignore: prefer_final_fields
  DateTime _actualStartTime;

  // ignore: prefer_final_fields
  DateTime _actualEndTime;

  // ignore: prefer_final_fields
  bool _isSpanned = false;
}
