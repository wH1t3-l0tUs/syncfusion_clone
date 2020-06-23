part of calendar;

class _CustomScrollView extends StatefulWidget {
  const _CustomScrollView(
      this._calendar,
      this._width,
      this._height,
      this._visibleAppointments,
      this._agendaSelectedDate,
      this._isRTL,
      this._locale,
      this._calendarTheme,
      {this.updateCalendarState});

  final SfCalendar _calendar;
  final double _width;
  final double _height;
  final bool _isRTL;
  final String _locale;
  final SfCalendarThemeData _calendarTheme;
  final _UpdateCalendarState updateCalendarState;
  final ValueNotifier<DateTime> _agendaSelectedDate;
  final List<dynamic> _visibleAppointments;

  @override
  _CustomScrollViewState createState() => _CustomScrollViewState();
}

class _CustomScrollViewState extends State<_CustomScrollView>
    with TickerProviderStateMixin {
  // three views to arrange the view in vertical/horizontal direction and handle the swiping
  _CalendarView _currentView, _nextView, _previousView;

  // the three children which to be added into the layout
  List<_CalendarView> _children;

  // holds the index of the current displaying view
  int _currentChildIndex;

  // _scrollStartPosition contains the touch movement starting position
  // _position contains distance that the view swiped
  double _scrollStartPosition, _position;

  // animation controller to control the animation
  AnimationController _animationController;

  // animation handled for the view swiping
  Animation<double> _animation;

  // tween animation to handle the animation
  Tween<double> _tween;

  // three visible dates for the three views, the dates will updated based on the swiping in the swipe end
  // _currentViewVisibleDates which stores the visible dates of the current displaying view
  List<DateTime> _visibleDates,
      _previousViewVisibleDates,
      _nextViewVisibleDates,
      _currentViewVisibleDates;

  /// keys maintained to access the data and methods from the calendar view class.
  dynamic _previousViewKey, _currentViewKey, _nextViewKey;

  _UpdateCalendarStateDetails _updateCalendarStateDetails;

  FocusNode _focusNode;

  @override
  void initState() {
    _previousViewKey = GlobalKey<_CalendarViewState>();
    _currentViewKey = GlobalKey<_CalendarViewState>();
    _nextViewKey = GlobalKey<_CalendarViewState>();
    _focusNode = FocusNode();
    if (widget._calendar.controller != null) {
      widget._calendar.controller._forward = widget._isRTL
          ? _moveToPreviousViewWithAnimation
          : _moveToNextViewWithAnimation;
      widget._calendar.controller._backward = widget._isRTL
          ? _moveToNextViewWithAnimation
          : _moveToPreviousViewWithAnimation;
    }

    _updateCalendarStateDetails = _UpdateCalendarStateDetails();
    _currentChildIndex = 1;
    _updateVisibleDates();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 250),
        vsync: this,
        animationBehavior: AnimationBehavior.normal);
    _tween = Tween<double>(begin: 0.0, end: 0.1);
    _animation = _tween.animate(_animationController)
      ..addListener(animationListener);

    super.initState();
  }

  void _updateVisibleDates() {
    _updateCalendarStateDetails._currentDate = null;
    _updateCalendarStateDetails._selectedDate = null;
    widget.updateCalendarState(_updateCalendarStateDetails);
    final DateTime currentDate = _updateCalendarStateDetails._currentDate;
    final DateTime prevDate = _getPreviousViewStartDate(
        widget._calendar.view,
        widget._calendar.monthViewSettings.numberOfWeeksInView,
        _updateCalendarStateDetails._currentDate);
    final DateTime nextDate = _getNextViewStartDate(
        widget._calendar.view,
        widget._calendar.monthViewSettings.numberOfWeeksInView,
        _updateCalendarStateDetails._currentDate);
    final List<int> _nonWorkingDays =
        (widget._calendar.view == CalendarView.workWeek ||
                widget._calendar.view == CalendarView.timelineWorkWeek)
            ? widget._calendar.timeSlotViewSettings.nonWorkingDays
            : null;

    _visibleDates = getVisibleDates(
        currentDate,
        _nonWorkingDays,
        widget._calendar.firstDayOfWeek,
        _getViewDatesCount(
            widget._calendar.view,
            widget._calendar.monthViewSettings.numberOfWeeksInView,
            currentDate));
    _previousViewVisibleDates = getVisibleDates(
        widget._isRTL ? nextDate : prevDate,
        _nonWorkingDays,
        widget._calendar.firstDayOfWeek,
        _getViewDatesCount(widget._calendar.view,
            widget._calendar.monthViewSettings.numberOfWeeksInView, prevDate));
    _nextViewVisibleDates = getVisibleDates(
        widget._isRTL ? prevDate : nextDate,
        _nonWorkingDays,
        widget._calendar.firstDayOfWeek,
        _getViewDatesCount(widget._calendar.view,
            widget._calendar.monthViewSettings.numberOfWeeksInView, nextDate));

    _currentViewVisibleDates = _visibleDates;
    _updateCalendarStateDetails._currentViewVisibleDates =
        _currentViewVisibleDates;
    widget.updateCalendarState(_updateCalendarStateDetails);

    if (_currentChildIndex == 0) {
      _visibleDates = _nextViewVisibleDates;
      _nextViewVisibleDates = _previousViewVisibleDates;
      _previousViewVisibleDates = _currentViewVisibleDates;
    } else if (_currentChildIndex == 1) {
      _visibleDates = _currentViewVisibleDates;
    } else if (_currentChildIndex == 2) {
      _visibleDates = _previousViewVisibleDates;
      _previousViewVisibleDates = _nextViewVisibleDates;
      _nextViewVisibleDates = _currentViewVisibleDates;
    }
  }

  void _updateNextViewVisibleDates() {
    DateTime _currentViewDate = _currentViewVisibleDates[0];
    if (widget._calendar.view == CalendarView.month &&
        widget._calendar.monthViewSettings.numberOfWeeksInView == 6) {
      _currentViewDate = _currentViewVisibleDates[
          (_currentViewVisibleDates.length / 2).truncate()];
    }

    if (widget._isRTL) {
      _currentViewDate = _getPreviousViewStartDate(
          widget._calendar.view,
          widget._calendar.monthViewSettings.numberOfWeeksInView,
          _currentViewDate);
    } else {
      _currentViewDate = _getNextViewStartDate(
          widget._calendar.view,
          widget._calendar.monthViewSettings.numberOfWeeksInView,
          _currentViewDate);
    }

    final List<DateTime> _dates = getVisibleDates(
        _currentViewDate,
        widget._calendar.view == CalendarView.workWeek ||
                widget._calendar.view == CalendarView.timelineWorkWeek
            ? widget._calendar.timeSlotViewSettings.nonWorkingDays
            : null,
        widget._calendar.firstDayOfWeek,
        _getViewDatesCount(
            widget._calendar.view,
            widget._calendar.monthViewSettings.numberOfWeeksInView,
            _currentViewDate));

    if (_currentChildIndex == 0) {
      _nextViewVisibleDates = _dates;
    } else if (_currentChildIndex == 1) {
      _previousViewVisibleDates = _dates;
    } else {
      _visibleDates = _dates;
    }
  }

  void _updatePreviousViewVisibleDates() {
    DateTime _currentViewDate = _currentViewVisibleDates[0];
    if (widget._calendar.view == CalendarView.month &&
        widget._calendar.monthViewSettings.numberOfWeeksInView == 6) {
      _currentViewDate = _currentViewVisibleDates[
          (_currentViewVisibleDates.length / 2).truncate()];
    }

    if (widget._isRTL) {
      _currentViewDate = _getNextViewStartDate(
          widget._calendar.view,
          widget._calendar.monthViewSettings.numberOfWeeksInView,
          _currentViewDate);
    } else {
      _currentViewDate = _getPreviousViewStartDate(
          widget._calendar.view,
          widget._calendar.monthViewSettings.numberOfWeeksInView,
          _currentViewDate);
    }

    final List<DateTime> _dates = getVisibleDates(
        _currentViewDate,
        widget._calendar.view == CalendarView.workWeek ||
                widget._calendar.view == CalendarView.timelineWorkWeek
            ? widget._calendar.timeSlotViewSettings.nonWorkingDays
            : null,
        widget._calendar.firstDayOfWeek,
        _getViewDatesCount(
            widget._calendar.view,
            widget._calendar.monthViewSettings.numberOfWeeksInView,
            _currentViewDate));

    if (_currentChildIndex == 0) {
      _visibleDates = _dates;
    } else if (_currentChildIndex == 1) {
      _nextViewVisibleDates = _dates;
    } else {
      _previousViewVisibleDates = _dates;
    }
  }

  void _updateCalendarViewStateDetails(_UpdateCalendarStateDetails details) {
    details._currentViewVisibleDates = _currentViewVisibleDates;
    details._visibleAppointments = widget._visibleAppointments;
    _updateCalendarStateDetails._currentDate = null;
    _updateCalendarStateDetails._selectedDate = details._selectedDate;
    widget.updateCalendarState(_updateCalendarStateDetails);
    details._currentDate = _updateCalendarStateDetails._currentDate;
    if (details._selectedDate == null && !details._isAppointmentTapped) {
      details._selectedDate = _updateCalendarStateDetails._selectedDate;
    } else if (details._selectedDate != null) {
      _updateCalendarStateDetails._selectedDate = details._selectedDate;
      widget.updateCalendarState(_updateCalendarStateDetails);
    }

    if (details._allDayAppointmentViewCollection == null ||
        details._allDayPanelHeight == null ||
        details._allDayPanelHeight !=
            _updateCalendarStateDetails._allDayPanelHeight ||
        details._allDayAppointmentViewCollection !=
            _updateCalendarStateDetails._allDayAppointmentViewCollection) {
      details._allDayPanelHeight =
          _updateCalendarStateDetails._allDayPanelHeight;
      details._allDayAppointmentViewCollection =
          _updateCalendarStateDetails._allDayAppointmentViewCollection;
    }

    if (details._appointments == null ||
        details._appointments != _updateCalendarStateDetails._appointments) {
      details._appointments = _updateCalendarStateDetails._appointments;
    }
  }

  List<Widget> _addViews() {
    _children = _children ?? <_CalendarView>[];

    if (_children != null && _children.isEmpty) {
      _previousView = _CalendarView(
        widget._calendar,
        _previousViewVisibleDates,
        widget._width,
        widget._height,
        widget._agendaSelectedDate,
        widget._locale,
        widget._calendarTheme,
        _focusNode,
        key: _previousViewKey,
        updateCalendarState: (_UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
      );
      _currentView = _CalendarView(
        widget._calendar,
        _visibleDates,
        widget._width,
        widget._height,
        widget._agendaSelectedDate,
        widget._locale,
        widget._calendarTheme,
        _focusNode,
        key: _currentViewKey,
        updateCalendarState: (_UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
      );
      _nextView = _CalendarView(
        widget._calendar,
        _nextViewVisibleDates,
        widget._width,
        widget._height,
        widget._agendaSelectedDate,
        widget._locale,
        widget._calendarTheme,
        _focusNode,
        key: _nextViewKey,
        updateCalendarState: (_UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
      );

      _children.add(_previousView);
      _children.add(_currentView);
      _children.add(_nextView);
      return _children;
    }

    final dynamic previousView = _updateViews(
        _previousView, _previousViewKey, _previousViewVisibleDates);
    final dynamic currentView =
        _updateViews(_currentView, _currentViewKey, _visibleDates);
    final dynamic nextView =
        _updateViews(_nextView, _nextViewKey, _nextViewVisibleDates);

    //// Update views while the all day view height differ from original height,
    //// else repaint the appointment painter while current child visible appointment not equals calendar visible appointment
    if (_previousView != previousView) {
      _previousView = previousView;
    }
    if (_currentView != currentView) {
      _currentView = currentView;
    }
    if (_nextView != nextView) {
      _nextView = nextView;
    }

    return _children;
  }

  // method to check and update the views and appointments on the swiping end
  _CalendarView _updateViews(_CalendarView view,
      GlobalKey<_CalendarViewState> _viewKey, List<DateTime> _visibleDates) {
    final int index = _children.indexOf(view);
    // update the view with the visible dates on swiping end.
    if (view._visibleDates != _visibleDates) {
      view = _CalendarView(
        widget._calendar,
        _visibleDates,
        widget._width,
        widget._height,
        widget._agendaSelectedDate,
        widget._locale,
        widget._calendarTheme,
        _focusNode,
        key: _viewKey,
        updateCalendarState: (_UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
      );
      _children[index] = view;
    } // check and update the visible appointments in the view
    else if (_viewKey.currentState._appointmentPainter != null &&
        _viewKey.currentState._appointmentPainter._visibleAppointments !=
            widget._visibleAppointments) {
      if (widget._calendar.view != CalendarView.month &&
          !_isTimelineView(widget._calendar.view)) {
        view = _CalendarView(
          widget._calendar,
          _visibleDates,
          widget._width,
          widget._height,
          widget._agendaSelectedDate,
          widget._locale,
          widget._calendarTheme,
          _focusNode,
          key: _viewKey,
          updateCalendarState: (_UpdateCalendarStateDetails details) {
            _updateCalendarViewStateDetails(details);
          },
        );
        _children[index] = view;
      } else if (view._visibleDates == _currentViewVisibleDates) {
        _viewKey.currentState._appointmentPainter._visibleAppointments =
            widget._visibleAppointments;
        _viewKey.currentState._appointmentPainter._calendar = widget._calendar;
        _viewKey.currentState._appointmentPainter._repaintNotifier.value =
            !_viewKey.currentState._appointmentPainter._repaintNotifier.value;
      }
    }

    return view;
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void animationListener() {
    setState(() {
      _position = _animation.value;
    });
  }

  @override
  void didUpdateWidget(_CustomScrollView oldWidget) {
    if (oldWidget._calendar.controller != widget._calendar.controller &&
        widget._calendar.controller != null) {
      widget._calendar.controller._forward = widget._isRTL
          ? _moveToPreviousViewWithAnimation
          : _moveToNextViewWithAnimation;
      widget._calendar.controller._backward = widget._isRTL
          ? _moveToNextViewWithAnimation
          : _moveToPreviousViewWithAnimation;
    }

    if ((widget._calendar.monthViewSettings.navigationDirection !=
            oldWidget._calendar.monthViewSettings.navigationDirection) ||
        widget._width != oldWidget._width ||
        widget._height != oldWidget._height) {
      _position = null;
      _children.clear();
    }

    //// condition to check and update the view when the settings changed, it will check each and every property of settings
    //// to avoid unwanted repainting
    if (oldWidget._calendar.timeSlotViewSettings !=
            widget._calendar.timeSlotViewSettings ||
        oldWidget._calendar.monthViewSettings !=
            widget._calendar.monthViewSettings ||
        oldWidget._calendar.viewHeaderStyle !=
            widget._calendar.viewHeaderStyle ||
        oldWidget._calendar.viewHeaderHeight !=
            widget._calendar.viewHeaderHeight ||
        oldWidget._calendar.todayHighlightColor !=
            widget._calendar.todayHighlightColor ||
        oldWidget._calendar.cellBorderColor !=
            widget._calendar.cellBorderColor ||
        oldWidget._calendarTheme != widget._calendarTheme ||
        oldWidget._locale != widget._locale ||
        oldWidget._calendar.selectionDecoration !=
            widget._calendar.selectionDecoration) {
      _children.clear();
      _position = 0;
    }

    if (widget._calendar.monthViewSettings.numberOfWeeksInView !=
            oldWidget._calendar.monthViewSettings.numberOfWeeksInView ||
        widget._calendar.timeSlotViewSettings.nonWorkingDays !=
            oldWidget._calendar.timeSlotViewSettings.nonWorkingDays ||
        widget._calendar.view != oldWidget._calendar.view ||
        widget._calendar.firstDayOfWeek != oldWidget._calendar.firstDayOfWeek ||
        widget._isRTL != oldWidget._isRTL) {
      _updateVisibleDates();
      _position = 0;
    }

    if ((oldWidget._calendar.minDate != widget._calendar.minDate &&
            widget._calendar.minDate != null) ||
        (oldWidget._calendar.maxDate != widget._calendar.maxDate &&
            widget._calendar.maxDate != null)) {
      _updateVisibleDates();
      _position = 0;
    }

    if (_isTimelineView(widget._calendar.view) !=
        _isTimelineView(oldWidget._calendar.view)) {
      _children.clear();
    }

    /// position set as zero to maintain the existing scroll position in time line view
    if (_isTimelineView(widget._calendar.view) &&
        (oldWidget._calendar.backgroundColor !=
                widget._calendar.backgroundColor ||
            oldWidget._calendar.headerStyle != widget._calendar.headerStyle) &&
        _position != null) {
      _position = 0;
    }

    if (widget._calendar.controller == oldWidget._calendar.controller &&
        widget._calendar.controller != null) {
      if (oldWidget._calendar.controller.displayDate !=
              widget._calendar.controller.displayDate ||
          !isSameDate(_updateCalendarStateDetails._currentDate,
              widget._calendar.controller.displayDate)) {
        _updateCalendarStateDetails._currentDate =
            widget._calendar.controller.displayDate;
        _updateVisibleDates();
        _updateMoveToDate();
        _position = 0;
      }

      if (oldWidget._calendar.controller.selectedDate !=
              widget._calendar.controller.selectedDate ||
          !(isSameDate(_updateCalendarStateDetails._selectedDate,
                  widget._calendar.controller.selectedDate) &&
              _isSameTimeSlot(_updateCalendarStateDetails._selectedDate,
                  widget._calendar.controller.selectedDate))) {
        _updateCalendarStateDetails._selectedDate =
            widget._calendar.controller.selectedDate;
        _updateSelection();
        _position = 0;
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  void _updateSelection() {
    widget.updateCalendarState(_updateCalendarStateDetails);
    final _CalendarViewState previousViewState = _previousViewKey.currentState;
    final _CalendarViewState currentViewState = _currentViewKey.currentState;
    final _CalendarViewState nextViewState = _nextViewKey.currentState;
    previousViewState._allDaySelectionNotifier?.value = null;
    currentViewState._allDaySelectionNotifier?.value = null;
    nextViewState._allDaySelectionNotifier?.value = null;
    previousViewState._selectionPainter._selectedDate =
        _updateCalendarStateDetails._selectedDate;
    nextViewState._selectionPainter._selectedDate =
        _updateCalendarStateDetails._selectedDate;
    currentViewState._selectionPainter._selectedDate =
        _updateCalendarStateDetails._selectedDate;
    previousViewState._selectionPainter._appointmentView = null;
    nextViewState._selectionPainter._appointmentView = null;
    currentViewState._selectionPainter._appointmentView = null;
    previousViewState._selectionPainter._repaintNotifier.value =
        !previousViewState._selectionPainter._repaintNotifier.value;
    currentViewState._selectionPainter._repaintNotifier.value =
        !currentViewState._selectionPainter._repaintNotifier.value;
    nextViewState._selectionPainter._repaintNotifier.value =
        !nextViewState._selectionPainter._repaintNotifier.value;
  }

  void _updateMoveToDate() {
    if (widget._calendar.view != CalendarView.month) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_currentChildIndex == 0) {
          _previousViewKey.currentState._scrollToPosition();
        } else if (_currentChildIndex == 1) {
          _currentViewKey.currentState._scrollToPosition();
        } else if (_currentChildIndex == 2) {
          _nextViewKey.currentState._scrollToPosition();
        }
      });
    }
  }

  /// Updates the current view visible dates for calendar in the swiping end
  void _updateCurrentViewVisibleDates({bool isNextView = false}) {
    if (isNextView) {
      if (_currentChildIndex == 0) {
        _currentViewVisibleDates = _visibleDates;
      } else if (_currentChildIndex == 1) {
        _currentViewVisibleDates = _nextViewVisibleDates;
      } else {
        _currentViewVisibleDates = _previousViewVisibleDates;
      }
    } else {
      if (_currentChildIndex == 0) {
        _currentViewVisibleDates = _nextViewVisibleDates;
      } else if (_currentChildIndex == 1) {
        _currentViewVisibleDates = _previousViewVisibleDates;
      } else {
        _currentViewVisibleDates = _visibleDates;
      }
    }

    _updateCalendarStateDetails._currentViewVisibleDates =
        _currentViewVisibleDates;
    if (widget._calendar.view == CalendarView.month &&
        widget._calendar.monthViewSettings.numberOfWeeksInView == 6) {
      final DateTime currentMonthDate =
          _currentViewVisibleDates[_currentViewVisibleDates.length ~/ 2];
      _updateCalendarStateDetails._currentDate =
          DateTime(currentMonthDate.year, currentMonthDate.month, 01);
    } else {
      _updateCalendarStateDetails._currentDate = _currentViewVisibleDates[0];
    }

    widget.updateCalendarState(_updateCalendarStateDetails);
  }

  dynamic _updateNextView() {
    if (!_animationController.isCompleted) {
      return;
    }

    _updateSelection();
    _updateNextViewVisibleDates();

    if (_currentChildIndex == 0) {
      _currentChildIndex = 1;
    } else if (_currentChildIndex == 1) {
      _currentChildIndex = 2;
    } else if (_currentChildIndex == 2) {
      _currentChildIndex = 0;
    }

    /// set state called to call the build method to fix the date doesn't update
    /// properly issue on web, in Andriod and iOS the build method called
    /// automatically when the animation ends but in web it doesn't work on that
    /// way, hence we have manually called the build method by adding setstate
    /// and i have logged and issue in framework once i got the solution will
    /// remove this setstate
    if (kIsWeb) {
      setState(() {});
    }

    _resetPosition();
    _updateAppointmentPainter();
  }

  dynamic _updatePreviousView() {
    if (!_animationController.isCompleted) {
      return;
    }

    _updateSelection();
    _updatePreviousViewVisibleDates();

    if (_currentChildIndex == 0) {
      _currentChildIndex = 2;
    } else if (_currentChildIndex == 1) {
      _currentChildIndex = 0;
    } else if (_currentChildIndex == 2) {
      _currentChildIndex = 1;
    }

    /// set state called to call the build method to fix the date doesn't update
    /// properly issue on web, in Andriod and iOS the build method called
    /// automatically when the animation ends but in web it doesn't work on that
    /// way, hence we have manually called the build method by adding setstate
    /// and i have logged and issue in framework once i got the solution will
    /// remove this setstate
    if (kIsWeb) {
      setState(() {});
    }
    _resetPosition();
    _updateAppointmentPainter();
  }

  void _moveToNextViewWithAnimation() {
    if (!_canMoveToNextView(
        widget._calendar.view,
        widget._calendar.monthViewSettings.numberOfWeeksInView,
        widget._calendar.maxDate,
        _currentViewVisibleDates,
        widget._calendar.timeSlotViewSettings.nonWorkingDays)) {
      return;
    }

    // Resets the controller to forward it again, the animation will forward only from the dismissed state
    if (_animationController.isCompleted || _animationController.isDismissed) {
      _animationController.reset();
    } else {
      return;
    }

    // Handled for time line view, to move the previous and next view to it's start and end position accordingly
    if (_isTimelineView(widget._calendar.view)) {
      _positionTimelineView();
    }

    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.vertical &&
        widget._calendar.view == CalendarView.month) {
      // update the bottom to top swiping
      _tween.begin = 0;
      _tween.end = -widget._height;
    } else {
      // update the right to left swiping
      _tween.begin = 0;
      _tween.end = -widget._width;
    }

    _animationController.duration = const Duration(milliseconds: 500);
    _animationController
        .forward()
        .then<dynamic>((dynamic value) => _updateNextView());

    /// updates the current view visible dates when the view swiped
    _updateCurrentViewVisibleDates(isNextView: true);
  }

  void _moveToPreviousViewWithAnimation() {
    if (!_canMoveToPreviousView(
        widget._calendar.view,
        widget._calendar.monthViewSettings.numberOfWeeksInView,
        widget._calendar.minDate,
        _currentViewVisibleDates,
        widget._calendar.timeSlotViewSettings.nonWorkingDays)) {
      return;
    }

    // Resets the controller to backward it again, the animation will backward only from the dismissed state
    if (_animationController.isCompleted || _animationController.isDismissed) {
      _animationController.reset();
    } else {
      return;
    }

    // Handled for time line view, to move the previous and next view to it's start and end position accordingly
    if (_isTimelineView(widget._calendar.view)) {
      _positionTimelineView();
    }

    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.vertical &&
        widget._calendar.view == CalendarView.month) {
      // update the top to bottom swiping
      _tween.begin = 0;
      _tween.end = widget._height;
    } else {
      // update the left to right swiping
      _tween.begin = 0;
      _tween.end = widget._width;
    }

    _animationController.duration = const Duration(milliseconds: 500);
    _animationController
        .forward()
        .then<dynamic>((dynamic value) => _updatePreviousView());

    /// updates the current view visible dates when the view swiped.
    _updateCurrentViewVisibleDates();
  }

  // resets position to zero on the swipe end to avoid the unwanted date updates.
  void _resetPosition() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_position.abs() == widget._width ||
          _position.abs() == widget._height) {
        _position = 0;
      }
    });
  }

  void _updateScrollPosition() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_previousView == null ||
          _currentView == null ||
          _nextView == null ||
          _previousViewKey.currentState == null ||
          _currentViewKey.currentState == null ||
          _nextViewKey.currentState == null ||
          _previousViewKey.currentState._scrollController == null ||
          _currentViewKey.currentState._scrollController == null ||
          _nextViewKey.currentState._scrollController == null ||
          !_previousViewKey.currentState._scrollController.hasClients ||
          !_currentViewKey.currentState._scrollController.hasClients ||
          !_nextViewKey.currentState._scrollController.hasClients) {
        return;
      }

      double scrolledPosition = 0;
      if (_currentChildIndex == 0) {
        scrolledPosition =
            _previousViewKey.currentState._scrollController.offset;
      } else if (_currentChildIndex == 1) {
        scrolledPosition =
            _currentViewKey.currentState._scrollController.offset;
      } else if (_currentChildIndex == 2) {
        scrolledPosition = _nextViewKey.currentState._scrollController.offset;
      }

      if (_previousViewKey.currentState._scrollController.offset !=
              scrolledPosition &&
          _previousViewKey
                  .currentState._scrollController.position.maxScrollExtent >=
              scrolledPosition) {
        _previousViewKey.currentState._scrollController
            .jumpTo(scrolledPosition);
      }

      if (_currentViewKey.currentState._scrollController.offset !=
              scrolledPosition &&
          _currentViewKey
                  .currentState._scrollController.position.maxScrollExtent >=
              scrolledPosition) {
        _currentViewKey.currentState._scrollController.jumpTo(scrolledPosition);
      }

      if (_nextViewKey.currentState._scrollController.offset !=
              scrolledPosition &&
          _nextViewKey
                  .currentState._scrollController.position.maxScrollExtent >=
              scrolledPosition) {
        _nextViewKey.currentState._scrollController.jumpTo(scrolledPosition);
      }
    });
  }

  int _getRowOfDate(
      List<DateTime> visibleDates, _CalendarViewState currentViewState) {
    for (int i = 0; i < visibleDates.length; i++) {
      if (isSameDate(
          currentViewState._selectionPainter._selectedDate, visibleDates[i])) {
        if (widget._calendar.view == CalendarView.month) {
          return i ~/ currentViewState.numberOfDaysInWeek;
        } else if (_isTimelineView(widget._calendar.view)) {
          return i;
        }
      }
    }

    return null;
  }

  DateTime _updateSelectedDate(RawKeyEvent event,
      _CalendarViewState currentViewState, _CalendarView currentView) {
    DateTime selectedDate;
    if (event.physicalKey == PhysicalKeyboardKey.arrowRight) {
      if (!_isTimelineView(widget._calendar.view)) {
        if (isSameDate(
            currentView._visibleDates[currentView._visibleDates.length - 1],
            currentViewState._selectionPainter._selectedDate)) {
          _moveToNextViewWithAnimation();
        }

        selectedDate = currentViewState._selectionPainter._selectedDate
            .add(const Duration(days: 1));

        if (widget._calendar.view == CalendarView.workWeek) {
          for (int i = 0;
              i <
                  currentViewState.numberOfDaysInWeek -
                      widget
                          ._calendar.timeSlotViewSettings.nonWorkingDays.length;
              i++) {
            if (widget._calendar.timeSlotViewSettings.nonWorkingDays
                .contains(selectedDate.weekday)) {
              selectedDate = selectedDate.add(const Duration(days: 1));
            } else {
              break;
            }
          }
        }
      } else {
        final double xPosition = _timeToPosition(
            widget._calendar,
            currentViewState._selectionPainter._selectedDate,
            currentViewState._timeIntervalHeight);
        final int rowIndex =
            _getRowOfDate(currentView._visibleDates, currentViewState);
        final double singleChildWidth =
            _getSingleViewWidthForTimeLineView(currentViewState);
        if ((rowIndex * singleChildWidth) +
                xPosition +
                currentViewState._timeIntervalHeight >=
            currentViewState._scrollController.offset + widget._width) {
          currentViewState._scrollController.jumpTo(
              currentViewState._scrollController.offset +
                  currentViewState._timeIntervalHeight);
        }
        if (widget._calendar.view == CalendarView.timelineDay &&
            currentViewState._selectionPainter._selectedDate
                    .add(widget._calendar.timeSlotViewSettings.timeInterval)
                    .day !=
                currentView
                    ._visibleDates[currentView._visibleDates.length - 1].day) {
          _moveToNextViewWithAnimation();
        }

        if ((rowIndex * singleChildWidth) +
                xPosition +
                currentViewState._timeIntervalHeight ==
            currentViewState._scrollController.position.maxScrollExtent +
                currentViewState._scrollController.position.viewportDimension) {
          _moveToNextViewWithAnimation();
        }

        selectedDate = currentViewState._selectionPainter._selectedDate
            .add(widget._calendar.timeSlotViewSettings.timeInterval);
        if (widget._calendar.view == CalendarView.timelineWorkWeek) {
          for (int i = 0;
              i <
                  currentViewState.numberOfDaysInWeek -
                      widget
                          ._calendar.timeSlotViewSettings.nonWorkingDays.length;
              i++) {
            if (widget._calendar.timeSlotViewSettings.nonWorkingDays
                .contains(selectedDate.weekday)) {
              selectedDate = selectedDate.add(const Duration(days: 1));
            } else {
              break;
            }
          }
        }
      }
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowLeft) {
      if (!_isTimelineView(widget._calendar.view)) {
        if (isSameDate(currentViewState.widget._visibleDates[0],
            currentViewState._selectionPainter._selectedDate)) {
          _moveToPreviousViewWithAnimation();
        }
        selectedDate = currentViewState._selectionPainter._selectedDate
            .add(const Duration(days: -1));
        if (widget._calendar.view == CalendarView.workWeek) {
          for (int i = 0;
              i <
                  currentViewState.numberOfDaysInWeek -
                      widget
                          ._calendar.timeSlotViewSettings.nonWorkingDays.length;
              i++) {
            if (widget._calendar.timeSlotViewSettings.nonWorkingDays
                .contains(selectedDate.weekday)) {
              selectedDate = selectedDate.add(const Duration(days: -1));
            } else {
              break;
            }
          }
        }
      } else {
        final double xPosition = _timeToPosition(
            widget._calendar,
            currentViewState._selectionPainter._selectedDate,
            currentViewState._timeIntervalHeight);
        final int rowIndex =
            _getRowOfDate(currentView._visibleDates, currentViewState);
        final double singleChildWidth =
            _getSingleViewWidthForTimeLineView(currentViewState);

        if ((rowIndex * singleChildWidth) + xPosition == 0) {
          _moveToPreviousViewWithAnimation();
        }

        if ((rowIndex * singleChildWidth) + xPosition <=
            currentViewState._scrollController.offset) {
          currentViewState._scrollController.jumpTo(
              currentViewState._scrollController.offset -
                  currentViewState._timeIntervalHeight);
        }

        selectedDate = currentViewState._selectionPainter._selectedDate
            .subtract(widget._calendar.timeSlotViewSettings.timeInterval);
        if (widget._calendar.view == CalendarView.timelineWorkWeek) {
          for (int i = 0;
              i <
                  currentViewState.numberOfDaysInWeek -
                      widget
                          ._calendar.timeSlotViewSettings.nonWorkingDays.length;
              i++) {
            if (widget._calendar.timeSlotViewSettings.nonWorkingDays
                .contains(selectedDate.weekday)) {
              selectedDate = selectedDate.add(const Duration(days: -1));
            } else {
              break;
            }
          }
        }
      }
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowUp) {
      if (widget._calendar.view == CalendarView.month) {
        final int rowIndex =
            _getRowOfDate(currentView._visibleDates, currentViewState);
        if (rowIndex == 0) {
          return currentViewState._selectionPainter._selectedDate;
        }
        return currentViewState._selectionPainter._selectedDate
            .add(const Duration(days: -7));
      } else if (!_isTimelineView(widget._calendar.view)) {
        final double yPosition = _timeToPosition(
            widget._calendar,
            currentViewState._selectionPainter._selectedDate,
            currentViewState._timeIntervalHeight);
        if (yPosition == 0) {
          return currentViewState._selectionPainter._selectedDate;
        }
        if (yPosition <= currentViewState._scrollController.offset) {
          currentViewState._scrollController
              .jumpTo(yPosition - currentViewState._timeIntervalHeight);
        }
        selectedDate = currentViewState._selectionPainter._selectedDate
            .subtract(widget._calendar.timeSlotViewSettings.timeInterval);
      }
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown) {
      if (widget._calendar.view == CalendarView.month) {
        final int rowIndex =
            _getRowOfDate(currentView._visibleDates, currentViewState);
        if (rowIndex ==
            widget._calendar.monthViewSettings.numberOfWeeksInView - 1) {
          return currentViewState._selectionPainter._selectedDate;
        }

        return currentViewState._selectionPainter._selectedDate
            .add(const Duration(days: 7));
      } else if (!_isTimelineView(widget._calendar.view)) {
        final double viewHeaderHeight = _getViewHeaderHeight(
            widget._calendar.viewHeaderHeight, widget._calendar.view);
        final double yPosition = _timeToPosition(
            widget._calendar,
            currentViewState._selectionPainter._selectedDate,
            currentViewState._timeIntervalHeight);

        if (currentViewState._selectionPainter._selectedDate
                .add(widget._calendar.timeSlotViewSettings.timeInterval)
                .day !=
            currentViewState._selectionPainter._selectedDate.day) {
          return currentViewState._selectionPainter._selectedDate;
        }

        if (yPosition +
                    currentViewState._timeIntervalHeight +
                    widget._calendar.headerHeight +
                    viewHeaderHeight >=
                currentViewState._scrollController.offset + widget._height &&
            currentViewState._scrollController.offset +
                    currentViewState
                        ._scrollController.position.viewportDimension !=
                currentViewState._scrollController.position.maxScrollExtent) {
          currentViewState._scrollController.jumpTo(
              currentViewState._scrollController.offset +
                  currentViewState._timeIntervalHeight);
        }
        selectedDate = currentViewState._selectionPainter._selectedDate
            .add(widget._calendar.timeSlotViewSettings.timeInterval);
      }
    }

    return selectedDate;
  }

  dynamic _onKeyDown(RawKeyEvent event) {
    if (event.runtimeType != RawKeyDownEvent) {
      return;
    }

    _CalendarViewState _currentVisibleViewState;
    _CalendarView _currentVisibleView;
    if (_currentChildIndex == 0) {
      _currentVisibleViewState = _previousViewKey.currentState;
      _currentVisibleView = _previousView;
    } else if (_currentChildIndex == 1) {
      _currentVisibleViewState = _currentViewKey.currentState;
      _currentVisibleView = _currentView;
    } else if (_currentChildIndex == 2) {
      _currentVisibleViewState = _nextViewKey.currentState;
      _currentVisibleView = _nextView;
    }

    if (_currentVisibleViewState._selectionPainter._selectedDate != null &&
        isDateWithInDateRange(
            _currentVisibleViewState.widget._visibleDates[0],
            _currentVisibleViewState.widget._visibleDates[
                _currentVisibleViewState.widget._visibleDates.length - 1],
            _currentVisibleViewState._selectionPainter._selectedDate)) {
      final DateTime _selectedDate = _updateSelectedDate(
          event, _currentVisibleViewState, _currentVisibleView);
      if (widget._calendar.view == CalendarView.month) {
        if (!isDateWithInDateRange(widget._calendar.minDate,
            widget._calendar.maxDate, _selectedDate)) {
          return;
        }

        widget._agendaSelectedDate.value = _selectedDate;
      }

      _updateCalendarStateDetails._selectedDate = _selectedDate;
      _updateCalendarStateDetails._isAppointmentTapped = false;

      _currentVisibleViewState._selectionPainter._selectedDate = _selectedDate;
      _currentVisibleViewState._selectionPainter._appointmentView = null;
      _currentVisibleViewState._selectionPainter._repaintNotifier.value =
          !_currentVisibleViewState._selectionPainter._repaintNotifier.value;

      widget.updateCalendarState(_updateCalendarStateDetails);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isTimelineView(widget._calendar.view) &&
        widget._calendar.view != CalendarView.month) {
      _updateScrollPosition();
    }

    double _leftPosition, _rightPosition, _topPosition, _bottomPosition;
    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.horizontal ||
        widget._calendar.view != CalendarView.month) {
      _leftPosition = _leftPosition ?? -widget._width;
      _rightPosition = _rightPosition ?? -widget._width;
      _topPosition = 0;
      _bottomPosition = 0;
    } else {
      _leftPosition = 0;
      _rightPosition = 0;
      _topPosition = _topPosition ?? -widget._height;
      _bottomPosition = _bottomPosition ?? -widget._height;
    }

    final bool _isTimeline = _isTimelineView(widget._calendar.view);
    return Stack(
      children: <Widget>[
        Positioned(
          left: _leftPosition,
          right: _rightPosition,
          bottom: _bottomPosition,
          top: _topPosition,
          child: RawKeyboardListener(
            focusNode: _focusNode,
            onKey: _onKeyDown,
            child: GestureDetector(
              child: CustomScrollViewerLayout(
                  _addViews(),
                  widget._calendar.view != CalendarView.month ||
                          widget._calendar.monthViewSettings
                                  .navigationDirection ==
                              MonthNavigationDirection.horizontal
                      ? CustomScrollDirection.horizontal
                      : CustomScrollDirection.vertical,
                  _position,
                  _currentChildIndex),
              onTapDown: (TapDownDetails details) {
                if (!_focusNode.hasFocus) {
                  _focusNode.requestFocus();
                }
              },
              onHorizontalDragStart: (DragStartDetails details) {
                _onHorizontalStart(details);
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                _onHorizontalUpdate(details);
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                _onHorizontalEnd(details);
              },
              onVerticalDragStart: (DragStartDetails details) {
                if (widget._calendar.view == CalendarView.month && !_isTimeline)
                  _onVerticalStart(details);
              },
              onVerticalDragUpdate: (DragUpdateDetails details) {
                if (widget._calendar.view == CalendarView.month && !_isTimeline)
                  _onVerticalUpdate(details);
              },
              onVerticalDragEnd: (DragEndDetails details) {
                if (widget._calendar.view == CalendarView.month && !_isTimeline)
                  _onVerticalEnd(details);
              },
            ),
          ),
        ),
      ],
    );
  }

  void _positionTimelineView() {
    final _CalendarViewState _previousViewState = _previousViewKey.currentState;
    final _CalendarViewState _currentViewState = _currentViewKey.currentState;
    final _CalendarViewState _nextViewState = _nextViewKey.currentState;
    if (widget._isRTL) {
      if (_currentChildIndex == 0) {
        _currentViewState._scrollController.jumpTo(
            _currentViewState._scrollController.position.maxScrollExtent);
        _nextViewState._scrollController.jumpTo(0);
      } else if (_currentChildIndex == 1) {
        _nextViewState._scrollController
            .jumpTo(_nextViewState._scrollController.position.maxScrollExtent);
        _previousViewState._scrollController.jumpTo(0);
      } else if (_currentChildIndex == 2) {
        _previousViewState._scrollController.jumpTo(
            _previousViewState._scrollController.position.maxScrollExtent);
        _currentViewState._scrollController.jumpTo(0);
      }
    } else {
      if (_currentChildIndex == 0) {
        _nextViewState._scrollController
            .jumpTo(_nextViewState._scrollController.position.maxScrollExtent);
        _currentViewState._scrollController.jumpTo(0);
      } else if (_currentChildIndex == 1) {
        _previousViewState._scrollController.jumpTo(
            _previousViewState._scrollController.position.maxScrollExtent);
        _nextViewState._scrollController.jumpTo(0);
      } else if (_currentChildIndex == 2) {
        _currentViewState._scrollController.jumpTo(
            _currentViewState._scrollController.position.maxScrollExtent);
        _previousViewState._scrollController.jumpTo(0);
      }
    }
  }

  void _onHorizontalStart(DragStartDetails dragStartDetails) {
    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.horizontal ||
        widget._calendar.view != CalendarView.month) {
      _scrollStartPosition = dragStartDetails.globalPosition.dx;
    }

    // Handled for time line view, to move the previous and next view to it's start and end position accordingly
    if (_isTimelineView(widget._calendar.view)) {
      _positionTimelineView();
    }
  }

  void _onHorizontalUpdate(DragUpdateDetails dragUpdateDetails) {
    // Handled for time line view to manually update the scroll position of the scroll view of time line view while pass the touch to the scroll view
    if (_isTimelineView(widget._calendar.view)) {
      _position = dragUpdateDetails.globalPosition.dx - _scrollStartPosition;
      for (int i = 0; i < _children.length; i++) {
        if (_children[i]._visibleDates == _currentViewVisibleDates) {
          final GlobalKey<_CalendarViewState> viewKey = _children[i].key;
          if (viewKey.currentState._isUpdateTimelineViewScroll(
              _scrollStartPosition, dragUpdateDetails.globalPosition.dx))
            return;
          break;
        }
      }
    }

    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.horizontal ||
        widget._calendar.view != CalendarView.month) {
      final double difference =
          dragUpdateDetails.globalPosition.dx - _scrollStartPosition;
      if (difference < 0 &&
          !_canMoveToNextView(
              widget._calendar.view,
              widget._calendar.monthViewSettings.numberOfWeeksInView,
              widget._calendar.maxDate,
              _currentViewVisibleDates,
              widget._calendar.timeSlotViewSettings.nonWorkingDays)) {
        _position = 0;
        return;
      } else if (difference > 0 &&
          !_canMoveToPreviousView(
              widget._calendar.view,
              widget._calendar.monthViewSettings.numberOfWeeksInView,
              widget._calendar.minDate,
              _currentViewVisibleDates,
              widget._calendar.timeSlotViewSettings.nonWorkingDays)) {
        _position = 0;
        return;
      }
      _position = difference;
      _clearSelection();
      setState(() {});
    }
  }

  void _onHorizontalEnd(DragEndDetails dragEndDetails) {
    // Handled for time line view to manually update the scroll position of the scroll view of time line view while pass the touch to the scroll view
    if (_isTimelineView(widget._calendar.view)) {
      for (int i = 0; i < _children.length; i++) {
        if (_children[i]._visibleDates == _currentViewVisibleDates) {
          final GlobalKey<_CalendarViewState> viewKey = _children[i].key;
          if (viewKey.currentState._isAnimateTimelineViewScroll(
              _position, dragEndDetails.primaryVelocity)) {
            return;
          }
          break;
        }
      }
    }

    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.horizontal ||
        widget._calendar.view != CalendarView.month) {
      // condition to check and update the right to left swiping
      if (-_position >= widget._width / 2) {
        _tween.begin = _position;
        _tween.end = -widget._width;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted && _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .forward()
            .then<dynamic>((dynamic value) => _updateNextView());

        /// updates the current view visible dates when the view swiped in
        /// right to left direction
        _updateCurrentViewVisibleDates(isNextView: true);
      }
      // fling the view from right to left
      else if (-dragEndDetails.velocity.pixelsPerSecond.dx > widget._width) {
        if (!_canMoveToNextView(
            widget._calendar.view,
            widget._calendar.monthViewSettings.numberOfWeeksInView,
            widget._calendar.maxDate,
            _currentViewVisibleDates,
            widget._calendar.timeSlotViewSettings.nonWorkingDays)) {
          _position = 0;
          setState(() {});
          return;
        }

        _tween.begin = _position;
        _tween.end = -widget._width;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted && _position != _tween.end)
          _animationController.reset();

        _animationController
            .fling(velocity: 5.0, animationBehavior: AnimationBehavior.normal)
            .then<dynamic>((dynamic value) => _updateNextView());

        /// updates the current view visible dates when fling the view in
        /// right to left direction
        _updateCurrentViewVisibleDates(isNextView: true);
      }
      // condition to check and update the left to right swiping
      else if (_position >= widget._width / 2) {
        _tween.begin = _position;
        _tween.end = widget._width;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .forward()
            .then<dynamic>((dynamic value) => _updatePreviousView());

        /// updates the current view visible dates when the view swiped in
        /// left to right direction
        _updateCurrentViewVisibleDates();
      }
      // fling the view from left to right
      else if (dragEndDetails.velocity.pixelsPerSecond.dx > widget._width) {
        if (!_canMoveToPreviousView(
            widget._calendar.view,
            widget._calendar.monthViewSettings.numberOfWeeksInView,
            widget._calendar.minDate,
            _currentViewVisibleDates,
            widget._calendar.timeSlotViewSettings.nonWorkingDays)) {
          _position = 0;
          setState(() {});
          return;
        }

        _tween.begin = _position;
        _tween.end = widget._width;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted && _position != _tween.end)
          _animationController.reset();

        _animationController
            .fling(velocity: 5.0, animationBehavior: AnimationBehavior.normal)
            .then<dynamic>((dynamic value) => _updatePreviousView());

        /// updates the current view visible dates when fling the view in
        /// left to right direction
        _updateCurrentViewVisibleDates();
      }
      // condition to check and revert the right to left swiping
      else if (_position.abs() <= widget._width / 2) {
        _tween.begin = _position;
        _tween.end = 0.0;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted && _position != _tween.end) {
          _animationController.reset();
        }

        _animationController.forward();
      }
    }
  }

  void _onVerticalStart(DragStartDetails dragStartDetails) {
    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.vertical &&
        !_isTimelineView(widget._calendar.view)) {
      _scrollStartPosition = dragStartDetails.globalPosition.dy;
    }
  }

  void _onVerticalUpdate(DragUpdateDetails dragUpdateDetails) {
    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.vertical &&
        !_isTimelineView(widget._calendar.view)) {
      final double difference =
          dragUpdateDetails.globalPosition.dy - _scrollStartPosition;
      if (difference < 0 &&
          !_canMoveToNextView(
              widget._calendar.view,
              widget._calendar.monthViewSettings.numberOfWeeksInView,
              widget._calendar.maxDate,
              _currentViewVisibleDates,
              widget._calendar.timeSlotViewSettings.nonWorkingDays)) {
        _position = 0;
        return;
      } else if (difference > 0 &&
          !_canMoveToPreviousView(
              widget._calendar.view,
              widget._calendar.monthViewSettings.numberOfWeeksInView,
              widget._calendar.minDate,
              _currentViewVisibleDates,
              widget._calendar.timeSlotViewSettings.nonWorkingDays)) {
        _position = 0;
        return;
      }
      _position = difference;
      setState(() {});
    }
  }

  void _onVerticalEnd(DragEndDetails dragEndDetails) {
    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.vertical &&
        !_isTimelineView(widget._calendar.view)) {
      // condition to check and update the bottom to top swiping
      if (-_position >= widget._height / 2) {
        _tween.begin = _position;
        _tween.end = -widget._height;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .forward()
            .then<dynamic>((dynamic value) => _updateNextView());

        /// updates the current view visible dates when the view swiped in
        /// bottom to top direction
        _updateCurrentViewVisibleDates(isNextView: true);
      }
      // fling the view to bottom to top
      else if (-dragEndDetails.velocity.pixelsPerSecond.dy > widget._height) {
        if (!_canMoveToNextView(
            widget._calendar.view,
            widget._calendar.monthViewSettings.numberOfWeeksInView,
            widget._calendar.maxDate,
            _currentViewVisibleDates,
            widget._calendar.timeSlotViewSettings.nonWorkingDays)) {
          _position = 0;
          setState(() {});
          return;
        }

        _tween.begin = _position;
        _tween.end = -widget._height;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .fling(velocity: 5.0, animationBehavior: AnimationBehavior.normal)
            .then<dynamic>((dynamic value) => _updateNextView());

        /// updates the current view visible dates when fling the view in
        /// bottom to top direction
        _updateCurrentViewVisibleDates(isNextView: true);
      }
      // condition to check and update the top to bottom swiping
      else if (_position >= widget._height / 2) {
        _tween.begin = _position;
        _tween.end = widget._height;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .forward()
            .then<dynamic>((dynamic value) => _updatePreviousView());

        /// updates the current view visible dates when the view swiped in
        /// top to bottom direction
        _updateCurrentViewVisibleDates();
      }
      // fling the view to top to bottom
      else if (dragEndDetails.velocity.pixelsPerSecond.dy > widget._height) {
        if (!_canMoveToPreviousView(
            widget._calendar.view,
            widget._calendar.monthViewSettings.numberOfWeeksInView,
            widget._calendar.minDate,
            _currentViewVisibleDates,
            widget._calendar.timeSlotViewSettings.nonWorkingDays)) {
          _position = 0;
          setState(() {});
          return;
        }

        _tween.begin = _position;
        _tween.end = widget._height;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .fling(velocity: 5.0, animationBehavior: AnimationBehavior.normal)
            .then<dynamic>((dynamic value) => _updatePreviousView());

        /// updates the current view visible dates when fling the view in
        /// top to bottom direction
        _updateCurrentViewVisibleDates();
      }
      // condition to check and revert the bottom to top swiping
      else if (_position.abs() <= widget._height / 2) {
        _tween.begin = _position;
        _tween.end = 0.0;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end)
          _animationController.reset();
        _animationController.forward();
      }
    }
  }

  void _clearSelection() {
    widget.updateCalendarState(_updateCalendarStateDetails);
    for (int i = 0; i < _children.length; i++) {
      final GlobalKey<_CalendarViewState> viewKey = _children[i].key;
      if (viewKey.currentState._selectionPainter._selectedDate !=
          _updateCalendarStateDetails._selectedDate) {
        viewKey.currentState._selectionPainter._selectedDate =
            _updateCalendarStateDetails._selectedDate;
        viewKey.currentState._selectionPainter._repaintNotifier.value =
            !viewKey.currentState._selectionPainter._repaintNotifier.value;
      }
    }
  }

  /// Method to clear the appointments in the previous/next view
  void _updateAppointmentPainter() {
    for (int i = 0; i < _children.length; i++) {
      final GlobalKey<_CalendarViewState> viewKey = _children[i].key;
      viewKey.currentState._appointmentPainter._repaintNotifier.value =
          !viewKey.currentState._appointmentPainter._repaintNotifier.value;
    }
  }
}
