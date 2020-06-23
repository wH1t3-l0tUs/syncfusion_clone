part of calendar;

class _AllDayAppointmentPainter extends CustomPainter {
  _AllDayAppointmentPainter(
      this._calendar,
      this._visibleDates,
      this._visibleAppointment,
      this._timeLabelWidth,
      this._allDayPainterHeight,
      this._isExpandable,
      this._isExpanding,
      this._isRTL,
      this._calendarTheme,
      this._repaintNotifier,
      {this.updateCalendarState})
      : super(repaint: _repaintNotifier);

  final SfCalendar _calendar;
  final List<DateTime> _visibleDates;
  final List<Appointment> _visibleAppointment;
  final ValueNotifier<_AppointmentView> _repaintNotifier;
  final _UpdateCalendarState updateCalendarState;
  final double _timeLabelWidth;
  final double _allDayPainterHeight;
  final bool _isRTL;
  final SfCalendarThemeData _calendarTheme;

  //// is expandable variable used to indicate whether the all day layout expandable or not.
  final bool _isExpandable;

  //// is expanding variable used to identify the animation currently running or not.
  //// It is used to restrict the expander icon show on initial animation.
  final bool _isExpanding;
  double cellWidth, cellHeight;
  Paint _rectPainter;
  TextPainter _textPainter;
  Paint _linePainter;
  TextPainter _expanderTextPainter;
  BoxPainter _boxPainter;
  int maxPosition;
  final _UpdateCalendarStateDetails _updateCalendarStateDetails =
      _UpdateCalendarStateDetails();

