part of calendar;

class _MonthCellPainter extends CustomPainter {
  _MonthCellPainter(
      this._visibleDates,
      this._rowCount,
      this._monthCellStyle,
      this._isRTL,
      this._todayHighlightColor,
      this._cellBorderColor,
      this._calendarTheme,
      this._mouseHoverPosition,
      this._minDate,
      this._maxDate);

  final int _rowCount;
  final MonthCellStyle _monthCellStyle;
  final List<DateTime> _visibleDates;
  final bool _isRTL;
  final Color _todayHighlightColor;
  final Color _cellBorderColor;
  final SfCalendarThemeData _calendarTheme;
  final Offset _mouseHoverPosition;
  final DateTime _minDate;
  final DateTime _maxDate;
  String _date;
  Paint _linePainter, _circlePainter;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    double cellWidth, xPosition, yPosition, cellHeight;
    const int numberOfDaysInWeek = 7;
    cellWidth = size.width / numberOfDaysInWeek;
    cellHeight = size.height / _rowCount;
    xPosition = _isRTL ? size.width - cellWidth : 0;
    yPosition = 5;
    _textPainter = _textPainter ?? TextPainter();
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = TextAlign.center;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    TextStyle _textStyle =
        _monthCellStyle.textStyle ?? _calendarTheme.activeDatesTextStyle;
    final DateTime _currentDate =
        _visibleDates[(_visibleDates.length / 2).truncate()];
    final DateTime _nextMonthDate = getNextMonthDate(_currentDate);
    final DateTime _previousMonthDate = getPreviousMonthDate(_currentDate);
    final DateTime _today = DateTime.now();
    bool _isCurrentDate;

    _linePainter = _linePainter ?? Paint();
    _linePainter.isAntiAlias = true;
    TextStyle todayTextStyle = _monthCellStyle.todayTextStyle;
    TextStyle currentMonthTextStyle = _monthCellStyle.textStyle;
    TextStyle previousMonthTextStyle = _monthCellStyle.trailingDatesTextStyle;
    TextStyle nextMonthTextStyle = _monthCellStyle.leadingDatesTextStyle;

    todayTextStyle ??= _calendarTheme.todayTextStyle;
    currentMonthTextStyle ??= _calendarTheme.activeDatesTextStyle;
    previousMonthTextStyle ??= _calendarTheme.trailingDatesTextStyle;
    nextMonthTextStyle ??= _calendarTheme.leadingDatesTextStyle;

    const double linePadding = 0.5;
    for (int i = 0; i < _visibleDates.length; i++) {
      _isCurrentDate = false;
      if (_visibleDates[i].month == _nextMonthDate.month) {
        _textStyle = nextMonthTextStyle;
        _linePainter.color = _monthCellStyle.leadingDatesBackgroundColor ??
            _calendarTheme.leadingDatesBackgroundColor;
      } else if (_visibleDates[i].month == _previousMonthDate.month) {
        _textStyle = previousMonthTextStyle;
        _linePainter.color = _monthCellStyle.trailingDatesBackgroundColor ??
            _calendarTheme.trailingDatesBackgroundColor;
      } else {
        _textStyle = currentMonthTextStyle;
        _linePainter.color = _monthCellStyle.backgroundColor ??
            _calendarTheme.activeDatesBackgroundColor;
      }

      if (_rowCount <= 4) {
        _textStyle = currentMonthTextStyle;
      }

      if (_visibleDates[i].month == _today.month &&
          _visibleDates[i].day == _today.day &&
          _visibleDates[i].year == _today.year) {
        _linePainter.color = _monthCellStyle.todayBackgroundColor ??
            _calendarTheme.todayBackgroundColor;
        _textStyle = todayTextStyle;
        _isCurrentDate = true;
      }

      if (!isDateWithInDateRange(_minDate, _maxDate, _visibleDates[i])) {
        if (_calendarTheme.brightness == Brightness.light) {
          _textStyle = TextStyle(
              color: Colors.black26, fontSize: 13, fontFamily: 'Roboto');
        } else {
          _textStyle = TextStyle(
              color: Colors.white38, fontSize: 13, fontFamily: 'Roboto');
        }
      }

      _date = _date = _visibleDates[i].day.toString();
      final TextSpan span = TextSpan(
        text: _date,
        style: _textStyle,
      );

      _textPainter.text = span;

      _textPainter.layout(minWidth: 0, maxWidth: cellWidth);

      canvas.drawRect(
          Rect.fromLTWH(xPosition, yPosition - 5, cellWidth, cellHeight),
          _linePainter);

      if (_mouseHoverPosition != null) {
        if (xPosition <= _mouseHoverPosition.dx &&
            xPosition + cellWidth >= _mouseHoverPosition.dx &&
            yPosition - 5 <= _mouseHoverPosition.dy &&
            (yPosition + cellHeight) - 5 >= _mouseHoverPosition.dy) {
          _linePainter.style = PaintingStyle.stroke;
          _linePainter.strokeWidth = 2;
          _linePainter.color =
              _calendarTheme.selectionBorderColor.withOpacity(0.4);
          canvas.drawRect(
              Rect.fromLTWH(
                  xPosition, yPosition - 4, cellWidth, cellHeight - 1),
              _linePainter);
        }
      }

      if (_isCurrentDate) {
        _circlePainter = _circlePainter ?? Paint();
        _circlePainter.color = _todayHighlightColor;
        _circlePainter.isAntiAlias = true;

        canvas.drawCircle(
            Offset(xPosition + cellWidth / 2,
                yPosition + _textStyle.fontSize * 0.6),
            _textStyle.fontSize * 0.75,
            _circlePainter);
      }

      _textPainter.paint(canvas, Offset(xPosition, yPosition));
      if (_isRTL) {
        if (xPosition.round() == cellWidth.round()) {
          xPosition = 0;
        } else {
          xPosition -= cellWidth;
        }
        if (xPosition < 0) {
          xPosition = size.width - cellWidth;
          yPosition += cellHeight;
        }
      } else {
        xPosition += cellWidth;
        if (xPosition.round() >= size.width.round()) {
          xPosition = 0;
          yPosition += cellHeight;
        }
      }
    }

