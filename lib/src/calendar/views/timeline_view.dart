part of calendar;

class _TimelineView extends CustomPainter {
  _TimelineView(
      this._horizontalLinesCountPerView,
      this._visibleDates,
      this._timeLabelWidth,
      this._timeSlotViewSettings,
      this._timeIntervalHeight,
      this._cellBorderColor,
      this._isRTL,
      this._locale,
      this._calendarTheme,
      this._mouseHoverPosition);

  final double _horizontalLinesCountPerView;
  final List<DateTime> _visibleDates;
  SfCalendar calendar;
  final double _timeLabelWidth;
  final TimeSlotViewSettings _timeSlotViewSettings;
  final double _timeIntervalHeight;
  final Color _cellBorderColor;
  final SfCalendarThemeData _calendarTheme;
  final String _locale;
  final bool _isRTL;
  final Offset _mouseHoverPosition;
  double _x1, _x2, _y1, _y2;
  Paint _linePainter;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _x1 = 0;
    _x2 = size.width;
    _y1 = _timeIntervalHeight;
    _y2 = _timeIntervalHeight;
    _linePainter = _linePainter ?? Paint();
    _linePainter.strokeWidth = 0.5;
    _linePainter.strokeCap = StrokeCap.round;
    _linePainter.color = _cellBorderColor != null
        ? _cellBorderColor
        : _calendarTheme.cellBorderColor;
    _x1 = 0;
    _x2 = size.width;
    _y1 = _timeLabelWidth;
    _y2 = _timeLabelWidth;

    final Offset _start = Offset(_x1, _y1);
    final Offset _end = Offset(_x2, _y2);
    canvas.drawLine(_start, _end, _linePainter);

    _x1 = 0;
    _x2 = 0;
    _y2 = size.height;
    if (_isRTL) {
      _x1 = size.width;
      _x2 = size.width;
    }
    final List<Offset> points = <Offset>[];
    for (int i = 0;
        i < _horizontalLinesCountPerView * _visibleDates.length;
        i++) {
      _y1 = _timeLabelWidth;
      if (i % _horizontalLinesCountPerView == 0) {
        _y1 = 0;
        _drawTimeLabels(canvas, size, _x1);
      }

      if (kIsWeb) {
        canvas.drawLine(Offset(_x1, _y1), Offset(_x2, _y2), _linePainter);
      } else {
        points.add(Offset(_x1, _y1));
        points.add(Offset(_x2, _y2));
      }

      if (_isRTL) {
        _x1 -= _timeIntervalHeight;
        _x2 -= _timeIntervalHeight;
      } else {
        _x1 += _timeIntervalHeight;
        _x2 += _timeIntervalHeight;
      }
    }

    if (!kIsWeb) {
      canvas.drawPoints(PointMode.lines, points, _linePainter);
    }

