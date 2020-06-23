part of calendar;

class _AgendaViewPainter extends CustomPainter {
  _AgendaViewPainter(
      this._monthViewSettings,
      this._selectedDate,
      this._timeZone,
      this._appointments,
      this._isRTL,
      this._locale,
      this._localizations);

  final MonthViewSettings _monthViewSettings;
  final DateTime _selectedDate;
  final String _timeZone;
  final List<Appointment> _appointments;
  final bool _isRTL;
  final String _locale;
  Paint _rectPainter;
  TextPainter _textPainter;
  List<Appointment> agendaAppointments;
  final SfLocalizations _localizations;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _rectPainter = _rectPainter ?? Paint();
    _rectPainter.isAntiAlias = true;
    double yPosition = 5;
    double xPosition = 5;
    const int padding = 5;
    if (_selectedDate != null) {
      agendaAppointments =
          _getSelectedDateAppointments(_appointments, _timeZone, _selectedDate);
    }

    if (_selectedDate == null ||
        agendaAppointments == null ||
        agendaAppointments.isEmpty) {
      final TextSpan span = TextSpan(
        text: _selectedDate == null
            ? _localizations.noSelectedDateCalendarLabel
            : _localizations.noEventsCalendarLabel,
        style:
            TextStyle(color: Colors.grey, fontSize: 15, fontFamily: 'Roboto'),
      );
      _textPainter = _textPainter ?? TextPainter();
      _textPainter.text = span;
      _textPainter.maxLines = 1;
      _textPainter.textDirection = TextDirection.ltr;
      _textPainter.textAlign = TextAlign.left;
      _textPainter.textWidthBasis = TextWidthBasis.longestLine;

      _textPainter.layout(minWidth: 0, maxWidth: size.width - 10);
      if (_isRTL) {
        xPosition = size.width - _textPainter.width;
      }
      _textPainter.paint(canvas, Offset(xPosition, yPosition + padding));
      return;
    }