  @override
  void paint(Canvas canvas, Size size) {
    _updateCalendarStateDetails._allDayAppointmentViewCollection = null;
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    updateCalendarState(_updateCalendarStateDetails);
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _rectPainter = _rectPainter ?? Paint();
    _updateCalendarStateDetails._allDayAppointmentViewCollection =
        _updateCalendarStateDetails._allDayAppointmentViewCollection ??
            <_AppointmentView>[];

    if (_calendar.view == CalendarView.day) {
      _linePainter ??= Paint();
      _linePainter.strokeWidth = 0.5;
      _linePainter.strokeCap = StrokeCap.round;
      _linePainter.color = _calendar.cellBorderColor != null
          ? _calendar.cellBorderColor
          : _calendarTheme.cellBorderColor;
      //// Decrease the x position by 0.5 because draw the end point of the view
      /// draws half of the line to current view and hides another half.
      canvas.drawLine(
          Offset(
              _isRTL
                  ? size.width - _timeLabelWidth + 0.5
                  : _timeLabelWidth - 0.5,
              0),
          Offset(
              _isRTL
                  ? size.width - _timeLabelWidth + 0.5
                  : _timeLabelWidth - 0.5,
              size.height),
          _linePainter);
    }

    if (_visibleDates != _updateCalendarStateDetails._currentViewVisibleDates) {
      return;
    }

    _rectPainter.isAntiAlias = true;
    cellWidth = (size.width - _timeLabelWidth) / _visibleDates.length;
    cellHeight = size.height;
    const double textPadding = 3;
    maxPosition = 0;
    if (_updateCalendarStateDetails
        ._allDayAppointmentViewCollection.isNotEmpty) {
      maxPosition = _updateCalendarStateDetails._allDayAppointmentViewCollection
          .reduce(
              (_AppointmentView currentAppview, _AppointmentView nextAppview) =>
                  currentAppview.maxPositions > nextAppview.maxPositions
                      ? currentAppview
                      : nextAppview)
          .maxPositions;
    }

    if (maxPosition == -1) {
      maxPosition = 0;
    }

    final int _position = _allDayPainterHeight ~/ _kAllDayAppointmentHeight;
    for (int i = 0;
        i < _updateCalendarStateDetails._allDayAppointmentViewCollection.length;
        i++) {
      final _AppointmentView _appointmentView =
          _updateCalendarStateDetails._allDayAppointmentViewCollection[i];
      if (_appointmentView.canReuse) {
        continue;
      }

      final Appointment _appointment = _appointmentView.appointment;
      RRect rect;
      if (_isRTL) {
        rect = RRect.fromRectAndRadius(
            Rect.fromLTRB(
                ((_visibleDates.length - _appointmentView.endIndex) *
                        cellWidth) +
                    textPadding,
                (_kAllDayAppointmentHeight * _appointmentView.position)
                    .toDouble(),
                (_visibleDates.length - _appointmentView.startIndex) *
                    cellWidth,
                ((_kAllDayAppointmentHeight * _appointmentView.position) +
                        _kAllDayAppointmentHeight -
                        1)
                    .toDouble()),
            const Radius.circular((_kAllDayAppointmentHeight * 0.1) > 2
                ? 2
                : (_kAllDayAppointmentHeight * 0.1)));
      } else {
        rect = RRect.fromRectAndRadius(
            Rect.fromLTRB(
                _timeLabelWidth + (_appointmentView.startIndex * cellWidth),
                (_kAllDayAppointmentHeight * _appointmentView.position)
                    .toDouble(),
                (_appointmentView.endIndex * cellWidth) +
                    _timeLabelWidth -
                    textPadding,
                ((_kAllDayAppointmentHeight * _appointmentView.position) +
                        _kAllDayAppointmentHeight -
                        1)
                    .toDouble()),
            const Radius.circular((_kAllDayAppointmentHeight * 0.1) > 2
                ? 2
                : (_kAllDayAppointmentHeight * 0.1)));
      }
      _appointmentView.appointmentRect = rect;
      if (!_isRTL && rect.left < _timeLabelWidth - 1 ||
          rect.right > size.width + 1 ||
          (rect.bottom > _allDayPainterHeight - _kAllDayAppointmentHeight &&
              maxPosition > _position)) {
        continue;
      } else if (_isRTL && rect.right > size.width - _timeLabelWidth + 1 ||
          rect.left < 0 ||
          (rect.bottom > _allDayPainterHeight - _kAllDayAppointmentHeight &&
              maxPosition > _position)) {
        continue;
      }

      _rectPainter.color = _appointment.color;
      canvas.drawRRect(rect, _rectPainter);
      final TextSpan span = TextSpan(
        text: _appointment.subject,
        style: _calendar.appointmentTextStyle,
      );
      _textPainter = _textPainter ??
          TextPainter(
              textDirection: TextDirection.ltr,
              maxLines: 1,
              textAlign: TextAlign.left,
              textWidthBasis: TextWidthBasis.longestLine);
      _textPainter.text = span;

      _textPainter.layout(
          minWidth: 0,
          maxWidth:
              rect.width - textPadding >= 0 ? rect.width - textPadding : 0);
      if (_textPainter.maxLines == 1 && _textPainter.height > rect.height) {
        continue;
      }

      _textPainter.paint(
          canvas,
          Offset(
              _isRTL
                  ? rect.right - _textPainter.width - textPadding
                  : rect.left + textPadding,
              rect.top + (rect.height - _textPainter.height) / 2));
      if (_appointment.recurrenceRule != null &&
          _appointment.recurrenceRule.isNotEmpty) {
        double textSize = _calendar.appointmentTextStyle.fontSize;
        if (rect.width < textSize || rect.height < textSize) {
          textSize = rect.width > rect.height ? rect.height : rect.width;
        }

        final TextSpan icon =
            _getRecurrenceIcon(_calendar.appointmentTextStyle.color, textSize);
        _textPainter.text = icon;
        _textPainter.layout(
            minWidth: 0,
            maxWidth:
                rect.width - textPadding >= 0 ? rect.width - textPadding : 0);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(_isRTL ? rect.left : rect.right - textSize,
                    rect.top, _isRTL ? rect.left : rect.right, rect.bottom),
                rect.brRadius),
            _rectPainter);
        _textPainter.paint(
            canvas,
            Offset(_isRTL ? rect.left + 1 : rect.right - textSize - 1,
                rect.top + (rect.height - _textPainter.height) / 2));
      }

