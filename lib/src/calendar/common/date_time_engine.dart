part of calendar;

//// Calculate the visible dates count based on calendar view
int _getViewDatesCount(
    CalendarView calendarView, int numberOfWeeks, DateTime date) {
  if (calendarView == null) {
    return 0;
  }

  if (calendarView == CalendarView.month) {
    return 7 * numberOfWeeks;
  } else if (calendarView == CalendarView.week ||
      calendarView == CalendarView.workWeek ||
      calendarView == CalendarView.timelineWorkWeek ||
      calendarView == CalendarView.timelineWeek) {
    return 7;
  } else {
    return 1;
  }
}

//// Calculate the next view visible start date based on calendar view.
DateTime _getNextViewStartDate(
    CalendarView _calendarView, int numberOfWeeksInView, DateTime date) {
  if (_calendarView == null) {
    return date;
  }
  if (_calendarView == CalendarView.month) {
    return numberOfWeeksInView == 6
        ? getNextMonthDate(date)
        : date.add(Duration(days: numberOfWeeksInView * 7));
  } else if (_calendarView == CalendarView.week ||
      _calendarView == CalendarView.workWeek ||
      _calendarView == CalendarView.timelineWorkWeek ||
      _calendarView == CalendarView.timelineWeek) {
    return date.add(const Duration(days: 7));
  } else {
    return date.add(const Duration(days: 1));
  }
}

//// Calculate the previous view visible start date based on calendar view.
DateTime _getPreviousViewStartDate(
    CalendarView _calendarView, int numberOfWeeksInView, DateTime date) {
  if (_calendarView == null) {
    return date;
  }
  if (_calendarView == CalendarView.month) {
    return numberOfWeeksInView == 6
        ? getPreviousMonthDate(date)
        : date.add(Duration(days: -numberOfWeeksInView * 7));
  } else if (_calendarView == CalendarView.week ||
      _calendarView == CalendarView.workWeek ||
      _calendarView == CalendarView.timelineWorkWeek ||
      _calendarView == CalendarView.timelineWeek) {
    return date.add(const Duration(days: -7));
  } else {
    return date.add(const Duration(days: -1));
  }
}

DateTime _getPreviousValidDate(
    DateTime _prevViewDate, List<int> nonWorkingDays) {
  DateTime _previousDate = _prevViewDate.subtract(const Duration(days: 1));
  while (nonWorkingDays.contains(_previousDate.weekday)) {
    _previousDate = _previousDate.subtract(const Duration(days: 1));
  }
  return _previousDate;
}

DateTime _getNextValidDate(DateTime _nextDate, List<int> nonWorkingDays) {
  DateTime _nextViewDate = _nextDate.add(const Duration(days: 1));
  while (nonWorkingDays.contains(_nextViewDate.weekday)) {
    _nextViewDate = _nextViewDate.add(const Duration(days: 1));
  }
  return _nextViewDate;
}

int _getIndex(List<DateTime> dates, DateTime date) {
  if (date.isBefore(dates[0])) {
    return 0;
  }

  if (date.isAfter(dates[dates.length - 1])) {
    return dates.length - 1;
  }

  for (int i = 0; i < dates.length; i++) {
    final DateTime visibleDate = dates[i];
    if (isSameOrBeforeDate(visibleDate, date)) {
      return i;
    }
  }

  return -1;
}

bool _canMoveToPreviousView(CalendarView _calendarView,
    int _numberOfWeeksInView, DateTime _minDate, List<DateTime> _visibleDates,
    [List<int> nonWorkingDays]) {
  if (_calendarView == CalendarView.month && _numberOfWeeksInView != 6) {
    DateTime _prevViewDate = _visibleDates[0];
    _prevViewDate = _prevViewDate.subtract(const Duration(days: 1));
    if (!isSameOrAfterDate(_minDate, _prevViewDate)) {
      return false;
    }
  } else if (_calendarView == CalendarView.month) {
    final DateTime _currentDate = _visibleDates[_visibleDates.length ~/ 2];
    final DateTime _previousDate = getPreviousMonthDate(_currentDate);
    if ((_previousDate.month < _minDate.month &&
            _previousDate.year == _minDate.year) ||
        _previousDate.year < _minDate.year) {
      return false;
    }
  } else if (_calendarView == CalendarView.week ||
      _calendarView == CalendarView.day ||
      _calendarView == CalendarView.timelineWeek ||
      _calendarView == CalendarView.timelineDay) {
    DateTime _prevViewDate = _visibleDates[0];
    _prevViewDate = _prevViewDate.subtract(const Duration(days: 1));
    if (!isSameOrAfterDate(_minDate, _prevViewDate)) {
      return false;
    }
  } else if (_calendarView == CalendarView.workWeek ||
      _calendarView == CalendarView.timelineWorkWeek) {
    final DateTime _previousDate =
        _getPreviousValidDate(_visibleDates[0], nonWorkingDays);
    if (!isSameOrAfterDate(_minDate, _previousDate)) {
      return false;
    }
  }

  return true;
}

bool _canMoveToNextView(CalendarView _calendarView, int _numberOfWeeksInView,
    DateTime _maxDate, List<DateTime> _visibleDates,
    [List<int> nonWorkingDays]) {
  if (_calendarView == CalendarView.month && _numberOfWeeksInView != 6) {
    DateTime _nextViewDate = _visibleDates[_visibleDates.length - 1];
    _nextViewDate = _nextViewDate.add(const Duration(days: 1));
    if (!isSameOrBeforeDate(_maxDate, _nextViewDate)) {
      return false;
    }
  } else if (_calendarView == CalendarView.month) {
    final DateTime _currentDate = _visibleDates[_visibleDates.length ~/ 2];
    final DateTime _nextDate = getNextMonthDate(_currentDate);
    if ((_nextDate.month > _maxDate.month && _nextDate.year == _maxDate.year) ||
        _nextDate.year > _maxDate.year) {
      return false;
    }
  } else if (_calendarView == CalendarView.week ||
      _calendarView == CalendarView.day ||
      _calendarView == CalendarView.timelineWeek ||
      _calendarView == CalendarView.timelineDay) {
    DateTime _nextViewDate = _visibleDates[_visibleDates.length - 1];
    _nextViewDate = _nextViewDate.add(const Duration(days: 1));
    if (!isSameOrBeforeDate(_maxDate, _nextViewDate)) {
      return false;
    }
  } else if (_calendarView == CalendarView.workWeek ||
      _calendarView == CalendarView.timelineWorkWeek) {
    final DateTime _nextDate = _getNextValidDate(
        _visibleDates[_visibleDates.length - 1], nonWorkingDays);
    if (!isSameOrBeforeDate(_maxDate, _nextDate)) {
      return false;
    }
  }

  return true;
}