    agendaAppointments.sort((Appointment app1, Appointment app2) =>
        app1._actualStartTime.compareTo(app2._actualStartTime));
    agendaAppointments.sort((Appointment app1, Appointment app2) =>
        _orderAppointmentsAscending(app1.isAllDay, app2.isAllDay));
    agendaAppointments.sort((Appointment app1, Appointment app2) =>
        _orderAppointmentsAscending(app1._isSpanned, app2._isSpanned));
    TextStyle appointmentTextStyle =
        _monthViewSettings.agendaStyle.appointmentTextStyle;
    appointmentTextStyle ??=
        TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Roboto');
    //// Draw Appointments
    for (int i = 0; i < agendaAppointments.length; i++) {
      final Appointment _appointment = agendaAppointments[i];
      xPosition = 5;
      _rectPainter.color = _appointment.color;
      final double appointmentHeight = _appointment.isAllDay
          ? _monthViewSettings.agendaItemHeight / 2
          : _monthViewSettings.agendaItemHeight;
      final Rect rect = Rect.fromLTWH(xPosition, yPosition,
          size.width - xPosition - padding, appointmentHeight);
      final Radius cornerRadius = Radius.circular(
          (appointmentHeight * 0.1) > 5 ? 5 : (appointmentHeight * 0.1));
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, cornerRadius), _rectPainter);

      TextSpan span =
          TextSpan(text: _appointment.subject, style: appointmentTextStyle);
      final TextPainter painter = TextPainter(
          text: span,
          maxLines: 1,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          textWidthBasis: TextWidthBasis.longestLine);

      //// Draw Appointments except All day appointment
      if (!_appointment.isAllDay) {
        painter.layout(
            minWidth: 0, maxWidth: size.width - (2 * padding) - xPosition);

        if (_isRTL) {
          xPosition = size.width - painter.width - (3 * padding);
        }

        painter.paint(
            canvas,
            Offset(xPosition + padding,
                yPosition + (appointmentHeight / 2) - painter.height));

        final String format = isSameDate(
                _appointment._actualStartTime, _appointment._actualEndTime)
            ? 'hh:mm a'
            : 'MMM dd, hh:mm a';
        span = TextSpan(
            text: DateFormat(format, _locale)
                    .format(_appointment._actualStartTime) +
                ' - ' +
                DateFormat(format, _locale).format(_appointment._actualEndTime),
            style: appointmentTextStyle);
        painter.text = span;

        painter.layout(
            minWidth: 0, maxWidth: size.width - (2 * padding) - padding);
        if (_isRTL) {
          xPosition = size.width - painter.width - (3 * padding);
        }
        painter.paint(canvas,
            Offset(xPosition + padding, yPosition + (appointmentHeight / 2)));
      } else {
        //// Draw All day appointment
        painter.layout(minWidth: 0, maxWidth: size.width - 10 - padding);
        if (_isRTL) {
          xPosition = size.width - painter.width - (padding * 3);
        }
        painter.paint(
            canvas,
            Offset(xPosition + 5,
                yPosition + ((appointmentHeight - painter.height) / 2)));
      }

      if (_appointment.recurrenceRule != null &&
          _appointment.recurrenceRule.isNotEmpty) {
        double textSize = appointmentTextStyle.fontSize;
        if (rect.width < textSize || rect.height < textSize) {
          textSize = rect.width > rect.height ? rect.height : rect.width;
        }

        final TextSpan icon =
            _getRecurrenceIcon(appointmentTextStyle.color, textSize);
        painter.text = icon;
        painter.layout(
            minWidth: 0, maxWidth: size.width - (2 * padding) - padding);
        if (_isRTL) {
          canvas.drawRRect(
              RRect.fromRectAndRadius(
                  Rect.fromLTRB(8, rect.top, rect.left, rect.bottom),
                  cornerRadius),
              _rectPainter);
        } else {
          canvas.drawRRect(
              RRect.fromRectAndRadius(
                  Rect.fromLTRB(rect.right - textSize - 8, rect.top, rect.right,
                      rect.bottom),
                  cornerRadius),
              _rectPainter);
        }

        // Value 8 added as a right side padding for the recurrence icon in the agenda view
        if (_isRTL) {
          painter.paint(
              canvas, Offset(8, rect.top + (rect.height - painter.height) / 2));
        } else {
          painter.paint(
              canvas,
              Offset(rect.right - textSize - 8,
                  rect.top + (rect.height - painter.height) / 2));
        }
      }

      yPosition += appointmentHeight + padding;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
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
    return true;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> _semanticsBuilder =
        <CustomPainterSemantics>[];
    double _height;
    const double _left = 5.0;
    double _top = 5.0;
    const double _padding = 5.0;
    if (_selectedDate == null) {
      _semanticsBuilder.add(CustomPainterSemantics(
        rect: Offset.zero & size,
        properties: const SemanticsProperties(
          label: 'No selected date',
          textDirection: TextDirection.ltr,
        ),
      ));
    } else if (_selectedDate != null &&
        (agendaAppointments == null || agendaAppointments.isEmpty)) {
      _semanticsBuilder.add(CustomPainterSemantics(
        rect: Offset.zero & size,
        properties: SemanticsProperties(
          label: DateFormat('EEEEE').format(_selectedDate).toString() +
              DateFormat('dd/MMMM/yyyy').format(_selectedDate).toString() +
              ', '
                  'No events',
          textDirection: TextDirection.ltr,
        ),
      ));
    } else if (_selectedDate != null &&
        agendaAppointments != null &&
        agendaAppointments.isNotEmpty) {
      for (int i = 0; i < agendaAppointments.length; i++) {
        _height = agendaAppointments[i].isAllDay
            ? _monthViewSettings.agendaItemHeight / 2
            : _monthViewSettings.agendaItemHeight;
        _semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(
              _left, _top, size.width - _left - _padding, _height),
          properties: SemanticsProperties(
            label: _getAppointmentText(agendaAppointments[i]),
            textDirection: TextDirection.ltr,
          ),
        ));
        _top += _height + _padding;
      }
    }

    return _semanticsBuilder;
  }
}

