part of calendar;

/// Returns the list of current view visible dates.
typedef ViewChangedCallback = void Function(
    ViewChangedDetails viewChangedDetails);

/// Returns the selected date and appointment details.
typedef CalendarTapCallback = void Function(
    CalendarTapDetails calendarTapDetails);

typedef _UpdateCalendarState = void Function(
    _UpdateCalendarStateDetails _updateCalendarStateDetails);

/// A material design calendar.
///
/// Used to scheduling and managing events.
///
/// The [SfCalendar] has built-in configurable views that provide basic
/// functionalities for scheduling and representing [Appointment]'s or events
/// efficiently. It supports [minDate] and [maxDate] to restrict the date selection.
///
/// By default it displays [CalendarView.day] view with current date visible.
///
/// To navigate to different views set [view] property with a desired [CalendarView].
///
/// To restrict the date navigation and selection interaction use [minDate],
/// [maxDate], the dates beyond this will be restricted.
///
/// Set the [Appointment]'s or custom events collection to [dataSource] property
/// by using the [CalendarDataSource].
///
/// When the visible view changes the widget calls the [onViewChanged] callback
/// with the current view visible dates.
///
/// When an any of [CalendarElement] tapped the widget calls the [onTap] callback
/// with selected date, appointments and selected calendar element details.
///
/// _Note:_ The calendar widget allows to customize its appearance using [SfCalendarThemeData]
/// available from [SfCalendarTheme] widget or the [SfTheme.calendarTheme] widget.
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
///  DataSource _getCalendarDataSource() {
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
///          endTimeZone: '',
///        ));
///
///    return DataSource(appointments);
///  }
///  ```
class SfCalendar extends StatefulWidget {
  SfCalendar({
    Key key,
    CalendarView view,
    this.firstDayOfWeek = 7,
    this.headerHeight = 40,
    this.viewHeaderHeight = -1,
    this.todayHighlightColor,
    this.cellBorderColor,
    this.backgroundColor,
    this.dataSource,
    this.timeZone,
    this.selectionDecoration,
    this.onViewChanged,
    this.onTap,
    this.controller,
    CalendarHeaderStyle headerStyle,
    ViewHeaderStyle viewHeaderStyle,
    TimeSlotViewSettings timeSlotViewSettings,
    MonthViewSettings monthViewSettings,
    DateTime initialDisplayDate,
    DateTime initialSelectedDate,
    DateTime minDate,
    DateTime maxDate,
    TextStyle appointmentTextStyle,
  })  : view = view ?? CalendarView.day,
        appointmentTextStyle = appointmentTextStyle ??
            TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto'),
        headerStyle = headerStyle ?? CalendarHeaderStyle(),
        viewHeaderStyle = viewHeaderStyle ?? ViewHeaderStyle(),
        timeSlotViewSettings = timeSlotViewSettings ?? TimeSlotViewSettings(),
        monthViewSettings = monthViewSettings ?? MonthViewSettings(),
        initialSelectedDate =
            controller != null && controller.selectedDate != null
                ? controller.selectedDate
                : initialSelectedDate,
        initialDisplayDate =
            controller != null && controller.displayDate != null
                ? controller.displayDate
                : initialDisplayDate ??
                    DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day, 08, 45, 0),
        minDate = minDate ?? DateTime(0001, 01, 01),
        maxDate = maxDate ?? DateTime(9999, 12, 31),
        super(key: key);

  /// Defines the view for the [SfCalendar].
  ///
  /// Defaults to `CalendarView.day`.
  ///
  /// Also refer: [CalendarView].
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///      ),
  ///    );
  ///  }
  ///
  ///  ```
  final CalendarView view;

  /// The [SfCalendar] will navigate as minimum as to the date of 01, 01, 0001
  /// and the dates before that will be disabled and navigation to those dates
  /// were restricted by default.
  ///
  /// If it is not [null] the widget will navigate as minimum as to the given date,
  /// and the dates before that date will be disabled for interaction and navigation
  /// to those dates were restricted.
  ///
  /// Defaults to DateTime of 01, 01, 0001.
  ///
  /// _Note:_ If the [initialDisplayDate] property set with the date prior to this
  /// date, the [SfCalendar] will take this date as a display date and render
  /// dates based on the date set to this property.
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        minDate: new DateTime(2019, 12, 14, 9, 0, 0),
  ///      ),
  ///    );
  ///  }
  ///
  ///  ```
  final DateTime minDate;

  /// The [SfCalendar] will navigate as maximum as to the date of 31, 12, 9999
  /// and the dates after that will be disabled and navigation to those dates
  /// were restricted by default.
  ///
  /// if it is not [null] the widget will navigate as maximum as to the given date,
  /// and the dates after that date will be disabled for interaction and navigation
  /// to those dates were restricted.
  ///
  /// Defaults to DateTime of 31, 12, 9999.
  ///
  /// _Note:_ If the [initialDisplayDate] property set with the date after to this
  /// date, the [SfCalendar] will take this date as a display date and render
  /// dates based on the date set to this property.
  ///
  /// ``` dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        maxDate: new DateTime(2020, 01, 15, 9, 0, 0),
  ///      ),
  ///    );
  ///  }
  ///
  ///  ```
  final DateTime maxDate;

  /// Sets the first day of the week in the [SfCalendar].
  ///
  /// If this is not [null] every week in all the possible view will start from
  /// the day set to this property.
  ///
  /// Defaults to `7` which indicates `DateTime.sunday`.
  ///
  /// ``` dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        firstDayOfWeek: 3,
  ///      ),
  ///    );
  ///  }
  ///
  ///  ```
  final int firstDayOfWeek;

  /// The color which fills the border of every calendar cells in day, week,
  /// workweek, month, timeline day, timeline week and timeline workweek views
  /// of [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// ``` dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.day,
  ///        cellBorderColor: Colors.grey,
  ///      ),
  ///    );
  ///  }
  ///
  ///```
  final Color cellBorderColor;

  /// Sets the style for customizing the [SfCalendar] header view.
  ///
  /// If this is not [null] then the style is applied to the calendar
  /// header view.
  ///
  /// Defaults to instance of `CalendarHeaderStyle`.
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
  final CalendarHeaderStyle headerStyle;

  /// Sets the style to customize [SfCalendar] view header.
  ///
  /// If this is not [null] then the style is applied to [SfCalendar] view header
  /// for all applicable views.
  ///
  /// Defaults to instance of `ViewHeaderStyle`.
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
  final ViewHeaderStyle viewHeaderStyle;

  /// The height for header view to layout within this.
  ///
  /// If it is not [null] the header will layout within the given height.
  ///
  /// Defaults to `40`.
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        headerHeight: 100,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double headerHeight;

  /// Sets the text style for the text in the [Appointment] view in all possible
  /// views of [SfCalendar].
  ///
  /// If it is not [null] the [Appointment] text will be displayed with the
  /// style set to this property.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.workWeek,
  ///        appointmentTextStyle: TextStyle(
  ///                fontSize: 12,
  ///                fontWeight: FontWeight.w500,
  ///                color: Colors.blue,
  ///                fontStyle: FontStyle.italic)
  ///      ),
  ///    );
  ///  }
  ///
  ///  ```
  final TextStyle appointmentTextStyle;

  /// The height of the view header to the layout within this in [SfCalendar].
  ///
  /// If it is not [null] the [SfCalendar] view header will layout within the
  /// given height.
  ///
  /// Defaults to `-1`.
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        viewHeaderHeight: 100,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double viewHeaderHeight;

  /// Color that highlights the today cell in month view, and view header of
  /// day/week/workweek, timeline view and highlights the date in month agenda
  /// view in [SfCalendar].
  ///
  /// If it is not [null] today cell and text in all possible views will be
  /// highlighted with the given color.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        todayHighlightColor: Colors.red,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color todayHighlightColor;

  /// The background color to fill the background of the [SfCalendar].
  ///
  /// if it is not [null] the color to be applied to the background of the
  /// [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        backgroundColor: Colors.transparent,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color backgroundColor;

  /// The settings have properties which allow to customize the time slot views
  /// of the [SfCalendar].
  ///
  /// If it is not [null] the time slot views will be rendered on the basis of the
  /// properties set in this settings.
  ///
  /// Defaults to instance of 'TimeSlotViewSettings'.
  ///
  /// ```dart
  ///
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
  ///
  /// ```
  final TimeSlotViewSettings timeSlotViewSettings;

  /// The settings have properties which allow to customize the month view of
  /// the [SfCalendar].
  ///
  /// If it is not [null] the month view will be rendered on the basis of the
  /// properties set in this settings.
  ///
  /// Defaults to instance of 'MonthViewSettings'.
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
  final MonthViewSettings monthViewSettings;

  /// Sets the decoration for the selection cells of [SfCalendar] in all applicable
  /// views.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.Month,
  ///        selectionDecoration: BoxDecoration(
  ///           color: Colors.transparent,
  ///             border:
  ///               Border.all(color: const Color.fromARGB(255, 68, 140, 255), width: 2),
  ///             borderRadius: const BorderRadius.all(Radius.circular(4)),
  ///             shape: BoxShape.rectangle,
  ///         );,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Decoration selectionDecoration;

  /// The [SfCalendar] will display the dates based on current date by default.
  ///
  /// if it is not [null] the [SfCalendar] will display the dates based
  /// on the date set in this property.
  ///
  /// Defaults to `DateTime(DateTime.now().year, DateTime.now().month,
  /// DateTime.now().day, 08, 45, 0)`.
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        initialDisplayDate: DateTime(2020, 02, 05, 10, 0, 0),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateTime initialDisplayDate;

  /// The [SfCalendar] will function based on the device's local time zone.
  ///
  /// If it is not [null] the calendar will function based on the time zone set
  /// to this property.
  ///
  /// If the [Appointment.startTimeZone] and [Appointment.endTimeZone] set as
  /// [null] the appointments will be displayed in UTC time based on the
  /// time zone set to this property.
  ///
  /// If the [Appointment.startTimeZone] and [Appointment.endTimeZone] set as not
  /// [null] the appointments will be displayed based by calculating the
  /// appointment's startTimeZone and endTimeZone based on the time zone set to
  /// this property.
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// [Appointment.startTimeZone].
  /// [Appointment.endTimeZone].
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        timeZone: 'Atlantic Standard Time',
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final String timeZone;

  /// The [SfCalendar] will render without any selection on the view by
  /// default.
  ///
  /// if it is not [null] the [SfCalendar] will select the date that set
  /// to this property.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        initialSelectedDate: DateTime(2019, 12, 12, 11, 0, 0),
  ///      ),
  ///   );
  ///  }
  ///
  /// ```
  final DateTime initialSelectedDate;

  /// A callback that return the current view visible dates in [SfCalendar].
  ///
  /// The callback will be called whenever the current view, visible dates
  /// changes on the view and returns the [ViewChangedDetails.visibleDates]
  /// details.
  ///
  /// See also: [ViewChangedDetails].
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        onViewChanged: (ViewChangedDetails details){
  ///          List<DateTime> dates = details.visibleDates;
  ///        },
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final ViewChangedCallback onViewChanged;

  /// A callback that returns the selected date, element and appointments on
  /// [SfCalendar].
  ///
  /// The callback will be called whenever the calendar elements like header,
  /// view header, calendar cells and appointment tapped on view and it returns
  /// the [CalendarTapDetails.selectedDate], [CalendarTapDetails.appointments]
  /// and [CalendarTapDetails.targetElement].
  ///
  /// see also: [CalendarTapDetails].
  ///
  /// ```dart
  ///
  ///return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        onTap: (CalendarTapDetails details){
  ///          DateTime date = details.date;
  ///          dynamic appointments = details.appointments;
  ///          String view = details.targetElement;
  ///        },
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final CalendarTapCallback onTap;

  /// Used to set the [Appointment] or custom event collection through the
  /// [CalendarDataSource] class.
  ///
  /// If it is not [null] the collection of appointments set to the
  /// [CalendarDataSource.appointments] property will be set to [SfCalendar] and
  /// rendered on view.
  ///
  /// Defaults to null.
  ///
  /// see also: [CalendarDataSource]
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        dataSource: _getCalendarDataSource(),
  ///        timeSlotViewSettings: TimeSlotViewSettings(
  ///            appointmentTextStyle: TextStyle(
  ///                fontSize: 12,
  ///                fontWeight: FontWeight.w500,
  ///                color: Colors.blue,
  ///                fontStyle: FontStyle.italic)
  ///        ),
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
  /// ```
  final CalendarDataSource dataSource;

  /// An object that used for programmatic date navigation, date selection
  /// in [SfCalendar].
  ///
  /// A [CalendarController] served for several purposes. It can be used
  /// to selected dates programmatically on [SfCalendar] by using the
  /// [controller.selectedDate]. It can be used to navigate to specific date
  /// by using the [controller.displayDate] property.
  ///
  /// The [CalendarController] can be listened by adding a listener to the
  /// controller, the listener will listen and notify whenever the selected date,
  /// display date changed in the [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// This example demonstrates how to use the [CalendarController] for [SfCalendar].
  ///
  /// ```dart
  ///
  /// class MyAppState extends State<MyApp>{
  ///
  ///  CalendarController _calendarController;
  ///  @override
  ///  initState(){
  ///    _calendarController = CalendarController();
  ///    _calendarController.selectedDate = DateTime(2022, 02, 05);
  ///    _calendarController.displayDate = DateTime(2022, 02, 05);
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfCalendar(
  ///          view: CalendarView.month,
  ///          controller: _calendarController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  //}
  /// ```
  final CalendarController controller;

  /// Returns the date time collection at which the recurrence appointment will
  /// recur
  ///
  /// Using this method the recurrence appointments occurrence date time collection
  /// can be obtained.
  ///
  /// * rRule - required - the recurrence rule of the appointment
  /// * recurrenceStartDate - required - the start date in which the recurrence starts.
  /// * specificStartDate - optional - the specific start date, used to get the
  /// date collection for a specific interval of dates.
  /// * specificEndDate - optional - the specific end date, used to get the date
  /// collection for a specific interval of dates.
  ///
  ///
  /// return `List<DateTime>`
  ///
  ///```dart
  ///
  /// DateTime dateTime = DateTime(2020, 03, 15);
  /// List<DateTime> dateCollection = SfCalendar.getRecurrenceDateTimeCollection(
  ///    'FREQ=DAILY;INTERVAL=1;COUNT=3', dateTime);
  ///
  /// ```
  static List<DateTime> getRecurrenceDateTimeCollection(
      String rRule, DateTime recurrenceStartDate,
      {DateTime specificStartDate, DateTime specificEndDate}) {
    return _getRecurrenceDateTimeCollection(rRule, recurrenceStartDate,
        specificStartDate: specificStartDate, specificEndDate: specificEndDate);
  }

  /// Returns the recurrence properties based on the given recurrence rule and
  /// the recurrence start date.
  ///
  /// Used to get the recurrence properties from the given recurrence rule.
  ///
  /// * rRule - optional - recurrence rule for the properties required
  /// * recStartDate - optional - start date of the recurrence rule for which the
  /// properties required.
  ///
  /// returns `RecurrenceProperties`.
  ///
  /// ```dart
  ///
  /// DateTime dateTime = DateTime(2020, 03, 15);
  /// RecurrenceProperties recurrenceProperties =
  ///    SfCalendar.parseRRule('FREQ=DAILY;INTERVAL=1;COUNT=1', dateTime);
  ///
  /// ```
  static RecurrenceProperties parseRRule(String rRule, DateTime recStartDate) {
    return _parseRRule(rRule, recStartDate);
  }

  /// Generates the recurrence rule based on the given recurrence properties and
  /// the start date and end date of the recurrence appointment.
  ///
  /// Used to generate recurrence rule based on the recurrence properties.
  ///
  /// * recurrenceProperties - required - the recurrence properties to generate
  /// the recurrence rule.
  /// * appStartTime - required - the recurrence appointment start time.
  /// * appEndTime - required - the recurrence appointment end time.
  ///
  /// returns `String`.
  ///
  /// ```dart
  ///
  /// RecurrenceProperties recurrenceProperties = RecurrenceProperties();
  //recurrenceProperties.recurrenceType = RecurrenceType.daily;
  //recurrenceProperties.recurrenceRange = RecurrenceRange.count;
  //recurrenceProperties.interval = 2;
  //recurrenceProperties.recurrenceCount = 10;
  //
  ///Appointment appointment = Appointment(
  ///    startTime: DateTime(2019, 12, 16, 10),
  ///    endTime: DateTime(2019, 12, 16, 12),
  ///    subject: 'Meeting',
  ///    color: Colors.blue,
  ///    recurrenceRule: SfCalendar.generateRRule(recurrenceProperties,
  ///        DateTime(2019, 12, 16, 10), DateTime(2019, 12, 16, 12)));
  ///
  /// ```
  static String generateRRule(RecurrenceProperties recurrenceProperties,
      DateTime appStartTime, DateTime appEndTime) {
    return _generateRRule(recurrenceProperties, appStartTime, appEndTime);
  }

  @override
  _SfCalendarState createState() => _SfCalendarState();
}

class _SfCalendarState extends State<SfCalendar> {
  List<DateTime> _currentViewVisibleDates;
  DateTime _currentDate, _selectedDate;
  List<Appointment> _visibleAppointments;
  List<_AppointmentView> _allDayAppointmentViewCollection =
      <_AppointmentView>[];
  double _allDayPanelHeight = 0;
  ScrollController _agendaScrollController;
  ValueNotifier<DateTime> _agendaSelectedDate;
  String _locale;
  SfLocalizations _localizations;
  double _minWidth, _minHeight, _topPadding;
  SfCalendarThemeData _calendarTheme;

  //// Used to notify the time zone data base loaded or not.
  //// Example, initially appointment added on visible date changed callback then
  //// data source changed listener perform operation but the time zone data base
  //// not initialized, so it makes error.
  bool _timeZoneLoaded = false;
  List<Appointment> _appointments;
  CalendarController _controller;

  /// loads the time zone data base to handle the time zone for calendar
  Future<bool> _loadDataBase() async {
    final dynamic byteData =
        await rootBundle.load('packages/timezone/data/2019c.tzf');
    initializeDatabase(byteData.buffer.asUint8List());
    _timeZoneLoaded = true;
    return true;
  }

  /// Generates the calendar appointments from the given data source, and
  /// time zone details
  void _getAppointment() {
    _appointments = _generateCalendarAppointments(widget.dataSource, widget);
    _updateVisibleAppointments();
  }

  /// Updates the visible appointments for the calendar
  // ignore: avoid_void_async
  void _updateVisibleAppointments() async {
    // ignore: await_only_futures
    _visibleAppointments = await _getVisibleAppointments(
        _currentViewVisibleDates[0],
        _currentViewVisibleDates[_currentViewVisibleDates.length - 1],
        _appointments,
        widget.timeZone,
        widget.view == CalendarView.month || _isTimelineView(widget.view));
    //// Update all day appointment related implementation in calendar, because time label view needs the top position.
    _updateAllDayAppointment();
    //// mounted property in state return false when the state disposed,
    //// restrict the async method set state after the state disposed.
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (_agendaScrollController != null) {
      _agendaScrollController.dispose();
      _agendaScrollController = null;
    }

    _controller.removePropertyChangedListener(_calendarValueChangedListener);
    super.dispose();
  }

  @override
  void initState() {
    _timeZoneLoaded = false;
    initializeDateFormatting();
    _loadDataBase().then((dynamic value) => _getAppointment());
    _controller = widget.controller ?? CalendarController();
    _controller.selectedDate = widget.initialSelectedDate;
    _selectedDate = widget.initialSelectedDate;
    _agendaSelectedDate = ValueNotifier<DateTime>(widget.initialSelectedDate);
    _agendaSelectedDate.addListener(_agendaSelectedDateListener);
    _currentDate =
        getValidDate(widget.minDate, widget.maxDate, widget.initialDisplayDate);
    _controller.displayDate = _currentDate;
    _updateCurrentVisibleDates();
    widget.dataSource?.addListener(_dataSourceChangedListener);
    if (widget.view == CalendarView.month &&
        widget.monthViewSettings.showAgenda) {
      _agendaScrollController =
          ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
    }

    _controller.addPropertyChangedListener(_calendarValueChangedListener);

    super.initState();
  }

  void _calendarValueChangedListener(String property) {
    if (property == 'selectedDate') {
      if (isSameDate(_selectedDate, _controller.selectedDate) &&
          _isSameTimeSlot(_selectedDate, _controller.selectedDate)) {
        return;
      }

      setState(() {
        _selectedDate = _controller.selectedDate;
      });
    } else if (property == 'displayDate') {
      if (isSameDate(_currentDate, _controller.displayDate) ||
          isDateWithInDateRange(
              _currentViewVisibleDates[0],
              _currentViewVisibleDates[_currentViewVisibleDates.length - 1],
              _controller.displayDate)) {
        _currentDate = _controller.displayDate;
        return;
      }

      setState(() {
        _currentDate = _controller.displayDate;
        _updateCurrentVisibleDates();
      });
    }
  }

  void _updateCurrentVisibleDates() {
    final DateTime currentDate = _currentDate;
    final List<int> _nonWorkingDays = (widget.view == CalendarView.workWeek ||
            widget.view == CalendarView.timelineWorkWeek)
        ? widget.timeSlotViewSettings.nonWorkingDays
        : null;

    _currentViewVisibleDates = getVisibleDates(
        currentDate,
        _nonWorkingDays,
        widget.firstDayOfWeek,
        _getViewDatesCount(widget.view,
            widget.monthViewSettings.numberOfWeeksInView, currentDate));
  }

  //// Perform action while data source changed based on data source action.
  void _dataSourceChangedListener(
      CalendarDataSourceAction type, List<dynamic> data) {
    if (!_timeZoneLoaded || !mounted) {
      return;
    }

    if (type == CalendarDataSourceAction.reset) {
      _getAppointment();
    } else {
      setState(() {
        final List<Appointment> visibleAppointmentCollection = <Appointment>[];
        //// Clone the visible appointments because if we add visible appointment directly then
        //// calendar view visible appointment also updated so it does not perform to paint, So
        //// clone the visible appointment and added newly added appointment and set the value.
        if (_visibleAppointments != null) {
          for (int i = 0; i < _visibleAppointments.length; i++) {
            visibleAppointmentCollection.add(_visibleAppointments[i]);
          }
        }

        _appointments ??= <Appointment>[];
        if (type == CalendarDataSourceAction.add) {
          final List<Appointment> collection =
              _generateCalendarAppointments(widget.dataSource, widget, data);
          final List<Appointment> visibleCollection = _getVisibleAppointments(
              _currentViewVisibleDates[0],
              _currentViewVisibleDates[_currentViewVisibleDates.length - 1],
              collection,
              widget.timeZone,
              widget.view == CalendarView.month ||
                  _isTimelineView(widget.view));

          for (int i = 0; i < collection.length; i++) {
            _appointments.add(collection[i]);
          }

          for (int i = 0; i < visibleCollection.length; i++) {
            visibleAppointmentCollection.add(visibleCollection[i]);
          }
        } else if (type == CalendarDataSourceAction.remove) {
          for (int i = 0; i < data.length; i++) {
            final Object appointment = data[i];
            for (int j = 0; j < _appointments.length; j++) {
              if (_appointments[j]._data == appointment) {
                _appointments.removeAt(j);
                j--;
              }
            }
          }

          for (int i = 0; i < data.length; i++) {
            final Object appointment = data[i];
            for (int j = 0; j < visibleAppointmentCollection.length; j++) {
              if (visibleAppointmentCollection[j]._data == appointment) {
                visibleAppointmentCollection.removeAt(j);
                j--;
              }
            }
          }
        }

        _visibleAppointments = visibleAppointmentCollection;
        //// Update all day appointment related implementation in calendar, because time label view needs the top position.
        _updateAllDayAppointment();
      });
    }
  }

  void _agendaSelectedDateListener() {
    if (widget.view != CalendarView.month ||
        !widget.monthViewSettings.showAgenda) {
      return;
    }

    setState(() {});
  }

  @override
  void didUpdateWidget(SfCalendar oldWidget) {
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller
          ?.removePropertyChangedListener(_calendarValueChangedListener);
      _controller = widget.controller ?? CalendarController();
      if (widget.controller != null) {
        _controller.selectedDate = widget.controller.selectedDate;
        _controller.displayDate = widget.controller.displayDate ?? _currentDate;
      } else {
        _controller.selectedDate = widget.initialSelectedDate;
        _currentDate = getValidDate(
            widget.minDate, widget.maxDate, widget.initialDisplayDate);
        _controller.displayDate = _currentDate;
      }
      _selectedDate = widget.controller.selectedDate;
      _controller.addPropertyChangedListener(_calendarValueChangedListener);
    }

    if (oldWidget.controller == widget.controller &&
        widget.controller != null &&
        oldWidget.controller.selectedDate != widget.controller.selectedDate) {
      _selectedDate = _controller.selectedDate;
      _agendaSelectedDate.value = _controller.selectedDate;
    }

    if (oldWidget.controller == widget.controller &&
        widget.controller != null &&
        oldWidget.controller.displayDate != widget.controller.displayDate) {
      if (_controller.displayDate != null) {
        _currentDate = getValidDate(
            widget.minDate, widget.maxDate, _controller.displayDate);
      }
      _currentDate = _currentDate ??
          getValidDate(
              widget.minDate, widget.maxDate, widget.initialDisplayDate);

      _controller.displayDate = _currentDate;
    }

    if (_agendaSelectedDate.value != _selectedDate) {
      _agendaSelectedDate.value = _selectedDate;
    }

    if (oldWidget.timeZone != widget.timeZone) {
      _updateVisibleAppointments();
    }

    if (oldWidget.view != widget.view ||
        widget.monthViewSettings.numberOfWeeksInView !=
            oldWidget.monthViewSettings.numberOfWeeksInView) {
      _currentDate = _updateCurrentDate(oldWidget);
      _controller.displayDate = _currentDate;
    }

    if (oldWidget.dataSource != widget.dataSource) {
      _getAppointment();
    }

    if ((oldWidget.minDate != widget.minDate && widget.minDate != null) ||
        (oldWidget.maxDate != widget.maxDate && widget.maxDate != null)) {
      _currentDate = getValidDate(
          widget.minDate, widget.maxDate, widget.initialDisplayDate);
    }

    if (widget.view == CalendarView.month &&
        widget.monthViewSettings.showAgenda &&
        _agendaScrollController == null) {
      _agendaScrollController =
          ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
    }

    super.didUpdateWidget(oldWidget);
  }

  DateTime _updateCurrentDate(SfCalendar _oldWidget) {
    // condition added to updated the current visible date while switching the calendar views
    // if any date selected in the current view then, while switching the view the view move based the selected date
    // if no date selected and the current view has the today date, then switching the view will move based on the today date
    // if no date selected and today date doesn't falls in current view, then switching the view will move based the first day of current view
    if (_selectedDate != null &&
        isDateWithInDateRange(
            _currentViewVisibleDates[0],
            _currentViewVisibleDates[_currentViewVisibleDates.length - 1],
            _selectedDate)) {
      if (_oldWidget.view == CalendarView.month) {
        return DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            _controller.displayDate.hour,
            _controller.displayDate.minute,
            _controller.displayDate.second);
      } else {
        return _selectedDate;
      }
    } else if (isDateWithInDateRange(
        _currentViewVisibleDates[0],
        _currentViewVisibleDates[_currentViewVisibleDates.length - 1],
        DateTime.now())) {
      return DateTime.now();
    } else {
      if (_oldWidget.view == CalendarView.month) {
        if (widget.monthViewSettings.numberOfWeeksInView > 0 &&
            widget.monthViewSettings.numberOfWeeksInView < 6) {
          return _currentViewVisibleDates[0];
        }
        return DateTime(
            _currentDate.year,
            _currentDate.month,
            1,
            _controller.displayDate.hour,
            _controller.displayDate.minute,
            _controller.displayDate.second);
      } else {
        return _currentViewVisibleDates[0];
      }
    }
  }

  _AppointmentView _getAppointmentView(Appointment appointment) {
    _AppointmentView appointmentRenderer;
    for (int i = 0; i < _allDayAppointmentViewCollection.length; i++) {
      final _AppointmentView view = _allDayAppointmentViewCollection[i];
      if (view.appointment == null) {
        appointmentRenderer = view;
        break;
      }
    }

    if (appointmentRenderer == null) {
      appointmentRenderer = _AppointmentView();
      appointmentRenderer.appointment = appointment;
      _allDayAppointmentViewCollection.add(appointmentRenderer);
    }

    appointmentRenderer.appointment = appointment;
    appointmentRenderer.canReuse = false;
    return appointmentRenderer;
  }

  @override
  void didChangeDependencies() {
    _topPadding = MediaQuery.of(context).padding.top;
    // default width value will be device width when the widget placed inside a infinity width widget
    _minWidth = MediaQuery.of(context).size.width;
    // default height for the widget when the widget placed inside a infinity height widget
    _minHeight = 300;
    _calendarTheme = SfCalendarTheme.of(context);
    //// localeOf(context) returns the locale from material app when SfCalendar locale value as null
    _locale = Localizations.localeOf(context).toString();
    _localizations = SfLocalizations.of(context);
    super.didChangeDependencies();
  }

  void _updateAllDayAppointment() {
    _allDayPanelHeight = 0;
    if (widget.view != CalendarView.month &&
        !_isTimelineView(widget.view) &&
        _currentViewVisibleDates.length <= 7) {
      _allDayAppointmentViewCollection =
          _allDayAppointmentViewCollection ?? <_AppointmentView>[];

      //// Remove the existing appointment related details.
      for (int i = 0; i < _allDayAppointmentViewCollection.length; i++) {
        final _AppointmentView obj = _allDayAppointmentViewCollection[i];
        obj.canReuse = true;
        obj.appointment = null;
        obj.startIndex = -1;
        obj.endIndex = -1;
        obj.position = -1;
        obj.maxPositions = -1;
      }

      if (_visibleAppointments == null || _visibleAppointments.isEmpty) {
        return;
      }

      //// Calculate the visible all day appointment collection.
      final List<Appointment> allDayAppointments = <Appointment>[];
      for (Appointment apppointment in _visibleAppointments) {
        if (apppointment.isAllDay ||
            apppointment._actualEndTime
                    .difference(apppointment._actualStartTime)
                    .inDays >
                0) {
          allDayAppointments.add(apppointment);
        }
      }

      //// Update the appointment view collection with visible appointments.
      for (int i = 0; i < allDayAppointments.length; i++) {
        _AppointmentView _appointmentView;
        if (_allDayAppointmentViewCollection.length > i) {
          _appointmentView = _allDayAppointmentViewCollection[i];
        } else {
          _appointmentView = _AppointmentView();
          _allDayAppointmentViewCollection.add(_appointmentView);
        }

        _appointmentView.appointment = allDayAppointments[i];
        _appointmentView.canReuse = false;
      }

      //// Calculate the appointment view position.
      for (_AppointmentView _appointmentView
          in _allDayAppointmentViewCollection) {
        if (_appointmentView.appointment == null) {
          continue;
        }

        final int startIndex = _getIndex(_currentViewVisibleDates,
            _appointmentView.appointment._actualStartTime);
        final int endIndex = _getIndex(_currentViewVisibleDates,
                _appointmentView.appointment._actualEndTime) +
            1;
        if (startIndex == -1 && endIndex == 0) {
          _appointmentView.appointment = null;
          continue;
        }

        _appointmentView.startIndex = startIndex;
        _appointmentView.endIndex = endIndex;
      }

      //// Sort the appointment view based on appointment view width.
      _allDayAppointmentViewCollection
          .sort((_AppointmentView app1, _AppointmentView app2) {
        if (app1.appointment != null && app2.appointment != null) {
          return (app2.endIndex - app2.startIndex) >
                  (app1.endIndex - app1.startIndex)
              ? 1
              : 0;
        }

        return 0;
      });

      //// Sort the appointment view based on appointment view start position.
      _allDayAppointmentViewCollection
          .sort((_AppointmentView app1, _AppointmentView app2) {
        if (app1.appointment != null && app2.appointment != null) {
          return app1.startIndex.compareTo(app2.startIndex);
        }

        return 0;
      });

      final List<List<_AppointmentView>> _allDayAppointmentView =
          <List<_AppointmentView>>[];
      //// Calculate the intersecting appointment view collection.
      for (int i = 0; i < _currentViewVisibleDates.length; i++) {
        final List<_AppointmentView> intersectingAppointments =
            <_AppointmentView>[];
        for (int j = 0; j < _allDayAppointmentViewCollection.length; j++) {
          final _AppointmentView _currentView =
              _allDayAppointmentViewCollection[j];
          if (_currentView.appointment == null) {
            continue;
          }

          if (_currentView.startIndex <= i && _currentView.endIndex >= i + 1) {
            intersectingAppointments.add(_currentView);
          }
        }

        _allDayAppointmentView.add(intersectingAppointments);
      }

      //// Calculate the appointment view position and max position.
      for (int i = 0; i < _allDayAppointmentView.length; i++) {
        final List<_AppointmentView> intersectingAppointments =
            _allDayAppointmentView[i];
        for (int j = 0; j < intersectingAppointments.length; j++) {
          final _AppointmentView _currentView = intersectingAppointments[j];
          if (_currentView.position == -1) {
            _currentView.position = 0;
            for (int k = 0; k < j; k++) {
              final _AppointmentView _intersectView = _getAppointmentOnPosition(
                  _currentView, intersectingAppointments);
              if (_intersectView != null) {
                _currentView.position++;
              } else {
                break;
              }
            }
          }
        }

        if (intersectingAppointments.isNotEmpty) {
          final int maxPosition = intersectingAppointments
              .reduce((_AppointmentView currentAppview,
                      _AppointmentView nextAppview) =>
                  currentAppview.position > nextAppview.position
                      ? currentAppview
                      : nextAppview)
              .position;
          for (int j = 0; j < intersectingAppointments.length; j++) {
            intersectingAppointments[j].maxPositions = maxPosition + 1;
          }
        }
      }

      int maxPosition = 0;
      if (_allDayAppointmentViewCollection.isNotEmpty) {
        maxPosition = _allDayAppointmentViewCollection
            .reduce((_AppointmentView currentAppview,
                    _AppointmentView nextAppview) =>
                currentAppview.maxPositions > nextAppview.maxPositions
                    ? currentAppview
                    : nextAppview)
            .maxPositions;
      }

      if (maxPosition == -1) {
        maxPosition = 0;
      }

      _allDayPanelHeight = (maxPosition * _kAllDayAppointmentHeight).toDouble();
    }
  }

  // method to check and update the calendar width and height.
  double _updateHeight(double _height) {
    return _height -= widget.headerHeight + _topPadding;
  }

  @override
  Widget build(BuildContext context) {
    SyncfusionLicense.validateLicense(context);
    double _top = 0, _width, _height;
    final bool _isRTL = _isRTLLayout(context);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      _minWidth = constraints.maxWidth == double.infinity
          ? _minWidth
          : constraints.maxWidth;
      _minHeight = constraints.maxHeight == double.infinity
          ? _minHeight
          : constraints.maxHeight;

      _width = _minWidth;
      _height = _minHeight;

      _height = _updateHeight(_height);
      _top = _topPadding + widget.headerHeight;
      double agendaHeight = widget.view == CalendarView.month &&
              widget.monthViewSettings.showAgenda
          ? widget.monthViewSettings.agendaViewHeight
          : 0;
      if (agendaHeight == null || agendaHeight == -1) {
        agendaHeight = (_height +
                widget.headerHeight +
                _getViewHeaderHeight(widget.viewHeaderHeight, widget.view)) /
            3;
      }

      return Container(
        width: _minWidth,
        height: _minHeight,
        color: widget.backgroundColor ?? _calendarTheme.backgroundColor,
        child: _addChildren(_top, agendaHeight, _height, _width, _isRTL),
      );
    });
  }

  Widget _addChildren(double _top, double agendaHeight, double _height,
      double _width, bool _isRTL) {
    final DateTime _currentViewDate = _currentViewVisibleDates[
        (_currentViewVisibleDates.length / 2).truncate()];
    return Stack(children: <Widget>[
      Positioned(
        top: _topPadding,
        right: 0,
        left: 0,
        height: widget.headerHeight,
        child: GestureDetector(
          child: Container(
            color: widget.headerStyle.backgroundColor ??
                _calendarTheme.headerBackgroundColor,
            child: CustomPaint(
              // Returns the header view  as a child for the calendar.
              painter: _HeaderViewPainter(
                  _currentViewVisibleDates,
                  widget.headerStyle,
                  _currentViewDate,
                  widget.view,
                  widget.monthViewSettings.numberOfWeeksInView,
                  _calendarTheme,
                  _isRTL,
                  _locale),
            ),
          ),
          onTapUp: (TapUpDetails details) {
            _updateCalendarTapCallbackForHeader();
          },
        ),
      ),
      Positioned(
        top: _top,
        left: 0,
        right: 0,
        height: _height - agendaHeight,
        child: _CustomScrollView(
          widget,
          _width,
          _height - agendaHeight,
          _visibleAppointments,
          _agendaSelectedDate,
          _isRTL,
          _locale,
          _calendarTheme,
          updateCalendarState: (_UpdateCalendarStateDetails details) {
            _updateCalendarState(details);
          },
        ),
      ),
      _addAgendaView(
          agendaHeight, _top + _height - agendaHeight, _width, _isRTL),
    ]);
  }

  dynamic _updateCalendarState(_UpdateCalendarStateDetails details) {
    if (details._currentDate != null) {
      _currentDate = details._currentDate;
      _controller.displayDate = details._currentDate;
    }

    details._currentDate = details._currentDate ?? _currentDate;

    if (details._currentViewVisibleDates != null &&
        _currentViewVisibleDates != details._currentViewVisibleDates) {
      _currentViewVisibleDates = details._currentViewVisibleDates;
      _updateVisibleAppointments();
      if (_shouldRaiseViewChangedCallback(widget.onViewChanged)) {
        _raiseViewChangedCallback(widget,
            visibleDates: _currentViewVisibleDates);
      }
    }

    if (details._selectedDate == null) {
      details._selectedDate = _selectedDate;
    } else if (details._selectedDate != _selectedDate) {
      _selectedDate = details._selectedDate;
      _controller.selectedDate = details._selectedDate;
    }

    if (details._allDayPanelHeight == null ||
        details._allDayPanelHeight != _allDayPanelHeight) {
      details._allDayPanelHeight = _allDayPanelHeight;
    }

    if (details._allDayAppointmentViewCollection == null ||
        details._allDayAppointmentViewCollection !=
            _allDayAppointmentViewCollection) {
      details._allDayAppointmentViewCollection =
          _allDayAppointmentViewCollection;
    }

    if (details._appointments == null ||
        details._appointments != _appointments) {
      details._appointments = _appointments;
    }
  }

  // method to update the calendar tapped callback for the header view
  void _updateCalendarTapCallbackForHeader() {
    if (!_shouldRaiseCalendarTapCallback(widget.onTap)) {
      return;
    }

    DateTime selectedDate;
    if (widget.view == CalendarView.month) {
      selectedDate =
          DateTime(_currentDate.year, _currentDate.month, 01, 0, 0, 0);
    } else {
      selectedDate = DateTime(
          _currentViewVisibleDates[0].year,
          _currentViewVisibleDates[0].month,
          _currentViewVisibleDates[0].day,
          0,
          0,
          0);
    }

    _raiseCalendarTapCallback(widget,
        date: selectedDate, element: CalendarElement.header);
  }

  // method to update the calendar tapped callback for the agenda view
  void _updateCalendarTapCallbackForAgendaView(TapUpDetails details) {
    if (!_shouldRaiseCalendarTapCallback(widget.onTap)) {
      return;
    }

    List<Appointment> _agendaAppointments;
    if (_selectedDate != null) {
      _agendaAppointments = _getSelectedDateAppointments(
          _appointments, widget.timeZone, _selectedDate);

      final double dateTimeWidth = _minWidth * 0.15;
      if (details.localPosition.dx > dateTimeWidth &&
          _agendaAppointments != null &&
          _agendaAppointments.isNotEmpty) {
        _agendaAppointments.sort((dynamic app1, dynamic app2) =>
            app1._actualStartTime.compareTo(app2._actualStartTime));
        _agendaAppointments.sort((dynamic app1, dynamic app2) =>
            _orderAppointmentsAscending(app1.isAllDay, app2.isAllDay));

        int index = -1;
        //// Agenda appointment view top padding as 5.
        const double padding = 5;
        double xPosition = 0;
        final double tappedYPosition =
            _agendaScrollController.offset + details.localPosition.dy;
        for (int i = 0; i < _agendaAppointments.length; i++) {
          final Appointment _appointment = _agendaAppointments[i];
          final double appointmentHeight = _appointment.isAllDay
              ? widget.monthViewSettings.agendaItemHeight / 2
              : widget.monthViewSettings.agendaItemHeight;
          if (tappedYPosition >= xPosition &&
              tappedYPosition < xPosition + appointmentHeight + padding) {
            index = i;
            break;
          }

          xPosition += appointmentHeight + padding;
        }

        if (index > _agendaAppointments.length || index == -1) {
          _agendaAppointments = null;
        } else {
          _agendaAppointments = <Appointment>[_agendaAppointments[index]];
        }
      } else {
        _agendaAppointments = null;
      }
    }

    List<Object> _selectedAppointments = <Object>[];
    if (_agendaAppointments != null && _agendaAppointments.isNotEmpty) {
      for (int i = 0; i < _agendaAppointments.length; i++) {
        _selectedAppointments.add(_agendaAppointments[i]);
      }
    }

    if (widget.dataSource != null &&
        !_isCalendarAppointment(widget.dataSource.appointments)) {
      _selectedAppointments = _getCustomAppointments(_agendaAppointments);
    }

    _raiseCalendarTapCallback(widget,
        date: _selectedDate,
        appointments: _selectedAppointments,
        element: CalendarElement.agenda);
  }

  // Returns the agenda view  as a child for the calendar.
  Widget _addAgendaView(
      double height, double startPosition, double _width, bool _isRTL) {
    if (widget.view != CalendarView.month ||
        !widget.monthViewSettings.showAgenda) {
      return Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: Container(),
      );
    }

    List<Appointment> _agendaAppointments;
    if (_selectedDate != null) {
      _agendaAppointments = _getSelectedDateAppointments(
          _appointments, widget.timeZone, _selectedDate);
    }

    const double topPadding = 5;
    const double bottomPadding = 5;
    final double appointmentHeight = widget.monthViewSettings.agendaItemHeight;
    double painterHeight = height;
    if (_agendaAppointments != null && _agendaAppointments.isNotEmpty) {
      int count = 0;
      for (int i = 0; i < _agendaAppointments.length; i++) {
        if (_agendaAppointments[i].isAllDay) {
          count++;
        }
      }

      painterHeight = (((count * ((appointmentHeight / 2) + topPadding)) +
                  ((_agendaAppointments.length - count) *
                      (appointmentHeight + topPadding)))
              .toDouble()) +
          bottomPadding;
    }

    double dateTimeWidth = _width * 0.15;
    if (_selectedDate == null) {
      dateTimeWidth = 0;
    }

    return Positioned(
        top: startPosition,
        right: 0,
        left: 0,
        height: height,
        child: Container(
            color: widget.monthViewSettings.agendaStyle.backgroundColor ??
                _calendarTheme.agendaBackgroundColor,
            child: GestureDetector(
                child: Stack(
                  children: <Widget>[
                    CustomPaint(
                      painter: _AgendaDateTimePainter(
                          _selectedDate,
                          widget.monthViewSettings,
                          widget.todayHighlightColor ??
                              _calendarTheme.todayHighlightColor,
                          _locale,
                          _calendarTheme),
                      size: Size(dateTimeWidth, height),
                    ),
                    Positioned(
                      top: 0,
                      left: _isRTL ? 0 : dateTimeWidth,
                      right: _isRTL ? dateTimeWidth : 0,
                      bottom: 0,
                      child: ListView(
                        padding: const EdgeInsets.all(0.0),
                        controller: _agendaScrollController,
                        children: <Widget>[
                          CustomPaint(
                            painter: _AgendaViewPainter(
                                widget.monthViewSettings,
                                _selectedDate,
                                widget.timeZone,
                                _appointments,
                                _isRTL,
                                _locale,
                                _localizations),
                            size: Size(_width - dateTimeWidth, painterHeight),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTapUp: (TapUpDetails details) {
                  _updateCalendarTapCallbackForAgendaView(details);
                })));
  }
}
