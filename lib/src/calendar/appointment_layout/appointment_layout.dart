part of calendar;

class _AppointmentView {
  bool canReuse;
  int startIndex = -1;
  int endIndex = -1;
  Appointment appointment;
  int position = -1;
  int maxPositions = -1;
  bool isSpanned = false;
  RRect appointmentRect;
}

class _AppointmentPainter extends CustomPainter {
  _AppointmentPainter(
      this._calendar,
      this._visibleDates,
      this._visibleAppointments,
      this._timeIntervalHeight,
      this._repaintNotifier,
      this._calendarTheme,
      this._isRTL,
      {this.updateCalendarState})
      : super(repaint: _repaintNotifier);

  // ignore: prefer_final_fields
  SfCalendar _calendar;
  final List<DateTime> _visibleDates;
  final double _timeIntervalHeight;
  final _UpdateCalendarState updateCalendarState;
  final bool _isRTL;
  final SfCalendarThemeData _calendarTheme;

  List<Appointment> _visibleAppointments;
  List<_AppointmentView> _appointmentCollection;
  final ValueNotifier<bool> _repaintNotifier;
  Paint _appointmentPainter;
  TextPainter _textPainter;
  final _UpdateCalendarStateDetails _updateCalendarStateDetails =
      _UpdateCalendarStateDetails();