    if (_mouseHoverPosition != null) {
      final double _left =
          (_mouseHoverPosition.dx ~/ _timeIntervalHeight) * _timeIntervalHeight;
      final double _top = _timeLabelWidth;
      _linePainter.style = PaintingStyle.stroke;
      _linePainter.strokeWidth = 2;
      _linePainter.color = _calendarTheme.selectionBorderColor.withOpacity(0.4);
      canvas.drawRect(
          Rect.fromLTWH(_left, _top, _timeIntervalHeight, size.height),
          _linePainter);
    }
  }

  void _drawTimeLabels(Canvas canvas, Size size, double xPosition) {
    final double _startHour = _timeSlotViewSettings.startHour;
    final int _timeInterval = _getTimeInterval(_timeSlotViewSettings);
    final String _timeFormat = _timeSlotViewSettings.timeFormat;

    _textPainter = _textPainter ?? TextPainter();
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = TextAlign.left;
    _textPainter.textWidthBasis = TextWidthBasis.parent;
    TextStyle timeTextStyle = _timeSlotViewSettings.timeTextStyle;
    timeTextStyle ??= _calendarTheme.timeTextStyle;

    DateTime date = DateTime.now();

    for (int i = 0; i < _horizontalLinesCountPerView; i++) {
      final dynamic hour = (_startHour - _startHour.toInt()) * 60;
      final dynamic minute = (i * _timeInterval) + hour;
      date = DateTime(
          date.day, date.month, date.year, _startHour.toInt(), minute.toInt());
      final dynamic _time =
          DateFormat(_timeFormat, _locale).format(date).toString();
      final TextSpan span = TextSpan(
        text: _time,
        style: timeTextStyle,
      );

      _textPainter.text = span;
      _textPainter.layout(minWidth: 0, maxWidth: _timeIntervalHeight);
      if (_textPainter.height > _timeLabelWidth) {
        return;
      }

      _textPainter.paint(
          canvas,
          Offset(_isRTL ? xPosition - _textPainter.width : xPosition,
              _timeLabelWidth / 2 - _textPainter.height / 2));
      if (_isRTL) {
        xPosition -= _timeIntervalHeight;
      } else {
        xPosition += _timeIntervalHeight;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _TimelineView oldWidget = oldDelegate;
    return oldWidget._horizontalLinesCountPerView !=
            _horizontalLinesCountPerView ||
        oldWidget._timeLabelWidth != _timeLabelWidth ||
        oldWidget._visibleDates != _visibleDates ||
        oldWidget._cellBorderColor != _cellBorderColor ||
        oldWidget._calendarTheme != _calendarTheme ||
        oldWidget._timeSlotViewSettings != _timeSlotViewSettings ||
        oldWidget._isRTL != _isRTL ||
        oldWidget._locale != _locale ||
        (kIsWeb && oldWidget._mouseHoverPosition != _mouseHoverPosition);
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

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> _semanticsBuilder =
        <CustomPainterSemantics>[];
    double _left, _top, _cellWidth, _cellHeight;
    _top = _timeLabelWidth;
    _cellWidth = _timeIntervalHeight;
    _cellHeight = size.height;
    _left = _isRTL ? size.width - _cellWidth : 0;
    for (int j = 0; j < _visibleDates.length; j++) {
      DateTime date = _visibleDates[j];
      final dynamic hour = (_timeSlotViewSettings.startHour -
              _timeSlotViewSettings.startHour.toInt()) *
          60;
      for (int i = 0; i < _horizontalLinesCountPerView; i++) {
        final dynamic minute =
            (i * _getTimeInterval(_timeSlotViewSettings)) + hour;
        date = DateTime(date.year, date.month, date.day,
            _timeSlotViewSettings.startHour.toInt(), minute.toInt());
        _semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(_left, _top, _cellWidth, _cellHeight),
          properties: SemanticsProperties(
            label: DateFormat('h a, dd/MMMM/yyyy').format(date).toString(),
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

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    final _TimelineView _oldWidget = oldDelegate;
    return _oldWidget._visibleDates != _visibleDates;
  }
}

class _TimelineViewHeaderView extends CustomPainter {
  _TimelineViewHeaderView(
      this._visibleDates,
      this._calendarViewState,
      this._repaintNotifier,
      this._viewHeaderStyle,
      this._timeSlotViewSettings,
      this._viewHeaderHeight,
      this._isRTL,
      this._todayHighlightColor,
      this._locale,
      this._calendarTheme,
      this._minDate,
      this._maxDate)
      : super(repaint: _repaintNotifier);

  final List<DateTime> _visibleDates;
  final ViewHeaderStyle _viewHeaderStyle;
  final TimeSlotViewSettings _timeSlotViewSettings;
  final double _viewHeaderHeight;
  final Color _todayHighlightColor;
  final double _padding = 5;
  final ValueNotifier<bool> _repaintNotifier;
  final _CalendarViewState _calendarViewState;
  final SfCalendarThemeData _calendarTheme;
  final bool _isRTL;
  final String _locale;
  final DateTime _minDate;
  final DateTime _maxDate;
  double _xPosition = 0;
  TextPainter dayTextPainter, dateTextPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final DateTime _today = DateTime.now();
    final double childWidth = size.width / _visibleDates.length;
    final double scrolledPosition =
        _calendarViewState._timelineViewHeaderScrollController.offset;
    final int index = scrolledPosition ~/ childWidth;
    _xPosition = scrolledPosition;

    TextStyle viewHeaderDateTextStyle =
        _calendarTheme.brightness == Brightness.light
            ? TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto')
            : TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto');
    TextStyle viewHeaderDayTextStyle =
        _calendarTheme.brightness == Brightness.light
            ? TextStyle(
                color: Colors.black87,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto')
            : TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto');

    TextStyle _viewHeaderDayStyle = _viewHeaderStyle.dayTextStyle;
    TextStyle _viewHeaderDateStyle = _viewHeaderStyle.dateTextStyle;

    if (viewHeaderDayTextStyle == _calendarTheme.viewHeaderDayTextStyle) {
      viewHeaderDayTextStyle = viewHeaderDayTextStyle.copyWith(fontSize: 18);
    }

    if (viewHeaderDateTextStyle == _calendarTheme.viewHeaderDateTextStyle) {
      viewHeaderDateTextStyle = viewHeaderDateTextStyle.copyWith(fontSize: 18);
    }

    _viewHeaderDayStyle ??= viewHeaderDayTextStyle;
    _viewHeaderDateStyle ??= viewHeaderDateTextStyle;

    TextStyle _dayTextStyle = _viewHeaderDayStyle;
    TextStyle _dateTextStyle = _viewHeaderDateStyle;

    for (int i = 0; i < _visibleDates.length; i++) {
      if (i < index) {
        continue;
      }

      final DateTime _currentDate = _visibleDates[i];
      String dayFormat = 'EE';
      dayFormat = dayFormat == _timeSlotViewSettings.dayFormat
          ? 'EEEE'
          : _timeSlotViewSettings.dayFormat;

      final String dayText =
          DateFormat(dayFormat, _locale).format(_currentDate).toString();
      final String dateText = DateFormat(_timeSlotViewSettings.dateFormat)
          .format(_currentDate)
          .toString();

      if (isSameDate(_currentDate, _today)) {
        _dayTextStyle =
            _viewHeaderDayStyle.copyWith(color: _todayHighlightColor);
        _dateTextStyle =
            _viewHeaderDateStyle.copyWith(color: _todayHighlightColor);
      } else {
        _dateTextStyle = _viewHeaderDateStyle;
        _dayTextStyle = _viewHeaderDayStyle;
      }

      if (!isDateWithInDateRange(_minDate, _maxDate, _currentDate)) {
        if (_calendarTheme.brightness == Brightness.light) {
          _dayTextStyle = _dayTextStyle.copyWith(color: Colors.black26);
          _dateTextStyle = _dateTextStyle.copyWith(color: Colors.black26);
        } else {
          _dayTextStyle = _dayTextStyle.copyWith(color: Colors.white38);
          _dateTextStyle = _dateTextStyle.copyWith(color: Colors.white38);
        }
      }

      final TextSpan dayTextSpan =
          TextSpan(text: dayText, style: _dayTextStyle);

      dayTextPainter = dayTextPainter ?? TextPainter();
      dayTextPainter.text = dayTextSpan;
      dayTextPainter.textDirection = TextDirection.ltr;
      dayTextPainter.textAlign = TextAlign.left;
      dayTextPainter.textWidthBasis = TextWidthBasis.longestLine;

      final TextSpan dateTextSpan =
          TextSpan(text: dateText, style: _dateTextStyle);

      dateTextPainter = dateTextPainter ?? TextPainter();
      dateTextPainter.text = dateTextSpan;
      dateTextPainter.textDirection = TextDirection.ltr;
      dateTextPainter.textAlign = TextAlign.left;
      dateTextPainter.textWidthBasis = TextWidthBasis.longestLine;

      dayTextPainter.layout(minWidth: 0, maxWidth: childWidth);
      dateTextPainter.layout(minWidth: 0, maxWidth: childWidth);
      if (dateTextPainter.width +
              _xPosition +
              (_padding * 2) +
              dayTextPainter.width >
          (i + 1) * childWidth) {
        _xPosition = ((i + 1) * childWidth) -
            (dateTextPainter.width + (_padding * 2) + dayTextPainter.width);
      }

      if (_isRTL) {
        dateTextPainter.paint(
            canvas,
            Offset(
                size.width -
                    _xPosition -
                    (_padding * 2) -
                    dayTextPainter.width -
                    dateTextPainter.width,
                _viewHeaderHeight / 2 - dateTextPainter.height / 2));
        dayTextPainter.paint(
            canvas,
            Offset(size.width - _xPosition - _padding - dayTextPainter.width,
                _viewHeaderHeight / 2 - dayTextPainter.height / 2));
      } else {
        dateTextPainter.paint(
            canvas,
            Offset(_padding + _xPosition,
                _viewHeaderHeight / 2 - dateTextPainter.height / 2));
        dayTextPainter.paint(
            canvas,
            Offset(dateTextPainter.width + _xPosition + (_padding * 2),
                _viewHeaderHeight / 2 - dayTextPainter.height / 2));
      }

      if (index == i) {
        _xPosition = (i + 1) * childWidth;
      } else {
        _xPosition += childWidth;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _TimelineViewHeaderView oldWidget = oldDelegate;
    return oldWidget._visibleDates != _visibleDates ||
        oldWidget._xPosition != _xPosition ||
        oldWidget._viewHeaderStyle != _viewHeaderStyle ||
        oldWidget._timeSlotViewSettings != _timeSlotViewSettings ||
        oldWidget._viewHeaderHeight != _viewHeaderHeight ||
        oldWidget._todayHighlightColor != _todayHighlightColor ||
        oldWidget._isRTL != _isRTL ||
        oldWidget._locale != _locale;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> _semanticsBuilder =
        <CustomPainterSemantics>[];
    double _left, _top, _cellWidth;
    _top = 0;
    _cellWidth = size.width / _visibleDates.length;
    _left = _isRTL ? size.width - _cellWidth : 0;
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

    return _semanticsBuilder;
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
    final _TimelineViewHeaderView _oldWidget = oldDelegate;
    return _oldWidget._visibleDates != _visibleDates ||
        _oldWidget._calendarTheme != _calendarTheme;
  }
}
