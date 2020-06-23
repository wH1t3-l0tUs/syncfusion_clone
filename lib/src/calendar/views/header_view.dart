part of calendar;

class _HeaderViewPainter extends CustomPainter {
  _HeaderViewPainter(
      this._visibleDates,
      this._headerStyle,
      this._currentDate,
      this._view,
      this._numberOfWeeksInView,
      this._calendarTheme,
      this._isRTL,
      this._locale);

  final List<DateTime> _visibleDates;
  final CalendarHeaderStyle _headerStyle;
  final SfCalendarThemeData _calendarTheme;
  final DateTime _currentDate;
  final CalendarView _view;
  final int _numberOfWeeksInView;
  final bool _isRTL;
  final String _locale;
  String _headerText;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    double _xPosition = 5.0;
    _textPainter = _textPainter ?? TextPainter();
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    String _format = 'MMM';

    if (_view == CalendarView.month &&
        _numberOfWeeksInView != 6 &&
        _visibleDates[0].month !=
            _visibleDates[_visibleDates.length - 1].month) {
      _headerText =
          DateFormat(_format, _locale).format(_visibleDates[0]).toString() +
              ' ' +
              _visibleDates[0].year.toString() +
              ' - ' +
              DateFormat(_format, _locale)
                  .format(_visibleDates[_visibleDates.length - 1])
                  .toString() +
              ' ' +
              _visibleDates[_visibleDates.length - 1].year.toString();
    } else if (!_isTimelineView(_view)) {
      _format = 'MMMM';
      _headerText =
          DateFormat(_format, _locale).format(_currentDate).toString() +
              ' ' +
              _currentDate.year.toString();
    } else {
      _format = 'MMM';
      final DateTime startDate = _visibleDates[0];
      final DateTime endDate = _visibleDates[_visibleDates.length - 1];
      String startText = '';
      String endText = '';
      startText = DateFormat(_format, _locale).format(startDate).toString();
      if (_view != CalendarView.timelineDay) {
        startText = startDate.day.toString() + ' ' + startText + ' - ';
        endText = endDate.day.toString() +
            ' ' +
            DateFormat(_format, _locale).format(endDate).toString() +
            ' ' +
            endDate.year.toString();
      } else {
        endText = ' ' + startDate.year.toString();
      }

      _headerText = startText + endText;
    }

    TextStyle style = _headerStyle.textStyle;
    style ??= _calendarTheme.headerTextStyle;

    final TextSpan span = TextSpan(text: _headerText, style: style);
    _textPainter.text = span;

    if (_headerStyle.textAlign == TextAlign.justify) {
      _textPainter.textAlign = _headerStyle.textAlign;
    }

    _textPainter.layout(minWidth: 0, maxWidth: size.width - _xPosition);

    if (_headerStyle.textAlign == TextAlign.right ||
        _headerStyle.textAlign == TextAlign.end) {
      _xPosition = size.width - _textPainter.width;
    } else if (_headerStyle.textAlign == TextAlign.center) {
      _xPosition = size.width / 2 - _textPainter.width / 2;
    }

    if (_isRTL) {
      _xPosition = size.width - _textPainter.width - _xPosition;
      if (_headerStyle.textAlign == TextAlign.left ||
          _headerStyle.textAlign == TextAlign.end) {
        _xPosition = 5.0;
      } else if (_headerStyle.textAlign == TextAlign.center) {
        _xPosition = size.width / 2 - _textPainter.width / 2;
      }
    }

    _textPainter.paint(
        canvas, Offset(_xPosition, size.height / 2 - _textPainter.height / 2));
  }

  /// overrides this property to build the semantics information which uses to
  /// return the required information for accessibility, need to return the list
  /// of custom painter semantics which contains the rect area and the semantics
  /// properties for accessibility
  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      final dynamic rect = Offset.zero & size;
      return <CustomPainterSemantics>[
        CustomPainterSemantics(
          rect: rect,
          properties: SemanticsProperties(
            label: _headerText,
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    final _HeaderViewPainter oldWidget = oldDelegate;
    return oldWidget._headerText != _headerText;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _HeaderViewPainter oldWidget = oldDelegate;
    return oldWidget._visibleDates != _visibleDates ||
        oldWidget._headerStyle != _headerStyle ||
        oldWidget._currentDate != _currentDate ||
        oldWidget._calendarTheme != _calendarTheme ||
        oldWidget._isRTL != _isRTL ||
        oldWidget._locale != _locale;
  }
}