  @override
  void paint(Canvas canvas, Size size) {
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    _updateCalendarStateDetails._visibleAppointments = null;
    updateCalendarState(_updateCalendarStateDetails);
    _visibleAppointments = _updateCalendarStateDetails._visibleAppointments;
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _appointmentPainter = _appointmentPainter ?? Paint();
    _appointmentPainter.isAntiAlias = true;
    _appointmentCollection = _appointmentCollection ?? <_AppointmentView>[];

    for (int i = 0; i < _appointmentCollection.length; i++) {
      final dynamic obj = _appointmentCollection[i];
      obj.canReuse = true;
      obj.appointment = null;
      obj.position = -1;
      obj.startIndex = -1;
      obj.endIndex = -1;
      obj.appointmentRect = null;
    }

    if (_visibleDates != _updateCalendarStateDetails._currentViewVisibleDates) {
      return;
    }

    if (_calendar.view == CalendarView.month) {
      _drawMonthAppointment(canvas, size, _appointmentPainter);
    } else if (!_isTimelineView(_calendar.view)) {
      _drawDayAppointments(canvas, size, _appointmentPainter);
    } else {
      _drawTimelineAppointments(canvas, size, _appointmentPainter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _AppointmentPainter oldWidget = oldDelegate;
    if (oldWidget._visibleDates != _visibleDates ||
        oldWidget._visibleAppointments != _visibleAppointments ||
        oldWidget._isRTL != _isRTL) {
      return true;
    }

    _appointmentCollection = oldWidget._appointmentCollection;
    return false;
  }

  void _drawMonthAppointment(Canvas canvas, Size size, Paint paint) {
    final double cellWidth = size.width / 7;
    final double cellHeight =
        size.height / _calendar.monthViewSettings.numberOfWeeksInView;
    double xPosition = 0;
    double yPosition = 0;
    if (_calendar.monthViewSettings.appointmentDisplayMode ==
        MonthAppointmentDisplayMode.none) {
      return;
    } else if (_calendar.monthViewSettings.appointmentDisplayMode ==
        MonthAppointmentDisplayMode.appointment) {
      _updateAppointment(this);
      const String text = '31';
      _textPainter = _textPainter ?? TextPainter();
      _textPainter.textDirection = TextDirection.ltr;
      _textPainter.textAlign = TextAlign.center;
      _textPainter.textWidthBasis = TextWidthBasis.longestLine;

      final TextSpan spanText = TextSpan(
        text: text,
        style: _calendar.monthViewSettings.monthCellStyle.textStyle,
      );

      _textPainter.text = spanText;
      //// left and right side padding value 2 subtracted in appointment width
      _textPainter.layout(minWidth: 0, maxWidth: cellWidth - 2);
      final double fontSize =
          _calendar.monthViewSettings.monthCellStyle.todayTextStyle != null
              ? _calendar
                  .monthViewSettings.monthCellStyle.todayTextStyle.fontSize
              : _calendarTheme.todayTextStyle.fontSize;
      //// cell top padding and start position calculated by day view rendering padding and size.
      const double cellTopPadding = 6;
      final double startPosition =
          cellTopPadding + fontSize * 0.6 + fontSize * 0.75;
      final int maximumDisplayCount =
          _calendar.monthViewSettings.appointmentDisplayCount ?? 3;
      final double _appointmentHeight =
          (cellHeight - startPosition) / maximumDisplayCount;
      double textSize = -1;
      for (int i = 0; i < _appointmentCollection.length; i++) {
        final _AppointmentView _appointmentView = _appointmentCollection[i];
        if (_appointmentView.canReuse || _appointmentView.appointment == null) {
          continue;
        }

        final double _appointmentWidth =
            (_appointmentView.endIndex - _appointmentView.startIndex + 1) *
                cellWidth;

        if (_isRTL) {
          xPosition = (6 - (_appointmentView.startIndex % 7)) * cellWidth;
          xPosition -= _appointmentWidth - cellWidth;
        } else {
          xPosition = (_appointmentView.startIndex % 7) * cellWidth;
        }
        yPosition = (_appointmentView.startIndex ~/ 7) * cellHeight;
        if (_appointmentView.position <= maximumDisplayCount) {
          yPosition = yPosition +
              startPosition +
              (_appointmentHeight * (_appointmentView.position - 1));
        } else {
          yPosition = yPosition +
              startPosition +
              (_appointmentHeight * (maximumDisplayCount - 1));
        }

        if (_appointmentView.position == maximumDisplayCount) {
          paint.color = Colors.grey[600];
          const double padding = 2;
          const double startPadding = 5;
          double startXPosition = xPosition + startPadding;
          if (_isRTL) {
            startXPosition = xPosition + (cellWidth - startPadding);
          }
          double radius = _appointmentHeight * 0.12;
          if (radius > 3) {
            radius = 3;
          }

          for (int count = _appointmentView.startIndex;
              count <= _appointmentView.endIndex;
              count++) {
            for (int j = 0; j < 3; j++) {
              canvas.drawCircle(
                  Offset(startXPosition, yPosition + (_appointmentHeight / 2)),
                  radius,
                  paint);
              if (_isRTL) {
                startXPosition -= padding + (2 * radius);
              } else {
                startXPosition += padding + (2 * radius);
              }
            }

            xPosition += cellWidth;
            startXPosition = xPosition + startPadding;
          }
        } else if (_appointmentView.position < maximumDisplayCount) {
          final Appointment _appointment = _appointmentView.appointment;
          paint.color = _appointment.color;

          TextStyle style = _calendar.appointmentTextStyle;
          TextSpan span = TextSpan(text: _appointment.subject, style: style);
          TextPainter painter = TextPainter(
              text: span,
              maxLines: 1,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              textWidthBasis: TextWidthBasis.longestLine);

          if (textSize == -1) {
            for (double j = style.fontSize - 1; j > 0; j--) {
              //// left and right side padding value 2 subtracted in appointment width
              painter.layout(
                  minWidth: 0,
                  maxWidth:
                      _appointmentWidth - 2 > 0 ? _appointmentWidth - 2 : 0);
              if (painter.height >= _appointmentHeight - 1) {
                style = style.copyWith(fontSize: j);
                span = TextSpan(text: _appointment.subject, style: style);
                painter = TextPainter(
                    text: span,
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    textWidthBasis: TextWidthBasis.longestLine);
              } else {
                textSize = j + 1;
                break;
              }
            }
          } else {
            span = TextSpan(
                text: _appointment.subject,
                style: style.copyWith(fontSize: textSize));
            painter = TextPainter(
                text: span,
                maxLines: 1,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                textWidthBasis: TextWidthBasis.longestLine);
          }

          final Radius cornerRadius = Radius.circular(
              (_appointmentHeight * 0.1) > 2 ? 2 : (_appointmentHeight * 0.1));

          // right side padding to add a padding on the right side of the appointment
          // in month view
          const int rightSidePadding = 4;
          RRect rect;
          if (_isRTL) {
            rect = RRect.fromRectAndRadius(
                Rect.fromLTWH(
                    xPosition + rightSidePadding,
                    yPosition,
                    _appointmentWidth - rightSidePadding > 0
                        ? _appointmentWidth - rightSidePadding
                        : 0,
                    _appointmentHeight - 1),
                cornerRadius);
          } else {
            rect = RRect.fromRectAndRadius(
                Rect.fromLTWH(
                    xPosition,
                    yPosition,
                    _appointmentWidth - rightSidePadding > 0
                        ? _appointmentWidth - rightSidePadding
                        : 0,
                    _appointmentHeight - 1),
                cornerRadius);
          }

          _appointmentView.appointmentRect = rect;
          canvas.drawRRect(rect, paint);

          //// left and right side padding value 2 subtracted in appointment width
          painter.layout(
              minWidth: 0,
              maxWidth: _appointmentWidth - rightSidePadding + 1 > 0
                  ? _appointmentWidth - rightSidePadding + 1
                  : 0);
          yPosition =
              yPosition + ((_appointmentHeight - 1 - painter.height) / 2);
          if (_isRTL) {
            xPosition += _appointmentWidth - painter.width - 3;
          }
          painter.paint(canvas, Offset(xPosition + 2, yPosition));

          if (_appointment.recurrenceRule != null &&
              _appointment.recurrenceRule.isNotEmpty) {
            final TextSpan icon = _getRecurrenceIcon(style.color, textSize);
            painter.text = icon;
            painter.layout(
                minWidth: 0,
                maxWidth: _appointmentWidth - rightSidePadding + 1 > 0
                    ? _appointmentWidth - rightSidePadding + 1
                    : 0);
            yPosition = rect.top + ((rect.height - painter.height) / 2);
            canvas.drawRRect(
                RRect.fromRectAndRadius(
                    Rect.fromLTRB(
                        _isRTL ? rect.left : rect.right - textSize,
                        yPosition,
                        _isRTL ? rect.left : rect.right,
                        rect.bottom),
                    cornerRadius),
                paint);
            painter.paint(canvas,
                Offset(_isRTL ? rect.left : rect.right - textSize, yPosition));
          }
        }
      }
    } else {
      const double radius = 2.5;
      const double diameter = radius * 2;
      final double bottomPadding =
          cellHeight * 0.2 < radius ? radius : cellHeight * 0.2;
      for (int i = 0; i < _visibleDates.length; i++) {
        final List<Appointment> appointmentLists =
            _getVisibleSelectedDateAppointments(
                _calendar, _visibleDates[i], _visibleAppointments);
        appointmentLists.sort((Appointment app1, Appointment app2) =>
            app1._actualStartTime.compareTo(app2._actualStartTime));
        appointmentLists.sort((Appointment app1, Appointment app2) =>
            _orderAppointmentsAscending(app1.isAllDay, app2.isAllDay));
        appointmentLists.sort((Appointment app1, Appointment app2) =>
            _orderAppointmentsAscending(app1._isSpanned, app2._isSpanned));
        final int count = appointmentLists.length <=
                _calendar.monthViewSettings.appointmentDisplayCount
            ? appointmentLists.length
            : _calendar.monthViewSettings.appointmentDisplayCount;
        const double indicatorPadding = 2;
        final double indicatorWidth =
            count * diameter + (count - 1) * indicatorPadding;
        if (indicatorWidth > cellWidth) {
          xPosition = indicatorPadding + radius;
        } else {
          final dynamic differnce = cellWidth - indicatorWidth;
          xPosition = (differnce / 2) + radius;
        }

        double startXPosition = 0;
        if (_isRTL) {
          startXPosition = (6 - (i % 7).toInt()) * cellWidth;
        } else {
          startXPosition = ((i % 7).toInt()) * cellWidth;
        }

        xPosition += startXPosition;
        yPosition = (((i / 7) + 1).toInt()) * cellHeight;
        for (int j = 0; j < count; j++) {
          paint.color = appointmentLists[j].color;
          canvas.drawCircle(
              Offset(xPosition, yPosition - bottomPadding), radius, paint);
          xPosition += diameter + indicatorPadding;
          if (startXPosition + cellWidth < xPosition + diameter) {
            break;
          }
        }
      }
    }
  }

  void _drawDayAppointments(Canvas canvas, Size size, Paint paint) {
    final double _timeLabelWidth = _getTimeLabelWidth(
        _calendar.timeSlotViewSettings.timeRulerSize, _calendar.view);
    final double _width = size.width - _timeLabelWidth;
    _setAppointmentPositionAndMaxPosition(
        this, _calendar, _visibleAppointments, false, _timeIntervalHeight);
    final double cellWidth = _width / _visibleDates.length;
    final double cellHeight = _timeIntervalHeight;
    double xPosition = _timeLabelWidth;
    double yPosition = 0;
    const double textPadding = 3;

    for (int i = 0; i < _appointmentCollection.length; i++) {
      final _AppointmentView _appointmentView = _appointmentCollection[i];
      if (_appointmentView.canReuse) {
        continue;
      }

      final Appointment _appointment = _appointmentView.appointment;
      int _column = -1;
      final int count = _visibleDates.length;

      int datesCount = 0;
      for (int j = 0; j < count; j++) {
        final DateTime _date = _visibleDates[j];
        if (_date != null &&
            _date.day == _appointment._actualStartTime.day &&
            _date.month == _appointment._actualStartTime.month &&
            _date.year == _appointment._actualStartTime.year) {
          _column = _isRTL ? _visibleDates.length - 1 - datesCount : datesCount;
          break;
        } else if (_date != null) {
          datesCount++;
        }
      }

      if (_column == -1 ||
          _appointment._isSpanned ||
          (_appointment.endTime.difference(_appointment.startTime).inDays >
              0) ||
          _appointment.isAllDay) {
        continue;
      }

      final int totalHours = _appointment._actualStartTime.hour -
          _calendar.timeSlotViewSettings.startHour.toInt();
      final double mins = _appointment._actualStartTime.minute -
          (_calendar.timeSlotViewSettings.startHour -
              _calendar.timeSlotViewSettings.startHour.toInt());
      final int totalMins = (totalHours * 60 + mins).toInt();
      final dynamic _row =
          totalMins ~/ _getTimeInterval(_calendar.timeSlotViewSettings);

      final double appointmentWidth = cellWidth / _appointmentView.maxPositions;
      if (_isRTL) {
        xPosition = _column * cellWidth +
            (_appointmentView.position * appointmentWidth);
      } else {
        xPosition = _column * cellWidth +
            (_appointmentView.position * appointmentWidth) +
            _timeLabelWidth;
      }

      yPosition = _row * cellHeight;

      Duration difference =
          _appointment._actualEndTime.difference(_appointment._actualStartTime);
      final double minuteHeight =
          cellHeight / _getTimeInterval(_calendar.timeSlotViewSettings);
      yPosition += ((_appointment._actualStartTime.hour * 60 +
                  _appointment._actualStartTime.minute) %
              _getTimeInterval(_calendar.timeSlotViewSettings)) *
          minuteHeight;

      double height = difference.inMinutes * minuteHeight;
      if (_calendar.timeSlotViewSettings.minimumAppointmentDuration != null &&
          _calendar.timeSlotViewSettings.minimumAppointmentDuration.inMinutes >
              0) {
        if (difference <
                _calendar.timeSlotViewSettings.minimumAppointmentDuration &&
            difference.inMinutes * minuteHeight <
                _calendar.timeSlotViewSettings.timeIntervalHeight) {
          difference =
              _calendar.timeSlotViewSettings.minimumAppointmentDuration;
          height = difference.inMinutes * minuteHeight;
          //// Check the minimum appointment duration height does not greater than time interval height.
          if (height > _calendar.timeSlotViewSettings.timeIntervalHeight) {
            height = _calendar.timeSlotViewSettings.timeIntervalHeight;
          }
        }
      }

      final Radius cornerRadius =
          Radius.circular((height * 0.1) > 2 ? 2 : (height * 0.1));
      paint.color = _appointment.color;
      final RRect rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(xPosition, yPosition, appointmentWidth - 1, height - 1),
          cornerRadius);
      _appointmentView.appointmentRect = rect;
      canvas.drawRRect(rect, paint);

      final TextSpan span = TextSpan(
        text: _appointment.subject,
        style: _calendar.appointmentTextStyle,
      );
      final TextPainter painter = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          textWidthBasis: TextWidthBasis.longestLine);

      for (int j = 2; j < 10; j++) {
        painter.maxLines = j;
        //// left and right side padding value 2 subtracted in appointment width
        painter.layout(
            minWidth: 0, maxWidth: appointmentWidth - textPadding - 2);
        if ((painter.height) > height - textPadding - 2) {
          painter.maxLines = j - 1;
          break;
        }
      }

      //// left and right side padding value 2 subtracted in appointment width
      painter.layout(minWidth: 0, maxWidth: appointmentWidth - textPadding - 2);
      if (painter.maxLines == 1 && painter.height > height - textPadding) {
        continue;
      }

      painter.paint(
          canvas,
          Offset(
              _isRTL
                  ? xPosition + appointmentWidth - textPadding - painter.width
                  : xPosition + textPadding,
              yPosition + textPadding));
      if (_appointment.recurrenceRule != null &&
          _appointment.recurrenceRule.isNotEmpty) {
        double textSize = _calendar.appointmentTextStyle.fontSize;
        if (rect.width < textSize || rect.height < textSize) {
          textSize = rect.width > rect.height ? rect.height : rect.width;
        }

        final TextSpan icon =
            _getRecurrenceIcon(_calendar.appointmentTextStyle.color, textSize);
        painter.text = icon;
        painter.layout(
            minWidth: 0, maxWidth: appointmentWidth - textPadding - 2);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(
                    _isRTL
                        ? rect.left + textSize + 1
                        : rect.right - textSize - 1,
                    rect.bottom - 2 - textSize,
                    _isRTL ? rect.left : rect.right,
                    rect.bottom),
                cornerRadius),
            paint);
        painter.paint(
            canvas,
            Offset(_isRTL ? rect.left + 1 : rect.right - textSize - 1,
                rect.bottom - 2 - textSize));
      }
    }
  }

  void _drawTimelineAppointments(Canvas canvas, Size size, Paint paint) {
    _setAppointmentPositionAndMaxPosition(
        this, _calendar, _visibleAppointments, false, _timeIntervalHeight);
    final double viewWidth = size.width / _visibleDates.length;
    final double cellWidth = _timeIntervalHeight;
    double xPosition = 0;
    double yPosition = 0;
    final double topPosition = _getTimeLabelWidth(
        _calendar.timeSlotViewSettings.timeRulerSize, _calendar.view);
    const int textPadding = 3;
    _AppointmentView _appointmentView;
    Appointment _appointment;
    final int count = _visibleDates.length;
    for (int i = 0; i < _appointmentCollection.length; i++) {
      _appointmentView = _appointmentCollection[i];
      if (_appointmentView.canReuse) {
        continue;
      }

      _appointment = _appointmentView.appointment;
      int _column = -1;

      DateTime startTime = _appointment._actualStartTime;
      int datesCount = 0;
      for (int j = 0; j < count; j++) {
        final DateTime _date = _visibleDates[j];
        if (_date != null &&
            _date.day == startTime.day &&
            _date.month == startTime.month &&
            _date.year == startTime.year) {
          _column = _isRTL ? _visibleDates.length - 1 - datesCount : datesCount;
          break;
        } else if (startTime.isBefore(_date)) {
          _column = _isRTL ? _visibleDates.length - 1 - datesCount : datesCount;
          startTime = DateTime(_date.year, _date.month, _date.day, 0, 0, 0);
          break;
        } else if (_date != null) {
          datesCount++;
        }
      }

      if (_column == -1 &&
          _appointment._actualStartTime.isBefore(_visibleDates[0])) {
        _column = 0;
      }

      DateTime endTime = _appointment._actualEndTime;
      int _endColumn = 0;
      if (_calendar.view == CalendarView.timelineWorkWeek) {
        _endColumn = -1;
        datesCount = 0;
        for (int j = 0; j < count; j++) {
          DateTime _date = _visibleDates[j];
          if (_date != null &&
              _date.day == endTime.day &&
              _date.month == endTime.month &&
              _date.year == endTime.year) {
            _endColumn =
                _isRTL ? _visibleDates.length - 1 - datesCount : datesCount;
            break;
          } else if (endTime.isBefore(_date)) {
            _endColumn = _isRTL
                ? _visibleDates.length - 1 - datesCount - 1
                : datesCount - 1;
            if (_endColumn != -1) {
              _date = _visibleDates[_endColumn];
              endTime = DateTime(_date.year, _date.month, _date.day, 59, 59, 0);
            }
            break;
          } else if (_date != null) {
            datesCount++;
          }
        }

        if (_endColumn == -1 &&
            _appointment._actualEndTime
                .isAfter(_visibleDates[_visibleDates.length - 1])) {
          _endColumn = _isRTL ? 0 : _visibleDates.length - 1;
        }
      }

      if (_column == -1 || _endColumn == -1) {
        continue;
      }

      int totalHours =
          startTime.hour - _calendar.timeSlotViewSettings.startHour.toInt();
      double mins = startTime.minute -
          (_calendar.timeSlotViewSettings.startHour -
              _calendar.timeSlotViewSettings.startHour.toInt());
      int totalMins = (totalHours * 60 + mins).toInt();
      int _row = totalMins ~/ _getTimeInterval(_calendar.timeSlotViewSettings);
      if (_isRTL) {
        _row = (_getHorizontalLinesCount(_calendar.timeSlotViewSettings) - _row)
            .toInt();
      }
      final double minuteHeight =
          cellWidth / _getTimeInterval(_calendar.timeSlotViewSettings);

      double appointmentHeight =
          _calendar.timeSlotViewSettings.timelineAppointmentHeight;
      if (appointmentHeight * _appointmentView.maxPositions >
          size.height - topPosition) {
        appointmentHeight =
            (size.height - topPosition) / _appointmentView.maxPositions;
      }

      xPosition = (_column * viewWidth) + (_row * cellWidth);
      yPosition = topPosition + (appointmentHeight * _appointmentView.position);
      xPosition += ((startTime.hour * 60 + startTime.minute) %
              _getTimeInterval(_calendar.timeSlotViewSettings)) *
          minuteHeight;

      paint.color = _appointment.color;
      double width = 0;
      if (_calendar.view == CalendarView.timelineWorkWeek) {
        totalHours =
            endTime.hour - _calendar.timeSlotViewSettings.startHour.toInt();
        mins = endTime.minute -
            (_calendar.timeSlotViewSettings.startHour -
                _calendar.timeSlotViewSettings.startHour.toInt());
        totalMins = (totalHours * 60 + mins).toInt();
        _row = totalMins ~/ _getTimeInterval(_calendar.timeSlotViewSettings);
        if (_isRTL) {
          _row =
              (_getHorizontalLinesCount(_calendar.timeSlotViewSettings) - _row)
                  .toInt();
        }
        final double endXPosition = (_endColumn * viewWidth) +
            (_row * cellWidth) +
            ((endTime.hour * 60 + endTime.minute) %
                    _getTimeInterval(_calendar.timeSlotViewSettings)) *
                minuteHeight;
        if (_isRTL) {
          width = xPosition - endXPosition;
        } else {
          width = endXPosition - xPosition;
        }
      } else {
        final Duration difference = endTime.difference(startTime);
        width = difference.inMinutes * minuteHeight;
      }

      if (_calendar.timeSlotViewSettings.minimumAppointmentDuration != null &&
          _calendar.timeSlotViewSettings.minimumAppointmentDuration.inMinutes >
              0) {
        final double minWidth = _getAppointmentHeightFromDuration(
            _calendar.timeSlotViewSettings.minimumAppointmentDuration,
            _calendar,
            _timeIntervalHeight);
        width = width > minWidth ? width : minWidth;
      }

      final Radius cornerRadius = Radius.circular(
          (appointmentHeight * 0.1) > 2 ? 2 : (appointmentHeight * 0.1));
      final RRect rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(_isRTL ? xPosition - width : xPosition, yPosition,
              width - 1, appointmentHeight - 1),
          cornerRadius);
      _appointmentView.appointmentRect = rect;
      canvas.drawRRect(rect, paint);
      final TextSpan span = TextSpan(
        text: _appointment.subject,
        style: _calendar.appointmentTextStyle,
      );
      final TextPainter painter = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          textWidthBasis: TextWidthBasis.longestLine);

      for (int j = 2; j < 10; j++) {
        painter.maxLines = j;
        //// left and right side padding value 2 subtracted in appointment width
        painter.layout(minWidth: 0, maxWidth: width - textPadding - 2);
        if ((painter.height) > appointmentHeight - textPadding - 2) {
          painter.maxLines = j - 1;
          break;
        }
      }

      //// left and right side padding value 2 subtracted in appointment width
      painter.layout(minWidth: 0, maxWidth: width - textPadding - 2);
      if (painter.maxLines == 1 &&
          painter.height > appointmentHeight - textPadding - 2) {
        continue;
      }

      if (_isRTL) {
        xPosition -= painter.width + textPadding + 2;
      }

      painter.paint(
          canvas, Offset(xPosition + textPadding, yPosition + textPadding));
      if (_appointment.recurrenceRule != null &&
          _appointment.recurrenceRule.isNotEmpty) {
        double textSize = _calendar.appointmentTextStyle.fontSize;
        if (rect.width < textSize || rect.height < textSize) {
          textSize = rect.width > rect.height ? rect.height : rect.width;
        }

        final TextSpan icon =
            _getRecurrenceIcon(_calendar.appointmentTextStyle.color, textSize);
        painter.text = icon;
        painter.layout(minWidth: 0, maxWidth: width - textPadding - 2);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(
                    _isRTL ? rect.left + 1 : rect.right - textSize - 1,
                    rect.bottom - 2 - textSize,
                    _isRTL ? rect.left : rect.right,
                    rect.bottom),
                cornerRadius),
            paint);
        painter.paint(
            canvas,
            Offset(_isRTL ? rect.left + 1 : rect.right - textSize - 1,
                rect.bottom - 2 - textSize));
      }
    }
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
    final _AppointmentPainter oldWidget = oldDelegate;
    return oldWidget._visibleDates != _visibleDates ||
        oldWidget._visibleAppointments != _visibleAppointments;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> _semanticsBuilder =
        <CustomPainterSemantics>[];
    if (_appointmentCollection == null || _appointmentCollection.isEmpty) {
      return _semanticsBuilder;
    }

    for (int i = 0; i < _appointmentCollection.length; i++) {
      if (_appointmentCollection[i].appointment == null) {
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
