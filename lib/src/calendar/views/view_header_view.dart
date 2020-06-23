part of calendar;

class _ViewHeaderViewPainter extends CustomPainter {
  _ViewHeaderViewPainter(
      this._visibleDates,
      this._view,
      this._viewHeaderStyle,
      this._timeSlotViewSettings,
      this._timeLabelWidth,
      this._viewHeaderHeight,
      this._monthViewSettings,
      this._isRTL,
      this._locale,
      this._calendarTheme,
      this._todayHighlightColor,
      this._cellBorderColor,
      this._minDate,
      this._maxDate);

  final CalendarView _view;
  final ViewHeaderStyle _viewHeaderStyle;
  final TimeSlotViewSettings _timeSlotViewSettings;
  final MonthViewSettings _monthViewSettings;
  final List<DateTime> _visibleDates;
  final double _timeLabelWidth;
  final double _viewHeaderHeight;
  final SfCalendarThemeData _calendarTheme;
  final bool _isRTL;
  final String _locale;
  final Color _todayHighlightColor;
  final Color _cellBorderColor;
  final DateTime _minDate;
  final DateTime _maxDate;
  DateTime _currentDate;
  String _dayText, _dateText;
  Paint _circlePainter;
  Paint _linePainter;
  TextPainter _dayTextPainter, _dateTextPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    double _xPosition, _yPosition;
    double _width = size.width;
    _width = _getViewHeaderWidth(_width);

    TextStyle _viewHeaderDayStyle = _viewHeaderStyle.dayTextStyle;
    TextStyle _viewHeaderDateStyle = _viewHeaderStyle.dateTextStyle;

    /// Initializes the default text style for the texts in view header of calendar.
    _viewHeaderDayStyle ??= _calendarTheme.viewHeaderDayTextStyle;
    _viewHeaderDateStyle ??= _calendarTheme.viewHeaderDateTextStyle;

