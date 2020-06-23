part of calendar;

/// A direction in which the [SfCalendar] month view navigates.
enum MonthNavigationDirection {
  /// - MonthNavigationDirection.vertical, Navigates in top and bottom direction.
  vertical,

  /// - MonthNavigationDirection.horizontal, Navigates in left and top direction.
  horizontal
}

/// Available views for [SfCalendar].
enum CalendarView {
  /// - CalendarView.day, displays the day view.
  day,

  /// - CalendarView.week, displays the week view.
  week,

  /// - CalendarView.workWeek, displays the workweek view.
  workWeek,

  /// - CalendarView.month, displays the month view.
  month,

  /// - CalendarView.timelineDay, displays the timeline day view.
  timelineDay,

  /// - CalendarView.timelineWeek, displays the timeline week view.
  timelineWeek,

  /// - CalendarView.timelineWorkWeek, displays the timeline work week view.
  timelineWorkWeek
}

/// Available appointment display mode for [SfCalendar] month cell.
enum MonthAppointmentDisplayMode {
  /// - MonthAppointmentDisplayMode.indicator, displays the appointment as dot
  /// indicator.
  indicator,

  /// - MonthAppointmentDisplayMode.appointment, displays the appointment as appointment
  /// view.
  appointment,

  /// - MonthAppointmentDisplayMode.none, doesn't display appointment on view.
  none
}

/// Available recurrence types for [Appointment] in [SfCalendar]
enum RecurrenceType {
  /// - RecurrenceType.daily, indicates the appointment occurrence repeated in every day.
  daily,

  /// - RecurrenceType.weekly, indicates the appointment occurrence repeated in every week.
  weekly,

  /// - RecurrenceType.monthly, indicates the appointment occurrence repeated in every month.
  monthly,

  /// - RecurrenceType.yearly, indicates the appointment occurrence repeated in every year.
  yearly,
}

/// The available options to recur the [Appointment] in [SfCalendar]
enum RecurrenceRange {
  /// - RecurrenceRange.endDate, indicates the appointment occurrence repeated
  /// until the end date.
  endDate,

  /// - RecurrenceRange.noEndDate, indicates the appointment occurrence repeated
  /// until the last date of the calendar.
  noEndDate,

  /// - RecurrenceRange.count, indicates the appointment occurrence repeated with
  /// specified count times.
  count
}

/// The week days occurrence of [Appointment].
enum WeekDays {
  /// - WeekDays.sunday, indicates the appointment occurred in sunday.
  sunday,

  /// - WeekDays.monday, indicates the appointment occurred in monday.
  monday,

  /// - WeekDays.tuesday, indicates the appointment occurred in tuesday.
  tuesday,

  /// - WeekDays.wednesday, indicates the appointment occurred in wednesday.
  wednesday,

  /// - WeekDays.thursday, indicates the appointment occurred in thursday.
  thursday,

  /// - WeekDays.friday, indicates the appointment occurred in friday.
  friday,

  /// - WeekDays.saturday, indicates the appointment occurred in saturday.
  saturday
}

/// The available calendar elements for the [CalendarTapDetails] in [SfCalendar].
enum CalendarElement {
  /// - CalendarElement.header, Indicates that the calendar header view tapped.
  header,

  /// - CalendarElement.viewHeader, indicates that the calendar view header view tapped.
  viewHeader,

  /// - CalendarElement.header, Indicates that the calendar cell tapped.
  calendarCell,

  /// - CalendarElement.header, Indicates that the [Appointment] tapped.
  appointment,

  /// - CalendarElement.agenda, Indicates that the agenda view tapped.
  agenda
}

//// Action performed in data source
enum CalendarDataSourceAction {
  /// - CalendarDataSourceAction.add, add action to be performed, the appointment
  /// will be added to the collection.
  add,

  /// - CalendarDataSourceAction.remove, remove action to be performed, the appointment
  /// will be removed  from the collection.
  remove,

  /// - CalendarDataSourceAction.reset, reset action to be performed, the appointment
  /// collection will be resets.
  reset
}
