part of calendar;

/// The dates that visible on the view changes in [SfCalendar].
///
/// Details for [ViewChangedCallback], such as [visibleDates].
class ViewChangedDetails {
  /// The date collection that visible on current view.
  List<DateTime> visibleDates;
}

/// The element that tapped on view in [SfCalendar]
///
/// Details for [CalendarTapCallback], such as `appointments`, `date` and
/// `targerElement`.
class CalendarTapDetails {
  /// The collection of appointments that tapped or falls inside the selected date.
  List<dynamic> appointments;

  /// The date cell that tapped on view.
  DateTime date;

  /// The element that tapped on view.
  CalendarElement targetElement;
}

/// args to update the required properties from calendar state to it's children's
class _UpdateCalendarStateDetails {
  DateTime _currentDate;
  List<DateTime> _currentViewVisibleDates;
  List<dynamic> _visibleAppointments;
  DateTime _selectedDate;
  double _allDayPanelHeight;
  List<_AppointmentView> _allDayAppointmentViewCollection;
  List<dynamic> _appointments;

  // ignore: prefer_final_fields
  bool _isAppointmentTapped = false;
}