class _AgendaDateTimePainter extends CustomPainter {
  _AgendaDateTimePainter(this._selectedDate, this._monthViewSettings,
      this._todayHighlightColor, this._locale, this._calendarTheme);

  final DateTime _selectedDate;
  final MonthViewSettings _monthViewSettings;
  final Color _todayHighlightColor;
  final String _locale;
  Paint _linePainter;
  final SfCalendarThemeData _calendarTheme;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _linePainter = _linePainter ?? Paint();
    _linePainter.isAntiAlias = true;
    const double padding = 5;
    if (_selectedDate == null) {
      return;
    }

    final bool isToday = isSameDate(_selectedDate, DateTime.now());
    TextStyle dayTextStyle = _monthViewSettings.agendaStyle.dayTextStyle ??
        _calendarTheme.agendaDayTextStyle;
    TextStyle dateTextStyle = _monthViewSettings.agendaStyle.dateTextStyle ??
        _calendarTheme.agendaDateTextStyle;
    final Color selectedDayTextColor = isToday
        ? _todayHighlightColor ?? _calendarTheme.todayHighlightColor
        : dayTextStyle != null
            ? dayTextStyle.color
            : _calendarTheme.agendaDayTextStyle.color;
    final Color selectedDateTextColor = isToday
        ? _calendarTheme.todayTextStyle.color
        : dateTextStyle != null
            ? dateTextStyle.color
            : _calendarTheme.agendaDateTextStyle;
    dayTextStyle = dayTextStyle.copyWith(color: selectedDayTextColor);
    dateTextStyle = dateTextStyle.copyWith(color: selectedDateTextColor);

    //// Draw Weekday
    TextSpan span = TextSpan(
        text: DateFormat('EEE', _locale)
            .format(_selectedDate)
            .toUpperCase()
            .toString(),
        style: dayTextStyle);
    _textPainter = _textPainter ?? TextPainter();
    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = TextAlign.left;
    _textPainter.textWidthBasis = TextWidthBasis.parent;

    _textPainter.layout(minWidth: 0, maxWidth: size.width);
    _textPainter.paint(
        canvas,
        Offset(
            padding + ((size.width - (2 * padding) - _textPainter.width) / 2),
            padding));

    final double weekDayHeight = padding + _textPainter.height;
    //// Draw Date
    span = TextSpan(text: _selectedDate.day.toString(), style: dateTextStyle);
    _textPainter = _textPainter ?? TextPainter();
    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = TextAlign.left;
    _textPainter.textWidthBasis = TextWidthBasis.parent;

    _textPainter.layout(minWidth: 0, maxWidth: size.width);
    final double xPosition =
        padding + ((size.width - (2 * padding) - _textPainter.width) / 2);
    double yPosition = weekDayHeight;
    if (isToday) {
      yPosition = weekDayHeight + padding;
      _linePainter.color = _todayHighlightColor;
      canvas.drawCircle(
          Offset(xPosition + (_textPainter.width / 2),
              yPosition + (_textPainter.height / 2)),
          _textPainter.width > _textPainter.height
              ? (_textPainter.width / 2) + padding
              : (_textPainter.height / 2) + padding,
          _linePainter);
    }

    _textPainter.paint(canvas, Offset(xPosition, yPosition));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
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
    return true;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> _semanticsBuilder =
        <CustomPainterSemantics>[];
    if (_selectedDate == null) {
      return _semanticsBuilder;
    } else if (_selectedDate != null) {
      _semanticsBuilder.add(CustomPainterSemantics(
        rect: Offset.zero & size,
        properties: SemanticsProperties(
          label: DateFormat('EEEEE').format(_selectedDate).toString() +
              DateFormat('dd/MMMM/yyyy').format(_selectedDate).toString(),
          textDirection: TextDirection.ltr,
        ),
      ));
    }

    return _semanticsBuilder;
  }
}
