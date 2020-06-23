part of calendar;

/// Callback to notify the controller properties changes
typedef CalendarValueChangedCallback = void Function(String);

/// Notifier to notify the controller properties changes
class CalendarValueChangedNotifier {
  List<CalendarValueChangedCallback> _listeners;

  //// Add the listener used to callback when calendar value changed.
  void addPropertyChangedListener(CalendarValueChangedCallback _listener) {
    _listeners ??= <CalendarValueChangedCallback>[];
    _listeners.add(_listener);
  }

  //// remove the listener used for notify the calendar value changes.
  void removePropertyChangedListener(CalendarValueChangedCallback _listener) {
    if (_listeners == null) {
      return;
    }

    _listeners.remove(_listener);
  }

  //// Notify to the listener while calendar value changed.
  void notifyPropertyChangedListeners(String property) {
    if (_listeners == null) {
      return;
    }

    for (CalendarValueChangedCallback listener in _listeners) {
      if (listener != null) {
        listener(property);
      }
    }
  }

  @mustCallSuper
  void dispose() {
    _listeners = null;
  }
}

/// An object that used for programmatic date navigation, date selection
/// in [SfCalendar].
///
/// A [CalendarController] served for several purposes. It can be used
/// to selected dates programmatically on [SfCalendar] by using the
/// [CalendarController.selectedDate]. It can be used to navigate to specific date
/// by using the [CalendarController.displayDate] property.
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
class CalendarController extends CalendarValueChangedNotifier {
  DateTime _selectedDate;
  DateTime _displayDate;

  /// The selected date in the [SfCalendar].
  DateTime get selectedDate => _selectedDate;

  /// Selects the given date programmatically in the [SfCalendar] by
  /// checking that the date falls in between the minimum and maximum date range.
  ///
  /// _Note:_ If any date selected previously, will be removed and the selection
  /// will be drawn to the date given in this property.
  ///
  /// ```dart
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
  ///}
  /// ```
  set selectedDate(DateTime date) {
    if (isSameDate(_selectedDate, date) &&
        _isSameTimeSlot(_selectedDate, date)) {
      return;
    }

    _selectedDate = date;
    notifyPropertyChangedListeners('selectedDate');
  }

  /// Returns the first date of the current visible view, when the [SfCalendar.view]
  /// set with the view other than [CalendarView.month].
  ///
  /// If the [SfCalendar.view] set as [CalendarView.month] and the
  /// [MonthViewSettings.numberOfWeeksInView] property set with value less than
  /// or equal 4, this will return the first visible date of the current month.
  ///
  /// If the [SfCalendar.view] set as [CalendarView.month] and the
  /// [MonthViewSettings.numberOfWeeksInView] property set with value greater than
  /// 4, this will return the first date of the current visible month.
  DateTime get displayDate => _displayDate;

  /// Navigates to the given date programmatically without any animation in the
  /// [SfCalendar] by checking that the date falls in between the
  /// [SfCalendar.minDate]  and [SfCalendar.maxDate] date range.
  ///
  /// if the date falls beyond the [SfCalendar.minDate] and [SfCalendar.maxDate]
  /// the widget will move the widgets min or max date.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///
  /// CalendarController _calendarController;
  /// @override
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
  ///}
  /// ```
  set displayDate(DateTime date) {
    if (isSameDate(_displayDate, date)) {
      return;
    }

    _displayDate = date;
    notifyPropertyChangedListeners('displayDate');
  }

  VoidCallback _forward;

  /// Moves to the next view programmatically with animation by checking that the
  /// next view dates falls between the minimum and maximum date range.
  ///
  /// _Note:_ If the current view has the maximum date range, it will not move to the
  /// next view.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp> {
  ///  CalendarController _calendarController;
  ///
  ///  @override
  ///  initState() {
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
  ///        appBar: AppBar(
  ///          title: Text('Calendar Demo'),
  ///          actions: <Widget>[
  ///            IconButton(
  ///              icon: Icon(Icons.arrow_forward),
  ///              onPressed: () {
  ///                _calendarController.forward();
  ///              },
  ///            ),
  ///          ],
  ///          leading: IconButton(
  ///            icon: Icon(Icons.arrow_back),
  ///            onPressed: () {
  ///              _calendarController.backward();
  ///            },
  ///          ),
  ///        ),
  ///        body: SfCalendar(
  ///          view: CalendarView.month,
  ///          controller: _calendarController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  void forward() {
    if (_forward == null) {
      return;
    }

    _forward();
  }

  VoidCallback _backward;

  /// Moves to the previous view programmatically with animation by checking that the
  /// previous view dates falls between the minimum and maximum date range.
  ///
  /// _Note:_ If the current view has the minimum date range, it will not move to the
  /// previous view.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp> {
  ///  CalendarController _calendarController;
  ///
  ///  @override
  ///  initState() {
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
  ///        appBar: AppBar(
  ///          title: Text('Calendar Demo'),
  ///          actions: <Widget>[
  ///            IconButton(
  ///              icon: Icon(Icons.arrow_forward),
  ///              onPressed: () {
  ///                _calendarController.forward();
  ///              },
  ///            ),
  ///          ],
  ///          leading: IconButton(
  ///            icon: Icon(Icons.arrow_back),
  ///            onPressed: () {
  ///              _calendarController.backward();
  ///            },
  ///          ),
  ///        ),
  ///        body: SfCalendar(
  ///          view: CalendarView.month,
  ///          controller: _calendarController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  void backward() {
    if (_backward == null) {
      return;
    }

    _backward();
  }
}