    final DateTime today = DateTime.now();
    final double _labelWidth = _view == CalendarView.day && _timeLabelWidth < 50
        ? 50
        : _timeLabelWidth;
    TextStyle dayTextStyle = _viewHeaderDayStyle;
    TextStyle dateTextStyle = _viewHeaderDateStyle;
    if (_view != CalendarView.month) {
      const double topPadding = 5;
      if (_view == CalendarView.day) {
        _width = _labelWidth;
        _linePainter ??= Paint();
        _linePainter.strokeWidth = 0.5;
        _linePainter.strokeCap = StrokeCap.round;
        _linePainter.color = _cellBorderColor ?? _calendarTheme.cellBorderColor;
        //// Decrease the x position by 0.5 because draw the end point of the view
        /// draws half of the line to current view and hides another half.
        if (_timeLabelWidth == _labelWidth) {
          canvas.drawLine(
              Offset(_isRTL ? 0.5 : _labelWidth - 0.5, 0),
              Offset(_isRTL ? 0.5 : _labelWidth - 0.5, size.height),
              _linePainter);
        }
      }

      _xPosition = _view == CalendarView.day ? 0 : _timeLabelWidth;
      _yPosition = 2;
      final double cellWidth = _width / _visibleDates.length;
      if (_isRTL && _view != CalendarView.day) {
        _xPosition = size.width - _timeLabelWidth - cellWidth;
      }
      for (int i = 0; i < _visibleDates.length; i++) {
        _currentDate = _visibleDates[i];
        _dayText = DateFormat(_timeSlotViewSettings.dayFormat, _locale)
            .format(_currentDate)
            .toString()
            .toUpperCase();

        _updateViewHeaderFormat();

        _dateText = DateFormat(_timeSlotViewSettings.dateFormat)
            .format(_currentDate)
            .toString();
        final bool _isToday = isSameDate(_currentDate, today);
        if (_isToday) {
          dayTextStyle =
              _viewHeaderDayStyle.copyWith(color: _todayHighlightColor);
          dateTextStyle = _viewHeaderDateStyle.copyWith(
              color: _calendarTheme.todayTextStyle.color);
        } else {
          dayTextStyle = _viewHeaderDayStyle;
          dateTextStyle = _viewHeaderDateStyle;
        }

        if (!isDateWithInDateRange(_minDate, _maxDate, _currentDate)) {
          if (_calendarTheme.brightness == Brightness.light) {
            dayTextStyle = dayTextStyle.copyWith(color: Colors.black26);
            dateTextStyle = dateTextStyle.copyWith(color: Colors.black26);
          } else {
            dayTextStyle = dayTextStyle.copyWith(color: Colors.white38);
            dateTextStyle = dateTextStyle.copyWith(color: Colors.white38);
          }
        }

        _updateDayTextPainter(dayTextStyle, _width);

        final TextSpan dateTextSpan = TextSpan(
          text: _dateText,
          style: dateTextStyle,
        );

        _dateTextPainter = _dateTextPainter ?? TextPainter();
        _dateTextPainter.text = dateTextSpan;
        _dateTextPainter.textDirection = TextDirection.ltr;
        _dateTextPainter.textAlign = TextAlign.left;
        _dateTextPainter.textWidthBasis = TextWidthBasis.longestLine;

        _dateTextPainter.layout(minWidth: 0, maxWidth: _width);

        /// To calculate the day start position by width and day painter
        final double dayXPosition = (cellWidth - _dayTextPainter.width) / 2;

        /// To calculate the date start position by width and date painter
        final double dateXPosition = (cellWidth - _dateTextPainter.width) / 2;

        _yPosition = size.height / 2 -
            (_dayTextPainter.height + topPadding + _dateTextPainter.height) / 2;

        _dayTextPainter.paint(
            canvas, Offset(_xPosition + dayXPosition, _yPosition));
        if (_isToday) {
          _drawTodayCircle(
              canvas,
              _xPosition + dateXPosition,
              _yPosition + topPadding + _dayTextPainter.height,
              _dateTextPainter);
        }

        _dateTextPainter.paint(
            canvas,
            Offset(_xPosition + dateXPosition,
                _yPosition + topPadding + _dayTextPainter.height));

        if (_isRTL)
          _xPosition -= cellWidth;
        else
          _xPosition += cellWidth;
      }
    } else {
      _xPosition = 0;
      _yPosition = 0;
      if (_isRTL) {
        _xPosition = size.width - _width;
      }
      bool _hasToday = false;
      for (int i = 0; i < 7; i++) {
        _currentDate = _visibleDates[i];
        _dayText = DateFormat(_monthViewSettings.dayFormat, _locale)
            .format(_currentDate)
            .toString()
            .toUpperCase();

        _updateViewHeaderFormat();

        _hasToday = _monthViewSettings.numberOfWeeksInView > 0 &&
                _monthViewSettings.numberOfWeeksInView < 6
            ? true
            : _visibleDates[_visibleDates.length ~/ 2].month == today.month
                ? true
                : false;

        if (_hasToday &&
            isDateWithInDateRange(_visibleDates[0],
                _visibleDates[_visibleDates.length - 1], today) &&
            _currentDate.weekday == today.weekday) {
          dayTextStyle =
              _viewHeaderDayStyle.copyWith(color: _todayHighlightColor);
        } else {
          dayTextStyle = _viewHeaderDayStyle;
        }

        _updateDayTextPainter(dayTextStyle, _width);

        if (_yPosition == 0) {
          _yPosition = (_viewHeaderHeight - _dayTextPainter.height) / 2;
        }

        _dayTextPainter.paint(
            canvas,
            Offset(_xPosition + (_width / 2 - _dayTextPainter.width / 2),
                _yPosition));

        if (_isRTL)
          _xPosition -= _width;
        else
          _xPosition += _width;
      }
    }
  }

  void _updateViewHeaderFormat() {
    if (_view != CalendarView.day && _view != CalendarView.month) {
      //// EE format value shows the week days as S, M, T, W, T, F, S.
      if (_timeSlotViewSettings.dayFormat == 'EE') {
        _dayText = _dayText[0];
      }
    } else if (_view == CalendarView.month) {
      //// EE format value shows the week days as S, M, T, W, T, F, S.
      if (_monthViewSettings.dayFormat == 'EE') {
        _dayText = _dayText[0];
      }
    }
  }

  void _updateDayTextPainter(TextStyle dayTextStyle, double _width) {
    final TextSpan dayTextSpan = TextSpan(
      text: _dayText,
      style: dayTextStyle,
    );

    _dayTextPainter = _dayTextPainter ?? TextPainter();
    _dayTextPainter.text = dayTextSpan;
    _dayTextPainter.textDirection = TextDirection.ltr;
    _dayTextPainter.textAlign = TextAlign.left;
    _dayTextPainter.textWidthBasis = TextWidthBasis.longestLine;

    _dayTextPainter.layout(minWidth: 0, maxWidth: _width);
  }

  double _getViewHeaderWidth(double _width) {
    if (_view != CalendarView.month) {
      if (_view == null || _view == CalendarView.day) {
        _width = _timeLabelWidth;
      } else {
        _width -= _timeLabelWidth;
      }
    } else {
      _width = _width / 7;
    }
    return _width;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _ViewHeaderViewPainter oldWidget = oldDelegate;
    return oldWidget._visibleDates != _visibleDates ||
        oldWidget._viewHeaderStyle != _viewHeaderStyle ||
        oldWidget._viewHeaderHeight != _viewHeaderHeight ||
        oldWidget._todayHighlightColor != _todayHighlightColor ||
        oldWidget._timeSlotViewSettings != _timeSlotViewSettings ||
        oldWidget._monthViewSettings != _monthViewSettings ||
        oldWidget._cellBorderColor != _cellBorderColor ||
        oldWidget._calendarTheme != _calendarTheme ||
        oldWidget._isRTL != _isRTL ||
        oldWidget._locale != _locale;
  }

  //// draw today highlight circle in view header.
  void _drawTodayCircle(
      Canvas canvas, double x, double y, TextPainter dateTextPainter) {
    _circlePainter = _circlePainter ?? Paint();
    _circlePainter.color = _todayHighlightColor;
    const double _circlePadding = 3;
    final double painterWidth = dateTextPainter.width / 2;
    final double painterHeight = dateTextPainter.height / 2;
    final double radius =
        painterHeight > painterWidth ? painterHeight : painterWidth;
    canvas.drawCircle(Offset(x + painterWidth, y + painterHeight),
        radius + _circlePadding, _circlePainter);
  }

  /// overrides this property to build the semantics information which uses to
  /// return the required information for accessibility, need to return the list
  /// of custom painter semantics which contains the rect area and the semantics
  /// properties for accessibility
  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      return _getSemanticsBuilder(size);
    };
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    final _ViewHeaderViewPainter _oldWidget = oldDelegate;
    return _oldWidget._visibleDates != _visibleDates;
  }

  String _getAccessibilityText(DateTime date) {
    if (!isDateWithInDateRange(_minDate, _maxDate, date)) {
      return DateFormat('EEEEE').format(date).toString() +
          DateFormat('dd/MMMM/yyyy').format(date).toString() +
          ', Disabled date';
    }

    return DateFormat('EEEEE').format(date).toString() +
        DateFormat('dd/MMMM/yyyy').format(date).toString();
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> _semanticsBuilder =
        <CustomPainterSemantics>[];
    double _left, _top, _cellWidth;
    if (_view == CalendarView.month) {
      _cellWidth = size.width / 7;
      _left = _isRTL ? size.width - _cellWidth : 0;
      _top = 0;
      for (int i = 0; i < 7; i++) {
        _semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(_left, _top, _cellWidth, size.height),
          properties: SemanticsProperties(
            label: DateFormat('EEEEE')
                .format(_visibleDates[i])
                .toString()
                .toUpperCase(),
            textDirection: TextDirection.ltr,
          ),
        ));
        if (_isRTL) {
          _left -= _cellWidth;
        } else {
          _left += _cellWidth;
        }
      }
    } else {
      _top = 0;
      _cellWidth = _view == CalendarView.day
          ? size.width
          : (size.width - _timeLabelWidth) / _visibleDates.length;
      if (_isRTL) {
        _left = _view == CalendarView.day
            ? size.width - _timeLabelWidth
            : (size.width - _timeLabelWidth) - _cellWidth;
      } else {
        _left = _view == CalendarView.day ? 0 : _timeLabelWidth;
      }
      for (int i = 0; i < _visibleDates.length; i++) {
        _semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(_left, _top, _cellWidth, size.height),
          properties: SemanticsProperties(
            label: _getAccessibilityText(_visibleDates[i]),
            textDirection: TextDirection.ltr,
          ),
        ));
        if (_isRTL) {
          _left -= _cellWidth;
        } else {
          _left += _cellWidth;
        }
      }
    }

    return _semanticsBuilder;
  }
}
