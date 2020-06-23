part of calendar;

class _TimeSlotView extends CustomPainter {
  _TimeSlotView(
      this._visibleDates,
      this._horizontalLinesCount,
      this._timeIntervalHeight,
      this._timeLabelWidth,
      this._cellBorderColor,
      this._calendarTheme,
      this._timeSlotViewSettings,
      this._isRTL,
      this._mouseHoverPosition);

  final List<DateTime> _visibleDates;
  final double _horizontalLinesCount;
  final double _timeIntervalHeight;
  final double _timeLabelWidth;
  final Color _cellBorderColor;
  final SfCalendarThemeData _calendarTheme;
  final TimeSlotViewSettings _timeSlotViewSettings;
  final bool _isRTL;
  final Offset _mouseHoverPosition;
  double _cellWidth;
  Paint _linePainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final double _width = size.width - _timeLabelWidth;
    double x, y;
    y = _timeIntervalHeight;
    _linePainter = _linePainter ?? Paint();
    _linePainter.strokeWidth = 0.5;
    _linePainter.strokeCap = StrokeCap.round;
    _linePainter.color = _cellBorderColor ?? _calendarTheme.cellBorderColor;

    for (int i = 1; i <= _horizontalLinesCount; i++) {
      final Offset _start = Offset(_isRTL ? 0 : _timeLabelWidth, y);
      final Offset _end =
          Offset(_isRTL ? size.width - _timeLabelWidth : size.width, y);
      canvas.drawLine(_start, _end, _linePainter);

      y += _timeIntervalHeight;
      if (y == size.height) {
        break;
      }
    }

    _cellWidth = _width / _visibleDates.length;
    if (_isRTL) {
      x = _cellWidth;
    } else {
      x = _timeLabelWidth + _cellWidth;
    }

    for (int i = 0; i < _visibleDates.length - 1; i++) {
      final Offset _start = Offset(x, 0);
      final Offset _end = Offset(x, size.height);
      canvas.drawLine(_start, _end, _linePainter);
      x += _cellWidth;
    }

    if (_mouseHoverPosition != null) {
      final double _left = (_mouseHoverPosition.dx ~/ _cellWidth) * _cellWidth;
      final double _top =
          (_mouseHoverPosition.dy ~/ _timeIntervalHeight) * _timeIntervalHeight;
      _linePainter.style = PaintingStyle.stroke;
      _linePainter.strokeWidth = 2;
      _linePainter.color = _calendarTheme.selectionBorderColor.withOpacity(0.4);
      canvas.drawRect(
          Rect.fromLTWH(
              _left + _timeLabelWidth, _top, _cellWidth, _timeIntervalHeight),
          _linePainter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _TimeSlotView oldWidget = oldDelegate;
    return oldWidget._visibleDates != _visibleDates ||
        oldWidget._timeIntervalHeight != _timeIntervalHeight ||
        oldWidget._timeLabelWidth != _timeLabelWidth ||
        oldWidget._cellBorderColor != _cellBorderColor ||
        oldWidget._horizontalLinesCount != _horizontalLinesCount ||
        oldWidget._calendarTheme != _calendarTheme ||
        oldWidget._isRTL != _isRTL ||
        (kIsWeb && oldWidget._mouseHoverPosition != _mouseHoverPosition);
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> _semanticsBuilder =
        <CustomPainterSemantics>[];
    double _left, _top, _cellWidth, _cellHeight;
    _top = 0;
    _cellWidth = (size.width - _timeLabelWidth) / _visibleDates.length;
    _left =
        _isRTL ? (size.width - _timeLabelWidth) - _cellWidth : _timeLabelWidth;
    _cellHeight = _timeIntervalHeight;
    final dynamic hour = (_timeSlotViewSettings.startHour -
            _timeSlotViewSettings.startHour.toInt()) *
        60;
    for (int j = 0; j < _visibleDates.length; j++) {
      DateTime date = _visibleDates[j];
      for (int i = 0; i < _horizontalLinesCount; i++) {
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
        _top += _cellHeight;
      }

      if (_isRTL) {
        if (_left.round() == _cellWidth.round()) {
          _left = 0;
        } else {
          _left -= _cellWidth;
        }
        _top = 0;
        if (_left < 0) {
          _left = (size.width - _timeLabelWidth) - _cellWidth;
        }
      } else {
        _left += _cellWidth;
        _top = 0;
        if (_left.round() == size.width.round()) {
          _left = _timeLabelWidth;
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
    final _TimeSlotView _oldWidget = oldDelegate;
    return _oldWidget._visibleDates != _visibleDates;
  }
}