    yPosition = cellHeight;
    _linePainter.strokeWidth = 0.5;
    _linePainter.color = _cellBorderColor ?? _calendarTheme.cellBorderColor;
    canvas.drawLine(const Offset(0, linePadding),
        Offset(size.width, linePadding), _linePainter);
    for (int i = 0; i < _rowCount - 1; i++) {
      canvas.drawLine(
          Offset(0, yPosition), Offset(size.width, yPosition), _linePainter);
      yPosition += cellHeight;
    }

    canvas.drawLine(Offset(0, size.height - linePadding),
        Offset(size.width, size.height - linePadding), _linePainter);
    xPosition = cellWidth;
    canvas.drawLine(const Offset(linePadding, 0),
        Offset(linePadding, size.height), _linePainter);
    for (int i = 0; i < 6; i++) {
      canvas.drawLine(
          Offset(xPosition, 0), Offset(xPosition, size.height), _linePainter);
      xPosition += cellWidth;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _MonthCellPainter oldWidget = oldDelegate;
    return oldWidget._visibleDates != _visibleDates ||
        oldWidget._rowCount != _rowCount ||
        oldWidget._todayHighlightColor != _todayHighlightColor ||
        oldWidget._monthCellStyle != _monthCellStyle ||
        oldWidget._cellBorderColor != _cellBorderColor ||
        oldWidget._calendarTheme != _calendarTheme ||
        oldWidget._isRTL != _isRTL ||
        (kIsWeb && oldWidget._mouseHoverPosition != _mouseHoverPosition);
  }

  String _getAccessibilityText(DateTime date) {
    if (!isDateWithInDateRange(_minDate, _maxDate, date)) {
      return DateFormat('EEE, dd/MMMM/yyyy').format(date).toString() +
          ', Disabled date';
    }

    return DateFormat('EEE, dd/MMMM/yyyy').format(date).toString();
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> _semanticsBuilder =
        <CustomPainterSemantics>[];
    double _left, _top, _cellWidth, _cellHeight;
    _top = 0;
    _cellWidth = size.width / 7;
    _cellHeight = size.height / _rowCount;
    _left = _isRTL ? size.width - _cellWidth : 0;
    for (int i = 0; i < _visibleDates.length; i++) {
      _semanticsBuilder.add(CustomPainterSemantics(
        rect: Rect.fromLTWH(_left, _top, _cellWidth, _cellHeight),
        properties: SemanticsProperties(
          label: _getAccessibilityText(_visibleDates[i]),
          textDirection: TextDirection.ltr,
        ),
      ));
      if (_isRTL) {
        if (_left.round() == _cellWidth.round()) {
          _left = 0;
        } else {
          _left -= _cellWidth;
        }
        if (_left < 0) {
          _left = size.width - _cellWidth;
          _top += _cellHeight;
        }
      } else {
        _left += _cellWidth;
        if (_left.round() == size.width.round()) {
          _top += _cellHeight;
          _left = 0;
        }
      }
    }

    return _semanticsBuilder;
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
    final _MonthCellPainter _oldWidget = oldDelegate;
    return _oldWidget._visibleDates != _visibleDates;
  }
}