      if (_repaintNotifier.value != null &&
          _repaintNotifier.value.appointment != null &&
          _repaintNotifier.value.appointment == _appointmentView.appointment) {
        Decoration _selectionDecoration = _calendar.selectionDecoration;
        _selectionDecoration ??= BoxDecoration(
          color: Colors.transparent,
          border:
              Border.all(color: _calendarTheme.selectionBorderColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(1)),
          shape: BoxShape.rectangle,
        );

        Rect rect = _appointmentView.appointmentRect.outerRect;
        rect = Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom);
        _boxPainter = _selectionDecoration.createBoxPainter();
        _boxPainter.paint(canvas, Offset(rect.left, rect.top),
            ImageConfiguration(size: rect.size));
      }
    }

    if (_isExpandable && maxPosition > _position && !_isExpanding) {
      TextStyle textStyle = _calendar.viewHeaderStyle.dayTextStyle;
      textStyle ??= _calendarTheme.viewHeaderDayTextStyle;
      _textPainter = _textPainter ??
          TextPainter(
              textDirection: TextDirection.ltr,
              maxLines: 1,
              textAlign: TextAlign.left,
              textWidthBasis: TextWidthBasis.longestLine);

      double startXPosition =
          _isRTL ? (size.width - _timeLabelWidth) - cellWidth : _timeLabelWidth;
      double endXPosition =
          _isRTL ? size.width - _timeLabelWidth : _timeLabelWidth + cellWidth;
      final double endYPosition =
          _allDayPainterHeight - _kAllDayAppointmentHeight;
      for (int i = 0; i < _visibleDates.length; i++) {
        int count = 0;
        final int leftPosition = startXPosition.toInt();
        final int rightPosition = endXPosition.toInt();
        for (_AppointmentView view
            in _updateCalendarStateDetails._allDayAppointmentViewCollection) {
          if (view.appointment == null) {
            continue;
          }

          final int rectLeftPosition = view.appointmentRect.left.toInt();
          final int rectRightPosition = view.appointmentRect.right.toInt();
          if (((rectLeftPosition >= leftPosition &&
                      rectLeftPosition < rightPosition) ||
                  (rectRightPosition > leftPosition &&
                      rectRightPosition < rightPosition) ||
                  (rectLeftPosition <= leftPosition &&
                      rectRightPosition > rightPosition)) &&
              view.appointmentRect.top >= endYPosition) {
            count++;
          }
        }

        if (count == 0) {
          if (_isRTL) {
            startXPosition -= cellWidth;
            endXPosition -= cellWidth;
          } else {
            startXPosition += cellWidth;
            endXPosition += cellWidth;
          }
          continue;
        }

        final TextSpan span = TextSpan(
          text: '+ ' + count.toString(),
          style: textStyle,
        );
        _textPainter.text = span;
        _textPainter.layout(
            minWidth: 0,
            maxWidth:
                cellWidth - textPadding >= 0 ? cellWidth - textPadding : 0);

        _textPainter.paint(
            canvas,
            Offset(
                _isRTL
                    ? ((_visibleDates.length - i) * cellWidth) -
                        _textPainter.width -
                        textPadding
                    : _timeLabelWidth + (i * cellWidth) + textPadding,
                endYPosition +
                    ((_kAllDayAppointmentHeight - _textPainter.height) / 2)));
        if (_isRTL) {
          startXPosition -= cellWidth;
          endXPosition -= cellWidth;
        } else {
          startXPosition += cellWidth;
          endXPosition += cellWidth;
        }
      }
    }

    if (_isExpandable) {
      final TextSpan icon = TextSpan(
          text: String.fromCharCode(maxPosition <= _position ? 0xe5ce : 0xe5cf),
          style: TextStyle(
            color: _calendar.viewHeaderStyle != null &&
                    _calendar.viewHeaderStyle.dayTextStyle != null &&
                    _calendar.viewHeaderStyle.dayTextStyle.color != null
                ? _calendar.viewHeaderStyle.dayTextStyle.color
                : _calendarTheme.viewHeaderDayTextStyle.color,
            fontSize: _calendar.viewHeaderStyle != null &&
                    _calendar.viewHeaderStyle.dayTextStyle != null &&
                    _calendar.viewHeaderStyle.dayTextStyle.fontSize != null
                ? _calendar.viewHeaderStyle.dayTextStyle.fontSize * 2
                : _kAllDayAppointmentHeight + 5,
            fontFamily: 'MaterialIcons',
          ));
      _expanderTextPainter ??= TextPainter(
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          maxLines: 1);
      _expanderTextPainter.text = icon;
      _expanderTextPainter.layout(minWidth: 0, maxWidth: _timeLabelWidth);
      _expanderTextPainter.paint(
          canvas,
          Offset(
              _isRTL
                  ? (size.width - _timeLabelWidth) +
                      ((_timeLabelWidth - _expanderTextPainter.width) / 2)
                  : (_timeLabelWidth - _expanderTextPainter.width) / 2,
              _allDayPainterHeight -
                  _kAllDayAppointmentHeight +
                  (_kAllDayAppointmentHeight - _expanderTextPainter.height) /
                      2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _AllDayAppointmentPainter oldWidget = oldDelegate;
    return oldWidget._visibleDates != _visibleDates ||
        oldWidget._allDayPainterHeight != _allDayPainterHeight ||
        oldWidget._visibleAppointment != _visibleAppointment ||
        oldWidget._calendar.cellBorderColor != _calendar.cellBorderColor ||
        oldWidget._calendarTheme != _calendarTheme ||
        oldWidget._isRTL != _isRTL;
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
    final _AllDayAppointmentPainter oldWidget = oldDelegate;
    return oldWidget._visibleDates != _visibleDates ||
        oldWidget._visibleAppointment != _visibleAppointment ||
        oldWidget._allDayPainterHeight != _allDayPainterHeight;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> _semanticsBuilder =
        <CustomPainterSemantics>[];
    double left, top, bottom, right;
    final dynamic _appointmentCollection =
        _updateCalendarStateDetails._allDayAppointmentViewCollection;
    if (_appointmentCollection == null || _appointmentCollection.isEmpty) {
      return _semanticsBuilder;
    }

    if (_isExpandable) {
      left = _isRTL ? size.width - _timeLabelWidth : 0;
      top = _allDayPainterHeight - _kAllDayAppointmentHeight;
      _semanticsBuilder.add(CustomPainterSemantics(
        rect: Rect.fromLTWH(left, top, _isRTL ? size.width : _timeLabelWidth,
            _expanderTextPainter.height),
        properties: SemanticsProperties(
          label:
              maxPosition <= _allDayPainterHeight ~/ _kAllDayAppointmentHeight
                  ? 'Collapse all day section'
                  : 'Expand all day section',
          textDirection: TextDirection.ltr,
        ),
      ));
    }

    if (_isExpandable &&
        maxPosition > (_allDayPainterHeight ~/ _kAllDayAppointmentHeight) &&
        !_isExpanding) {
      left =
          _isRTL ? (size.width - _timeLabelWidth) - cellWidth : _timeLabelWidth;
      right =
          _isRTL ? size.width - _timeLabelWidth : _timeLabelWidth + cellWidth;
      bottom = _allDayPainterHeight - _kAllDayAppointmentHeight;
      top = _allDayPainterHeight - _kAllDayAppointmentHeight;
      for (int i = 0; i < _visibleDates.length; i++) {
        int count = 0;
        final int leftPosition = left.toInt();
        final int rightPosition = right.toInt();
        for (_AppointmentView view
            in _updateCalendarStateDetails._allDayAppointmentViewCollection) {
          if (view.appointment == null) {
            continue;
          }

          final int rectLeftPosition = view.appointmentRect.left.toInt();
          final int rectRightPosition = view.appointmentRect.right.toInt();
          if (((rectLeftPosition >= leftPosition &&
                      rectLeftPosition < rightPosition) ||
                  (rectRightPosition > leftPosition &&
                      rectRightPosition < rightPosition) ||
                  (rectLeftPosition <= leftPosition &&
                      rectRightPosition > rightPosition)) &&
              view.appointmentRect.top >= bottom) {
            count++;
          }
        }

        if (count == 0) {
          if (_isRTL) {
            left -= cellWidth;
            right -= cellWidth;
          } else {
            left += cellWidth;
            right += cellWidth;
          }
          continue;
        }

        _semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(
              _isRTL
                  ? ((_visibleDates.length - i) * cellWidth) - cellWidth
                  : _timeLabelWidth + (i * cellWidth),
              top,
              cellWidth,
              _allDayPainterHeight - top),
          properties: SemanticsProperties(
            label: '+' + count.toString(),
            textDirection: TextDirection.ltr,
          ),
        ));

        if (_isRTL) {
          left -= cellWidth;
          right -= cellWidth;
        } else {
          left += cellWidth;
          right += cellWidth;
        }
      }
    }

    for (int i = 0; i < _appointmentCollection.length; i++) {
      bottom = _allDayPainterHeight - _kAllDayAppointmentHeight;
      if (_appointmentCollection[i].appointment == null ||
          (_appointmentCollection[i].appointmentRect != null &&
              _appointmentCollection[i].appointmentRect.bottom >= bottom &&
              maxPosition >
                  (_allDayPainterHeight ~/ _kAllDayAppointmentHeight))) {
        return _semanticsBuilder;
      }

      _semanticsBuilder.add(CustomPainterSemantics(
        rect: _appointmentCollection[i].appointmentRect == null
            ? const Rect.fromLTWH(0, 0, 10, 10)
            : _appointmentCollection[i].appointmentRect?.outerRect,
        properties: SemanticsProperties(
          label: _getAppointmentText(_appointmentCollection[i].appointment),
          textDirection: TextDirection.ltr,
        ),
      ));
    }

    return _semanticsBuilder;
  }
}
