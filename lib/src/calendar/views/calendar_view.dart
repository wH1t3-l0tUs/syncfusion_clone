part of calendar;

class _CalendarView extends StatefulWidget {
  const _CalendarView(
      this._calendar,
      this._visibleDates,
      this._width,
      this._height,
      this._agendaSelectedDate,
      this._locale,
      this._calendarTheme,
      this._focusNode,
      {Key key,
      this.updateCalendarState})
      : super(key: key);

  final List<DateTime> _visibleDates;
  final SfCalendar _calendar;
  final double _width;
  final SfCalendarThemeData _calendarTheme;
  final double _height;
  final String _locale;
  final ValueNotifier<DateTime> _agendaSelectedDate;
  final _UpdateCalendarState updateCalendarState;
  final FocusNode _focusNode;

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<_CalendarView>
    with TickerProviderStateMixin {
  // line count is the total time slot lines to be drawn in the view
  // line count per view is for time line view which contains the time slot count for per view
  double _horizontalLinesCount;

  //// all day scroll controller is used to identify the scrollposition for draw all day selection.
  ScrollController _scrollController, _timelineViewHeaderScrollController;

  // scroll physics to handle the scrolling for time line view
  ScrollPhysics _scrollPhysics;
  _AppointmentPainter _appointmentPainter;
  AnimationController _timelineViewAnimationController;
  Animation<double> _timelineViewAnimation;
  Tween<double> _timelineViewTween;

  //// timeline header is used to implement the sticky view header in horizontal calendar view mode.
  _TimelineViewHeaderView _timelineViewHeader;
  _SelectionPainter _selectionPainter;
  double _allDayHeight = 0;
  int numberOfDaysInWeek;
  double _timeIntervalHeight;
  _UpdateCalendarStateDetails _updateCalendarStateDetails;
  ValueNotifier<_AppointmentView> _allDaySelectionNotifier;
  bool _isRTL;
  Offset _mouseHoverPosition;

  bool isExpanded = false;
  DateTime _hoveringDate;
  AnimationController _animationController;
  Animation<double> _heightAnimation;
  Animation<double> _allDayExpanderAnimation;
  AnimationController _expanderAnimationController;

  @override
  void initState() {
    isExpanded = false;
    _mouseHoverPosition = null;
    _hoveringDate = DateTime.now();
    _allDaySelectionNotifier = ValueNotifier<_AppointmentView>(null);
    if (!_isTimelineView(widget._calendar.view) &&
        widget._calendar.view != CalendarView.month) {
      _animationController = AnimationController(
          duration: const Duration(milliseconds: 200), vsync: this);
      _heightAnimation =
          CurveTween(curve: Curves.easeIn).animate(_animationController)
            ..addListener(() {
              setState(() {});
            });

      _expanderAnimationController = AnimationController(
          duration: const Duration(milliseconds: 100), vsync: this);
      _allDayExpanderAnimation =
          CurveTween(curve: Curves.easeIn).animate(_expanderAnimationController)
            ..addListener(() {
              setState(() {});
            });
    }

    _updateCalendarStateDetails = _UpdateCalendarStateDetails();
    numberOfDaysInWeek = 7;
    _timeIntervalHeight = _getTimeIntervalHeight(
        widget._calendar,
        widget._width,
        widget._height,
        widget._visibleDates.length,
        _allDayHeight);
    if (widget._calendar.view != CalendarView.month) {
      _horizontalLinesCount =
          _getHorizontalLinesCount(widget._calendar.timeSlotViewSettings);
      _scrollController =
          ScrollController(initialScrollOffset: 0, keepScrollOffset: true)
            ..addListener(_scrollListener);
      if (_isTimelineView(widget._calendar.view)) {
        _scrollPhysics = const NeverScrollableScrollPhysics();
        _timelineViewHeaderScrollController =
            ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
        _timelineViewAnimationController = AnimationController(
            duration: const Duration(milliseconds: 300),
            vsync: this,
            animationBehavior: AnimationBehavior.normal);
        _timelineViewTween = Tween<double>(begin: 0.0, end: 0.1);
        _timelineViewAnimation = _timelineViewTween
            .animate(_timelineViewAnimationController)
              ..addListener(_scrollAnimationListener);
      }
    }

    if (widget._calendar.view != CalendarView.month) {
      _scrollToPosition();
    }

    super.initState();
  }

  void _scrollAnimationListener() {
    _scrollController.jumpTo(_timelineViewAnimation.value);
  }

  void _scrollToPosition() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget._calendar.view == CalendarView.month) {
        return;
      }
      _updateCalendarStateDetails._currentDate = null;
      widget.updateCalendarState(_updateCalendarStateDetails);
      double timeToPosition = 0;
      if (isDateWithInDateRange(
          widget._visibleDates[0],
          widget._visibleDates[widget._visibleDates.length - 1],
          _updateCalendarStateDetails._currentDate)) {
        if (!_isTimelineView(widget._calendar.view)) {
          timeToPosition = _timeToPosition(widget._calendar,
              _updateCalendarStateDetails._currentDate, _timeIntervalHeight);
        } else {
          for (int i = 0; i < widget._visibleDates.length; i++) {
            if (isSameDate(_updateCalendarStateDetails._currentDate,
                widget._visibleDates[i])) {
              timeToPosition = (_getSingleViewWidthForTimeLineView(this) * i) +
                  _timeToPosition(
                      widget._calendar,
                      _updateCalendarStateDetails._currentDate,
                      _timeIntervalHeight);
              break;
            }
          }
        }

        if (timeToPosition > _scrollController.position.maxScrollExtent)
          timeToPosition = _scrollController.position.maxScrollExtent;
        else if (timeToPosition < _scrollController.position.minScrollExtent)
          timeToPosition = _scrollController.position.minScrollExtent;

        _scrollController.jumpTo(timeToPosition);
      }
      _updateCalendarStateDetails._currentDate = null;
    });
  }

  void _expandOrCollapseAllDay() {
    isExpanded = !isExpanded;
    if (isExpanded) {
      _expanderAnimationController.forward();
    } else {
      _expanderAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    if (_isTimelineView(widget._calendar.view) &&
        _timelineViewAnimationController != null)
      _timelineViewAnimationController.dispose();
    if (_scrollController != null) {
      _scrollController.dispose();
    }
    if (_timelineViewHeaderScrollController != null)
      _timelineViewHeaderScrollController.dispose();
    if (_animationController != null) {
      _animationController.dispose();
      _animationController = null;
    }

    if (_expanderAnimationController != null) {
      _expanderAnimationController.dispose();
      _expanderAnimationController = null;
    }

    super.dispose();
  }

  void _scrollListener() {
    if (_isTimelineView(widget._calendar.view)) {
      _updateCalendarStateDetails._selectedDate = null;
      _updateCalendarStateDetails._currentViewVisibleDates = null;
      widget.updateCalendarState(_updateCalendarStateDetails);
      if (_scrollController.position.atEdge &&
          _updateCalendarStateDetails._currentViewVisibleDates ==
              widget._visibleDates) {
        setState(() {
          _scrollPhysics = const NeverScrollableScrollPhysics();
        });
      } else if ((!_scrollController.position.atEdge) &&
          _scrollPhysics.toString() == 'NeverScrollableScrollPhysics' &&
          _updateCalendarStateDetails._currentViewVisibleDates ==
              widget._visibleDates) {
        setState(() {
          _scrollPhysics = const ClampingScrollPhysics();
        });
      }

      if (_timelineViewHeader != null) {
        _timelineViewHeader._repaintNotifier.value =
            !_timelineViewHeader._repaintNotifier.value;
      }

      _timelineViewHeaderScrollController.jumpTo(_scrollController.offset);
    }
  }

  bool _isUpdateTimelineViewScroll(double _initial, double _dx) {
    if (_scrollController.position.maxScrollExtent == 0) {
      return false;
    }

    double _scrollToPosition = 0;

    if (_scrollController.offset < _scrollController.position.maxScrollExtent &&
        _scrollController.offset <=
            _scrollController.position.viewportDimension &&
        (_isRTL ? _initial < _dx : _initial > _dx)) {
      setState(() {
        _scrollPhysics = const ClampingScrollPhysics();
      });

      _scrollToPosition = _isRTL ? _dx - _initial : _initial - _dx;
      _scrollToPosition =
          _scrollToPosition <= _scrollController.position.maxScrollExtent
              ? _scrollToPosition
              : _scrollController.position.maxScrollExtent;

      _scrollController.jumpTo(_scrollToPosition);
      return true;
    } else if (_scrollController.offset >
            _scrollController.position.minScrollExtent &&
        _scrollController.offset != 0 &&
        (_isRTL ? _initial > _dx : _initial < _dx)) {
      setState(() {
        _scrollPhysics = const ClampingScrollPhysics();
      });
      _scrollToPosition = _isRTL
          ? _scrollController.position.maxScrollExtent - (_initial - _dx)
          : _scrollController.position.maxScrollExtent - (_dx - _initial);
      _scrollToPosition =
          _scrollToPosition >= _scrollController.position.minScrollExtent
              ? _scrollToPosition
              : _scrollController.position.minScrollExtent;
      _scrollController.jumpTo(_scrollToPosition);
      return true;
    }

    return false;
  }

  bool _isAnimateTimelineViewScroll(double _position, double _velocity) {
    if (_scrollController.position.maxScrollExtent == 0) {
      return false;
    }

    _velocity =
        _velocity == 0 ? _position.abs() : _velocity / window.devicePixelRatio;
    if (_scrollController.offset < _scrollController.position.maxScrollExtent &&
        _scrollController.offset <=
            _scrollController.position.viewportDimension &&
        (_isRTL ? _position > 0 : _position < 0)) {
      setState(() {
        _scrollPhysics = const ClampingScrollPhysics();
      });

      // animation to animate the scroll view manually in time line view
      _timelineViewTween.begin = _scrollController.offset;
      _timelineViewTween.end =
          _velocity.abs() > _scrollController.position.maxScrollExtent
              ? _scrollController.position.maxScrollExtent
              : _velocity.abs();

      if (_timelineViewAnimationController.isCompleted &&
          _scrollController.offset != _timelineViewTween.end)
        _timelineViewAnimationController.reset();

      _timelineViewAnimationController.forward();
      return true;
    } else if (_scrollController.offset >
            _scrollController.position.minScrollExtent &&
        _scrollController.offset != 0 &&
        (_isRTL ? _position < 0 : _position > 0)) {
      setState(() {
        _scrollPhysics = const ClampingScrollPhysics();
      });

      // animation to animate the scroll view manually in time line view
      _timelineViewTween.begin = _scrollController.offset;
      _timelineViewTween.end =
          _scrollController.position.maxScrollExtent - _velocity.abs() <
                  _scrollController.position.minScrollExtent
              ? _scrollController.position.minScrollExtent
              : _scrollController.position.maxScrollExtent - _velocity.abs();

      if (_timelineViewAnimationController.isCompleted &&
          _scrollController.offset != _timelineViewTween.end)
        _timelineViewAnimationController.reset();

      _timelineViewAnimationController.forward();
      return true;
    }

    return false;
  }

  @override
  void didUpdateWidget(_CalendarView oldWidget) {
    if (widget._calendar.view != CalendarView.month) {
      isExpanded = false;
      _allDaySelectionNotifier = ValueNotifier<_AppointmentView>(null);
      if (!_isTimelineView(widget._calendar.view)) {
        _animationController ??= AnimationController(
            duration: const Duration(milliseconds: 200), vsync: this);
        _heightAnimation ??=
            CurveTween(curve: Curves.easeIn).animate(_animationController)
              ..addListener(() {
                setState(() {});
              });

        _updateCalendarStateDetails = _UpdateCalendarStateDetails();
        _expanderAnimationController ??= AnimationController(
            duration: const Duration(milliseconds: 100), vsync: this);
        _allDayExpanderAnimation ??= CurveTween(curve: Curves.easeIn)
            .animate(_expanderAnimationController)
              ..addListener(() {
                setState(() {});
              });

        if (_expanderAnimationController.status == AnimationStatus.completed) {
          _expanderAnimationController.reset();
        }

        if (widget._calendar.view != CalendarView.day && _allDayHeight == 0) {
          if (_animationController.status == AnimationStatus.completed) {
            _animationController.reset();
          }

          _animationController.forward();
        }
      }

      if (widget._calendar.timeSlotViewSettings.startHour !=
              oldWidget._calendar.timeSlotViewSettings.startHour ||
          widget._calendar.timeSlotViewSettings.endHour !=
              oldWidget._calendar.timeSlotViewSettings.endHour ||
          _getTimeInterval(widget._calendar.timeSlotViewSettings) !=
              _getTimeInterval(oldWidget._calendar.timeSlotViewSettings))
        _horizontalLinesCount =
            _getHorizontalLinesCount(widget._calendar.timeSlotViewSettings);
      else if (oldWidget._calendar.view == CalendarView.month)
        _horizontalLinesCount =
            _getHorizontalLinesCount(widget._calendar.timeSlotViewSettings);
      else
        _horizontalLinesCount = _horizontalLinesCount ??
            _getHorizontalLinesCount(widget._calendar.timeSlotViewSettings);

      _scrollController = _scrollController ??
          ScrollController(initialScrollOffset: 0, keepScrollOffset: true)
        ..addListener(_scrollListener);

      if (_isTimelineView(widget._calendar.view)) {
        _scrollPhysics = const NeverScrollableScrollPhysics();

        _timelineViewAnimationController = _timelineViewAnimationController ??
            AnimationController(
                duration: const Duration(milliseconds: 300),
                vsync: this,
                animationBehavior: AnimationBehavior.normal);
        _timelineViewTween =
            _timelineViewTween ?? Tween<double>(begin: 0.0, end: 0.1);

        _timelineViewAnimation = _timelineViewAnimation ??
            _timelineViewTween.animate(_timelineViewAnimationController)
          ..addListener(_scrollAnimationListener);

        _timelineViewHeaderScrollController =
            _timelineViewHeaderScrollController ??
                ScrollController(
                    initialScrollOffset: 0, keepScrollOffset: true);
      }
    }

    if (oldWidget._calendar.view == CalendarView.month ||
        !_isTimelineView(oldWidget._calendar.view) &&
            _isTimelineView(widget._calendar.view) &&
            widget._calendar.view != CalendarView.month) {
      _scrollToPosition();
    }

    _timeIntervalHeight = _getTimeIntervalHeight(
        widget._calendar,
        widget._width,
        widget._height,
        widget._visibleDates.length,
        _allDayHeight);

    super.didUpdateWidget(oldWidget);
  }

  dynamic _updatePainterProperties(_UpdateCalendarStateDetails details) {
    _updateCalendarStateDetails._allDayAppointmentViewCollection = null;
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    _updateCalendarStateDetails._visibleAppointments = null;
    _updateCalendarStateDetails._selectedDate = null;
    widget.updateCalendarState(_updateCalendarStateDetails);

    details._allDayAppointmentViewCollection =
        _updateCalendarStateDetails._allDayAppointmentViewCollection;
    details._currentViewVisibleDates =
        _updateCalendarStateDetails._currentViewVisibleDates;
    details._visibleAppointments =
        _updateCalendarStateDetails._visibleAppointments;
    details._selectedDate = _updateCalendarStateDetails._selectedDate;
  }

  Widget _addAllDayAppointmentPanel(SfCalendarThemeData _calendarTheme) {
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    _updateCalendarStateDetails._visibleAppointments = null;
    _updateCalendarStateDetails._allDayPanelHeight = null;
    _updateCalendarStateDetails._allDayAppointmentViewCollection = null;
    widget.updateCalendarState(_updateCalendarStateDetails);
    Color borderColor = widget._calendar.cellBorderColor;

    if (borderColor == null) {
      if (_calendarTheme.cellBorderColor == Colors.white70)
        borderColor = Colors.white;
      else if (_calendarTheme.cellBorderColor == Colors.black.withOpacity(0.16))
        borderColor = Colors.grey;
      else
        borderColor = _calendarTheme.cellBorderColor;
    }

    final Material _shadowView = Material(
      color: borderColor.withOpacity(0.5),
      shadowColor: borderColor.withOpacity(0.5),
      elevation: 2.0,
    );

    final double timeLabelWidth = _getTimeLabelWidth(
        widget._calendar.timeSlotViewSettings.timeRulerSize,
        widget._calendar.view);
    double topPosition = _getViewHeaderHeight(
        widget._calendar.viewHeaderHeight, widget._calendar.view);
    if (widget._calendar.view == CalendarView.day) {
      topPosition = _allDayHeight;
    }

    if (_allDayHeight == 0 ||
        widget._visibleDates !=
            _updateCalendarStateDetails._currentViewVisibleDates) {
      return Positioned(
          left: 0, right: 0, top: topPosition, height: 1, child: _shadowView);
    }

    double _leftPosition = timeLabelWidth;
    if (widget._calendar.view == CalendarView.day) {
      //// Default minimum view header width in day view as 50,so set 50
      //// when view header width less than 50.
      _leftPosition = _leftPosition < 50 ? 50 : _leftPosition;
      topPosition = 0;
    }

    double _panelHeight =
        _updateCalendarStateDetails._allDayPanelHeight - _allDayHeight;
    if (_panelHeight < 0) {
      _panelHeight = 0;
    }

    _allDaySelectionNotifier?.value = null;
    final double _alldayExpanderHeight =
        _allDayHeight + (_panelHeight * _allDayExpanderAnimation.value);
    return Positioned(
      left: 0,
      top: topPosition,
      right: 0,
      height: _alldayExpanderHeight,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: isExpanded ? _alldayExpanderHeight : _allDayHeight,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                CustomPaint(
                  painter: _AllDayAppointmentPainter(
                      widget._calendar,
                      widget._visibleDates,
                      widget._visibleDates ==
                              _updateCalendarStateDetails
                                  ._currentViewVisibleDates
                          ? _updateCalendarStateDetails._visibleAppointments
                          : null,
                      timeLabelWidth,
                      _alldayExpanderHeight,
                      _updateCalendarStateDetails._allDayPanelHeight !=
                              _allDayHeight &&
                          (_heightAnimation.value == 1 ||
                              widget._calendar.view == CalendarView.day),
                      _allDayExpanderAnimation.value != 0.0 &&
                          _allDayExpanderAnimation.value != 1,
                      _isRTL,
                      widget._calendarTheme,
                      _allDaySelectionNotifier, updateCalendarState:
                          (_UpdateCalendarStateDetails details) {
                    _updatePainterProperties(details);
                  }),
                  size: Size(widget._width,
                      _updateCalendarStateDetails._allDayPanelHeight),
                ),
              ],
            ),
          ),
          Positioned(
              left: 0,
              top: _alldayExpanderHeight - 1,
              right: 0,
              height: 1,
              child: _shadowView),
        ],
      ),
    );
  }

  _AppointmentPainter _addAppointmentPainter() {
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    _updateCalendarStateDetails._visibleAppointments = null;
    widget.updateCalendarState(_updateCalendarStateDetails);
    _appointmentPainter = _AppointmentPainter(
        widget._calendar,
        widget._visibleDates,
        widget._visibleDates ==
                _updateCalendarStateDetails._currentViewVisibleDates
            ? _updateCalendarStateDetails._visibleAppointments
            : null,
        _timeIntervalHeight,
        ValueNotifier<bool>(false),
        widget._calendarTheme,
        _isRTL, updateCalendarState: (_UpdateCalendarStateDetails details) {
      _updatePainterProperties(details);
    });

    return _appointmentPainter;
  }

  // Returns the month view  as a child for the calendar view.
  Widget _addMonthView(bool _isRTL, String _locale) {
    final double viewHeaderHeight = _getViewHeaderHeight(
        widget._calendar.viewHeaderHeight, widget._calendar.view);
    final double height = widget._height - viewHeaderHeight;
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          height: viewHeaderHeight,
          child: Container(
            color: widget._calendar.viewHeaderStyle.backgroundColor ??
                widget._calendarTheme.viewHeaderBackgroundColor,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _ViewHeaderViewPainter(
                    widget._visibleDates,
                    widget._calendar.view,
                    widget._calendar.viewHeaderStyle,
                    widget._calendar.timeSlotViewSettings,
                    _getTimeLabelWidth(
                        widget._calendar.timeSlotViewSettings.timeRulerSize,
                        widget._calendar.view),
                    _getViewHeaderHeight(widget._calendar.viewHeaderHeight,
                        widget._calendar.view),
                    widget._calendar.monthViewSettings,
                    _isRTL,
                    widget._locale,
                    widget._calendarTheme,
                    widget._calendar.todayHighlightColor ??
                        widget._calendarTheme.todayHighlightColor,
                    widget._calendar.cellBorderColor,
                    widget._calendar.minDate,
                    widget._calendar.maxDate),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: viewHeaderHeight,
          right: 0,
          bottom: 0,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _MonthCellPainter(
                  widget._visibleDates,
                  widget._calendar.monthViewSettings.numberOfWeeksInView,
                  widget._calendar.monthViewSettings.monthCellStyle,
                  _isRTL,
                  widget._calendar.todayHighlightColor ??
                      widget._calendarTheme.todayHighlightColor,
                  widget._calendar.cellBorderColor,
                  widget._calendarTheme,
                  _mouseHoverPosition,
                  widget._calendar.minDate,
                  widget._calendar.maxDate),
              size: Size(widget._width, height),
              foregroundPainter: _addAppointmentPainter(),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: viewHeaderHeight,
          right: 0,
          bottom: 0,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _addSelectionView(),
              size: Size(widget._width, height),
            ),
          ),
        ),
      ],
    );
  }

  // Returns the day view as a child for the calendar view.
  Widget _addDayView(double width, double height, bool _isRTL, String _locale) {
    double viewHeaderWidth = widget._width;
    double viewHeaderHeight = _getViewHeaderHeight(
        widget._calendar.viewHeaderHeight, widget._calendar.view);
    final double timeLabelWidth = _getTimeLabelWidth(
        widget._calendar.timeSlotViewSettings.timeRulerSize,
        widget._calendar.view);
    if (widget._calendar.view == null ||
        widget._calendar.view == CalendarView.day) {
      viewHeaderWidth = timeLabelWidth < 50 ? 50 : timeLabelWidth;
      viewHeaderHeight =
          _allDayHeight > viewHeaderHeight ? _allDayHeight : viewHeaderHeight;
    }

    double _panelHeight =
        _updateCalendarStateDetails._allDayPanelHeight - _allDayHeight;
    if (_panelHeight < 0) {
      _panelHeight = 0;
    }

    final double _alldayExpanderHeight =
        _panelHeight * _allDayExpanderAnimation.value;
    return Stack(
      children: <Widget>[
        _addAllDayAppointmentPanel(widget._calendarTheme),
        Positioned(
          left: _isRTL ? widget._width - viewHeaderWidth : 0,
          top: 0,
          right: _isRTL ? 0 : widget._width - viewHeaderWidth,
          height: _getViewHeaderHeight(
              widget._calendar.viewHeaderHeight, widget._calendar.view),
          child: Container(
            color: widget._calendar.viewHeaderStyle.backgroundColor ??
                widget._calendarTheme.viewHeaderBackgroundColor,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _ViewHeaderViewPainter(
                    widget._visibleDates,
                    widget._calendar.view,
                    widget._calendar.viewHeaderStyle,
                    widget._calendar.timeSlotViewSettings,
                    _getTimeLabelWidth(
                        widget._calendar.timeSlotViewSettings.timeRulerSize,
                        widget._calendar.view),
                    _getViewHeaderHeight(widget._calendar.viewHeaderHeight,
                        widget._calendar.view),
                    widget._calendar.monthViewSettings,
                    _isRTL,
                    widget._locale,
                    widget._calendarTheme,
                    widget._calendar.todayHighlightColor ??
                        widget._calendarTheme.todayHighlightColor,
                    widget._calendar.cellBorderColor,
                    widget._calendar.minDate,
                    widget._calendar.maxDate),
              ),
            ),
          ),
        ),
        _addAllDayAppointmentPanel(widget._calendarTheme),
        Positioned(
          top: (widget._calendar.view == CalendarView.day)
              ? viewHeaderHeight + _alldayExpanderHeight
              : viewHeaderHeight + _allDayHeight + _alldayExpanderHeight,
          left: 0,
          right: 0,
          bottom: 0,
          child: ListView(
              padding: const EdgeInsets.all(0.0),
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              physics: const ClampingScrollPhysics(),
              children: <Widget>[
                Stack(children: <Widget>[
                  RepaintBoundary(
                    child: CustomPaint(
                      painter: _TimeSlotView(
                          widget._visibleDates,
                          _horizontalLinesCount,
                          _timeIntervalHeight,
                          timeLabelWidth,
                          widget._calendar.cellBorderColor,
                          widget._calendarTheme,
                          widget._calendar.timeSlotViewSettings,
                          _isRTL,
                          _mouseHoverPosition),
                      size: Size(width, height),
                      foregroundPainter: _addAppointmentPainter(),
                    ),
                  ),
                  RepaintBoundary(
                    child: CustomPaint(
                      painter: _TimeRulerView(
                          _horizontalLinesCount,
                          _timeIntervalHeight,
                          widget._calendar.timeSlotViewSettings,
                          widget._calendar.cellBorderColor,
                          _isRTL,
                          widget._locale,
                          widget._calendarTheme),
                      size: Size(timeLabelWidth, height),
                    ),
                  ),
                  RepaintBoundary(
                    child: CustomPaint(
                      painter: _addSelectionView(),
                      size: Size(width, height),
                    ),
                  ),
                ])
              ]),
        ),
      ],
    );
  }

  // Returns the timeline view  as a child for the calendar view.
  Widget _addTimelineView(double width, double height, String _locale) {
    return Stack(children: <Widget>[
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: _getViewHeaderHeight(
            widget._calendar.viewHeaderHeight, widget._calendar.view),
        child: Container(
          color: widget._calendar.viewHeaderStyle.backgroundColor ??
              widget._calendarTheme.viewHeaderBackgroundColor,
          child: _getTimelineViewHeader(
              width,
              _getViewHeaderHeight(
                  widget._calendar.viewHeaderHeight, widget._calendar.view),
              widget._locale),
        ),
      ),
      Positioned(
        top: _getViewHeaderHeight(
            widget._calendar.viewHeaderHeight, widget._calendar.view),
        left: 0,
        right: 0,
        bottom: 0,
        child: ListView(
            padding: const EdgeInsets.all(0.0),
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: _scrollPhysics,
            children: <Widget>[
              Stack(children: <Widget>[
                RepaintBoundary(
                  child: CustomPaint(
                    painter: _TimelineView(
                        _horizontalLinesCount,
                        widget._visibleDates,
                        _getTimeLabelWidth(
                            widget._calendar.timeSlotViewSettings.timeRulerSize,
                            widget._calendar.view),
                        widget._calendar.timeSlotViewSettings,
                        _timeIntervalHeight,
                        widget._calendar.cellBorderColor,
                        _isRTL,
                        widget._locale,
                        widget._calendarTheme,
                        _mouseHoverPosition),
                    size: Size(width, height),
                    foregroundPainter: _addAppointmentPainter(),
                  ),
                ),
                RepaintBoundary(
                  child: CustomPaint(
                    painter: _addSelectionView(),
                    size: Size(width, height),
                  ),
                ),
              ]),
            ]),
      ),
    ]);
  }

  void _updateCalendarTapCallback(TapUpDetails details) {
    final double _viewHeaderHeight = _getViewHeaderHeight(
        widget._calendar.viewHeaderHeight, widget._calendar.view);
    if (details.localPosition.dy < _viewHeaderHeight) {
      if (!_isTimelineView(widget._calendar.view) &&
          widget._calendar.view != CalendarView.month) {
        _updateCalendarTapCallbackForCalendarCells(details);
      } else if (_shouldRaiseCalendarTapCallback(widget._calendar.onTap)) {
        _updateCalendarTapCallbackForViewHeader(details, widget._width);
      }
    } else if (details.localPosition.dy > _viewHeaderHeight) {
      _updateCalendarTapCallbackForCalendarCells(details);
    }
  }

  // method to update the selection and raise the calendar tapped call back for calendar cells
  void _updateCalendarTapCallbackForCalendarCells(TapUpDetails details) {
    double xPosition = details.localPosition.dx;
    double yPosition = details.localPosition.dy;
    if (widget._calendar.view != CalendarView.month &&
        !_isTimelineView(widget._calendar.view)) {
      xPosition = details.localPosition.dx;
      yPosition = details.localPosition.dy;
    } else {
      yPosition = details.localPosition.dy -
          _getViewHeaderHeight(
              widget._calendar.viewHeaderHeight, widget._calendar.view);
    }

    if (!widget._focusNode.hasFocus) {
      widget._focusNode.requestFocus();
    }

    _handleTouch(Offset(xPosition, yPosition), details);
  }

  // method to update the calendar tapped call back for the view header view
  void _updateCalendarTapCallbackForViewHeader(
      TapUpDetails details, double _width) {
    int index = 0;
    DateTime selectedDate;
    final double _timeLabelViewWidth = _getTimeLabelWidth(
        widget._calendar.timeSlotViewSettings.timeRulerSize,
        widget._calendar.view);
    if (!_isTimelineView(widget._calendar.view)) {
      double cellWidth = 0;
      if (widget._calendar.view != CalendarView.month) {
        cellWidth =
            (_width - _timeLabelViewWidth) / widget._visibleDates.length;
        index = ((details.localPosition.dx - _timeLabelViewWidth) / cellWidth)
            .truncate();
      } else {
        // 7 represents the number of days in week.
        cellWidth = _width / 7;
        index = (details.localPosition.dx / cellWidth).truncate();
      }

      selectedDate = widget._visibleDates[index];
    } else {
      index = ((_scrollController.offset + details.localPosition.dx) /
              _getSingleViewWidthForTimeLineView(this))
          .truncate();

      selectedDate = widget._visibleDates[index];
    }

    _raiseCalendarTapCallback(widget._calendar,
        date: selectedDate, element: CalendarElement.viewHeader);
  }

  void _updatePointerHover(dynamic event) {
    final RenderBox box = context.findRenderObject();
    final Offset localPosition = box.globalToLocal(event.position);
    final double _viewHeaderHeight = _getViewHeaderHeight(
        widget._calendar.viewHeaderHeight, widget._calendar.view);
    final double _timeLabelWidth = _getTimeLabelWidth(
        widget._calendar.timeSlotViewSettings.timeRulerSize,
        widget._calendar.view);
    final double allDayHeight = widget._calendar.view == CalendarView.day
        ? 0
        : isExpanded
            ? _updateCalendarStateDetails._allDayPanelHeight
            : _allDayHeight;
    double _xPosition;
    double _yPosition;
    if (widget._calendar.view != CalendarView.month &&
        !_isTimelineView(widget._calendar.view)) {
      _xPosition = localPosition.dx - _timeLabelWidth;
      _yPosition = localPosition.dy - (_viewHeaderHeight + allDayHeight);
    } else {
      _xPosition = localPosition.dx;
      if (_isTimelineView(widget._calendar.view)) {
        _xPosition = localPosition.dx + _scrollController.offset;
      }
      _yPosition = localPosition.dy - _viewHeaderHeight;
    }

    if (localPosition.dy < _viewHeaderHeight) {
      return;
    }

    final DateTime _hoverDate =
        _getDateFromPosition(_xPosition, _yPosition, _timeLabelWidth);
    if ((widget._calendar.view == CalendarView.month &&
            isSameDate(_hoveringDate, _hoverDate)) ||
        (widget._calendar.view != CalendarView.month &&
            _isSameTimeSlot(_hoveringDate, _hoverDate))) {
      return;
    }

    _hoveringDate = _hoverDate;

    if (widget._calendar.view == CalendarView.month &&
        (isSameDate(_selectionPainter._selectedDate, _hoveringDate) ||
            !isDateWithInDateRange(widget._calendar.minDate,
                widget._calendar.maxDate, _hoveringDate))) {
      setState(() {
        _mouseHoverPosition = null;
      });
      return;
    } else {
      if (_isSameTimeSlot(_selectionPainter._selectedDate, _hoveringDate)) {
        setState(() {
          _mouseHoverPosition = null;
        });
        return;
      }
    }

    if (widget._calendar.view != CalendarView.month &&
        !_isTimelineView(widget._calendar.view)) {
      _yPosition += _scrollController.offset;
    }

    setState(() {
      _mouseHoverPosition = Offset(_xPosition, _yPosition);
    });
  }

  dynamic _pointerEnterEvent(PointerEnterEvent event) {
    _updatePointerHover(event);
  }

  dynamic _pointerHoverEvent(PointerHoverEvent event) {
    _updatePointerHover(event);
  }

  dynamic _pointerExitEvent(PointerExitEvent event) {
    setState(() {
      _mouseHoverPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isRTL = _isRTLLayout(context);
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    _updateCalendarStateDetails._allDayPanelHeight = null;
    _updateCalendarStateDetails._selectedDate = null;
    _updateCalendarStateDetails._currentDate = null;
    widget.updateCalendarState(_updateCalendarStateDetails);
    if (widget._calendar.view == CalendarView.month) {
      return GestureDetector(
        child: MouseRegion(
          onEnter: _pointerEnterEvent,
          onExit: _pointerExitEvent,
          onHover: _pointerHoverEvent,
          child: _addMonthView(_isRTL, widget._locale),
        ),
        onTapUp: (TapUpDetails details) {
          _updateCalendarTapCallback(details);
        },
      );
    } else if (!_isTimelineView(widget._calendar.view) &&
        widget._calendar.view != CalendarView.month) {
      _allDayHeight = 0;

      if (widget._calendar.view == CalendarView.day) {
        final double viewHeaderHeight = _getViewHeaderHeight(
            widget._calendar.viewHeaderHeight, widget._calendar.view);
        if (widget._visibleDates ==
            _updateCalendarStateDetails._currentViewVisibleDates) {
          _allDayHeight = _kAllDayLayoutHeight > viewHeaderHeight &&
                  _updateCalendarStateDetails._allDayPanelHeight >
                      viewHeaderHeight
              ? _updateCalendarStateDetails._allDayPanelHeight >
                      _kAllDayLayoutHeight
                  ? _kAllDayLayoutHeight
                  : _updateCalendarStateDetails._allDayPanelHeight
              : viewHeaderHeight;
          if (_allDayHeight < _updateCalendarStateDetails._allDayPanelHeight) {
            _allDayHeight += _kAllDayAppointmentHeight;
          }
        } else {
          _allDayHeight = viewHeaderHeight;
        }
      }

      if (widget._calendar.view != CalendarView.day &&
          widget._visibleDates ==
              _updateCalendarStateDetails._currentViewVisibleDates) {
        _allDayHeight = _updateCalendarStateDetails._allDayPanelHeight >
                _kAllDayLayoutHeight
            ? _kAllDayLayoutHeight
            : _updateCalendarStateDetails._allDayPanelHeight;
        _allDayHeight = _allDayHeight * _heightAnimation.value;
      }

      return GestureDetector(
        child: MouseRegion(
          onEnter: _pointerEnterEvent,
          onHover: _pointerHoverEvent,
          onExit: _pointerExitEvent,
          child: _addDayView(
              widget._width,
              _timeIntervalHeight * _horizontalLinesCount,
              _isRTL,
              widget._locale),
        ),
        onTapUp: (TapUpDetails details) {
          _updateCalendarTapCallback(details);
        },
      );
    } else {
      if ((_scrollController.hasClients &&
              !_scrollController.position.atEdge) &&
          _scrollPhysics.toString() == 'NeverScrollableScrollPhysics' &&
          _updateCalendarStateDetails._currentViewVisibleDates ==
              widget._visibleDates) {
        _scrollPhysics = const ClampingScrollPhysics();
      }

      return GestureDetector(
        child: MouseRegion(
          onEnter: _pointerEnterEvent,
          onHover: _pointerHoverEvent,
          onExit: _pointerExitEvent,
          child: _addTimelineView(
              _timeIntervalHeight *
                  (_horizontalLinesCount * widget._visibleDates.length),
              widget._height,
              widget._locale),
        ),
        onTapUp: (TapUpDetails details) {
          _updateCalendarTapCallback(details);
        },
      );
    }
  }

  _AppointmentView _getAppointmentOnPoint(
      List<_AppointmentView> _appointmentCollection, double x, double y) {
    if (_appointmentCollection == null) {
      return null;
    }

    _AppointmentView _appointmentView;
    for (int i = 0; i < _appointmentCollection.length; i++) {
      _appointmentView = _appointmentCollection[i];
      if (_appointmentView.appointment != null &&
          _appointmentView.appointmentRect != null &&
          _appointmentView.appointmentRect.left <= x &&
          _appointmentView.appointmentRect.right >= x &&
          _appointmentView.appointmentRect.top <= y &&
          _appointmentView.appointmentRect.bottom >= y) {
        return _appointmentView;
      }
    }

    return null;
  }

  void _handleTouch(Offset details, TapUpDetails tapUpDetails) {
    _updateCalendarStateDetails._selectedDate = null;
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    _updateCalendarStateDetails._allDayAppointmentViewCollection = null;
    widget.updateCalendarState(_updateCalendarStateDetails);
    dynamic _selectedAppointment;
    List<dynamic> _selectedAppointments;
    DateTime _selectedDate = _updateCalendarStateDetails._selectedDate;
    double _timeLabelWidth = 0;
    //// Day, Week, WorkWeek view touch handling
    if (widget._calendar.view != CalendarView.month &&
        !_isTimelineView(widget._calendar.view)) {
      _timeLabelWidth = _getTimeLabelWidth(
          widget._calendar.timeSlotViewSettings.timeRulerSize,
          widget._calendar.view);
      final double _viewHeaderHeight = widget._calendar.view == CalendarView.day
          ? 0
          : _getViewHeaderHeight(
              widget._calendar.viewHeaderHeight, widget._calendar.view);
      final double allDayHeight = isExpanded
          ? _updateCalendarStateDetails._allDayPanelHeight
          : _allDayHeight;
      if (!_isRTL &&
          details.dx <= _timeLabelWidth &&
          details.dy > _viewHeaderHeight + allDayHeight) {
        return;
      }

      if (_isRTL &&
          details.dx >= widget._width - _timeLabelWidth &&
          details.dy > _viewHeaderHeight + allDayHeight) {
        return;
      }

      if (details.dy < _viewHeaderHeight) {
        if (details.dx > _timeLabelWidth) {
          if (_shouldRaiseCalendarTapCallback(widget._calendar.onTap)) {
            _updateCalendarTapCallbackForViewHeader(
                tapUpDetails, widget._width);
          }

          return;
        } else {
          return;
        }
      } else if (details.dy < _viewHeaderHeight + allDayHeight) {
        if (widget._calendar.view == CalendarView.day &&
            _timeLabelWidth >= details.dx &&
            details.dy <
                _getViewHeaderHeight(
                    widget._calendar.viewHeaderHeight, widget._calendar.view)) {
          if (_shouldRaiseCalendarTapCallback(widget._calendar.onTap)) {
            _updateCalendarTapCallbackForViewHeader(
                tapUpDetails, widget._width);
          }
          return;
        } else if (!_isRTL && _timeLabelWidth >= details.dx) {
          _expandOrCollapseAllDay();
          return;
        } else if (_isRTL && details.dx > widget._width - _timeLabelWidth) {
          _expandOrCollapseAllDay();
          return;
        }

        final double yPosition = details.dy - _viewHeaderHeight;
        final _AppointmentView _appointmentView = _getAppointmentOnPoint(
            _updateCalendarStateDetails._allDayAppointmentViewCollection,
            details.dx,
            yPosition);
        if (_appointmentView != null &&
            (yPosition < allDayHeight - _kAllDayAppointmentHeight ||
                _updateCalendarStateDetails._allDayPanelHeight <=
                    allDayHeight)) {
          if (!isDateWithInDateRange(
                  widget._calendar.minDate,
                  widget._calendar.maxDate,
                  _appointmentView.appointment._actualStartTime) ||
              !isDateWithInDateRange(
                  widget._calendar.minDate,
                  widget._calendar.maxDate,
                  _appointmentView.appointment._actualEndTime)) {
            return;
          }
          if (_selectedDate != null) {
            _selectedDate = null;
            _selectionPainter._selectedDate = _selectedDate;
            _updateCalendarStateDetails._selectedDate = _selectedDate;
            _updateCalendarStateDetails._isAppointmentTapped = true;
          }

          _selectionPainter._appointmentView = null;
          _selectionPainter._repaintNotifier.value =
              !_selectionPainter._repaintNotifier.value;
          _selectedAppointment = _appointmentView.appointment;
          _selectedAppointments = null;
          _allDaySelectionNotifier?.value = _appointmentView;
        } else if (_updateCalendarStateDetails._allDayPanelHeight >
                allDayHeight &&
            yPosition > allDayHeight - _kAllDayAppointmentHeight) {
          _expandOrCollapseAllDay();
          return;
        }
      } else {
        final double yPosition = details.dy -
            _viewHeaderHeight -
            allDayHeight +
            _scrollController.offset;
        final _AppointmentView _appointmentView = _getAppointmentOnPoint(
            _appointmentPainter._appointmentCollection, details.dx, yPosition);
        _allDaySelectionNotifier?.value = null;
        if (_appointmentView == null) {
          if (_isRTL) {
            _drawSelection(details.dx,
                details.dy - _viewHeaderHeight - allDayHeight, _timeLabelWidth);
          } else {
            _drawSelection(details.dx - _timeLabelWidth,
                details.dy - _viewHeaderHeight - allDayHeight, _timeLabelWidth);
          }
        } else {
          if (_selectedDate != null) {
            _selectedDate = null;
            _selectionPainter._selectedDate = _selectedDate;
            _updateCalendarStateDetails._selectedDate = _selectedDate;
            _updateCalendarStateDetails._isAppointmentTapped = true;
          }

          _selectionPainter._appointmentView = _appointmentView;
          _selectionPainter._repaintNotifier.value =
              !_selectionPainter._repaintNotifier.value;
          _selectedAppointment = _appointmentView.appointment;
        }
      }
    } else if (widget._calendar.view == CalendarView.month) {
      //// Month view touch handling
      _drawSelection(details.dx, details.dy, _timeLabelWidth);
    } else {
      //// Timeline view touch handling
      if (details.dy <
          _getTimeLabelWidth(
              widget._calendar.timeSlotViewSettings.timeRulerSize,
              widget._calendar.view)) {
        return;
      }

      final double yPosition = details.dy;
      double xPosition = _scrollController.offset + details.dx;
      if (_isRTL) {
        xPosition = _scrollController.offset +
            (_scrollController.position.viewportDimension - details.dx);
        xPosition = (_scrollController.position.viewportDimension +
                _scrollController.position.maxScrollExtent) -
            xPosition;
      }
      final _AppointmentView _appointmentView = _getAppointmentOnPoint(
          _appointmentPainter._appointmentCollection, xPosition, yPosition);
      if (_appointmentView == null) {
        _drawSelection(
            details.dx,
            details.dy -
                _getViewHeaderHeight(
                    widget._calendar.viewHeaderHeight, widget._calendar.view),
            _timeLabelWidth);
      } else {
        if (_selectedDate != null) {
          _selectedDate = null;
          _selectionPainter._selectedDate = _selectedDate;
          _updateCalendarStateDetails._selectedDate = _selectedDate;
          _updateCalendarStateDetails._isAppointmentTapped = true;
        }

        _selectionPainter._appointmentView = _appointmentView;
        _selectionPainter._repaintNotifier.value =
            !_selectionPainter._repaintNotifier.value;
        _selectedAppointment = _appointmentView.appointment;
      }
    }

    _updateCalendarStateDetails._appointments = null;
    widget.updateCalendarState(_updateCalendarStateDetails);
    if (_shouldRaiseCalendarTapCallback(widget._calendar.onTap)) {
      if (_selectionPainter._selectedDate != null) {
        _selectedAppointments = null;
        if (widget._calendar.view == CalendarView.month &&
            !_isTimelineView(widget._calendar.view)) {
          int rowIndex, columnIndex;
          double cellWidth = 0;
          double cellHeight = 0;
          int index = 0;
          final double _width = widget._width - _timeLabelWidth;
          cellWidth = _width / numberOfDaysInWeek;
          cellHeight = (widget._height -
                  _getViewHeaderHeight(widget._calendar.viewHeaderHeight,
                      widget._calendar.view)) /
              widget._calendar.monthViewSettings.numberOfWeeksInView;
          rowIndex = (details.dx / cellWidth).truncate();
          columnIndex = (details.dy / cellHeight).truncate();
          if (_isRTL) {
            index = (columnIndex * numberOfDaysInWeek) +
                (numberOfDaysInWeek - rowIndex) -
                1;
          } else {
            index = (columnIndex * numberOfDaysInWeek) + rowIndex;
          }
          _selectedDate = widget._visibleDates[index];
          _selectedAppointments = (widget._calendar.dataSource != null &&
                  !_isCalendarAppointment(
                      widget._calendar.dataSource.appointments))
              ? _getCustomAppointments(_getSelectedDateAppointments(
                  _updateCalendarStateDetails._appointments,
                  widget._calendar.timeZone,
                  _selectionPainter._selectedDate))
              : (_getSelectedDateAppointments(
                  _updateCalendarStateDetails._appointments,
                  widget._calendar.timeZone,
                  _selectionPainter._selectedDate));
        } else {
          _selectedDate = _selectionPainter._selectedDate;
        }

        if (!isDateWithInDateRange(widget._calendar.minDate,
            widget._calendar.maxDate, _selectedDate)) {
          return;
        }
        _raiseCalendarTapCallback(widget._calendar,
            date: _selectionPainter._selectedDate,
            appointments: _selectedAppointments,
            element: CalendarElement.calendarCell);
      } else if (_selectedAppointment != null) {
        _selectedAppointments = <dynamic>[
          _selectedAppointment._data ?? _selectedAppointment
        ];
        _raiseCalendarTapCallback(widget._calendar,
            date: _selectedAppointment.startTime,
            appointments: _selectedAppointments,
            element: CalendarElement.appointment);
      }
    }
  }

  DateTime _getDateFromPosition(double x, double y, double _timeLabelWidth) {
    int rowIndex, columnIndex;
    double cellWidth = 0;
    double cellHeight = 0;
    final double _width = widget._width - _timeLabelWidth;
    int index = 0;
    if (widget._calendar.view == CalendarView.month) {
      cellWidth = _width / numberOfDaysInWeek;
      cellHeight = (widget._height -
              _getViewHeaderHeight(
                  widget._calendar.viewHeaderHeight, widget._calendar.view)) /
          widget._calendar.monthViewSettings.numberOfWeeksInView;
      rowIndex = (x / cellWidth).truncate();
      columnIndex = (y / cellHeight).truncate();
      if (_isRTL) {
        index = (columnIndex * numberOfDaysInWeek) +
            (numberOfDaysInWeek - rowIndex) -
            1;
      } else {
        index = (columnIndex * numberOfDaysInWeek) + rowIndex;
      }

      return widget._visibleDates[index];
    } else if (widget._calendar.view == CalendarView.day) {
      if (y >= _timeIntervalHeight * _horizontalLinesCount) {
        return null;
      }
      cellWidth = _width;
      cellHeight = _timeIntervalHeight;
      columnIndex = ((_scrollController.offset + y) / cellHeight).truncate();
      final dynamic time =
          ((_getTimeInterval(widget._calendar.timeSlotViewSettings) / 60) *
                  columnIndex) +
              widget._calendar.timeSlotViewSettings.startHour;
      final int hour = time.toInt();
      final dynamic minute = ((time - hour) * 60).round();
      return DateTime(
          widget._visibleDates[0].year,
          widget._visibleDates[0].month,
          widget._visibleDates[0].day,
          hour,
          minute);
    } else if (widget._calendar.view == CalendarView.workWeek ||
        widget._calendar.view == CalendarView.week) {
      if (y >= _timeIntervalHeight * _horizontalLinesCount) {
        return null;
      }
      cellWidth = _width / widget._visibleDates.length;
      cellHeight = _timeIntervalHeight;
      columnIndex = ((_scrollController.offset + y) / cellHeight).truncate();
      final dynamic time =
          ((_getTimeInterval(widget._calendar.timeSlotViewSettings) / 60) *
                  columnIndex) +
              widget._calendar.timeSlotViewSettings.startHour;
      final int hour = time.toInt();
      final dynamic minute = ((time - hour) * 60).round();
      rowIndex = (x / cellWidth).truncate();
      if (_isRTL) {
        rowIndex = (widget._visibleDates.length - rowIndex) - 1;
      }
      final DateTime date = widget._visibleDates[rowIndex];

      return DateTime(date.year, date.month, date.day, hour, minute);
    } else {
      if (x >=
          _timeIntervalHeight *
              (_horizontalLinesCount * widget._visibleDates.length)) {
        return null;
      }
      cellWidth = _timeIntervalHeight;
      cellHeight = widget._height;
      if (_isRTL) {
        rowIndex = (((_scrollController.offset %
                        _getSingleViewWidthForTimeLineView(this)) +
                    (_scrollController.position.viewportDimension - x)) /
                cellWidth)
            .truncate();
      } else {
        rowIndex = (((_scrollController.offset %
                        _getSingleViewWidthForTimeLineView(this)) +
                    x) /
                cellWidth)
            .truncate();
      }
      columnIndex =
          (_scrollController.offset / _getSingleViewWidthForTimeLineView(this))
              .truncate();
      if (rowIndex >= _horizontalLinesCount) {
        columnIndex += rowIndex ~/ _horizontalLinesCount;
        rowIndex = (rowIndex % _horizontalLinesCount).toInt();
      }
      final dynamic time =
          ((_getTimeInterval(widget._calendar.timeSlotViewSettings) / 60) *
                  rowIndex) +
              widget._calendar.timeSlotViewSettings.startHour;
      final int hour = time.toInt();
      final dynamic minute = ((time - hour) * 60).round();
      if (columnIndex < 0) {
        columnIndex = 0;
      } else if (columnIndex > widget._visibleDates.length) {
        columnIndex = widget._visibleDates.length - 1;
      }

      final DateTime date = widget._visibleDates[columnIndex];

      return DateTime(date.year, date.month, date.day, hour, minute);
    }
  }

  void _drawSelection(double x, double y, double _timeLabelWidth) {
    final DateTime _selectedDate = _getDateFromPosition(x, y, _timeLabelWidth);
    if (_selectedDate == null) {
      return;
    }

    if (widget._calendar.view == CalendarView.month) {
      if (!isDateWithInDateRange(
          widget._calendar.minDate, widget._calendar.maxDate, _selectedDate)) {
        return;
      }

      widget._agendaSelectedDate.value = _selectedDate;
    }

    _updateCalendarStateDetails._selectedDate = _selectedDate;
    _updateCalendarStateDetails._isAppointmentTapped = false;

    _selectionPainter._selectedDate = _selectedDate;
    _selectionPainter._appointmentView = null;
    _selectionPainter._repaintNotifier.value =
        !_selectionPainter._repaintNotifier.value;
  }

  _SelectionPainter _addSelectionView() {
    _updateCalendarStateDetails._selectedDate = null;
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    widget.updateCalendarState(_updateCalendarStateDetails);
    _selectionPainter = _SelectionPainter(
        widget._calendar,
        widget._visibleDates,
        _updateCalendarStateDetails._selectedDate,
        widget._calendar.selectionDecoration,
        _timeIntervalHeight,
        widget._calendarTheme,
        ValueNotifier<bool>(false),
        _isRTL, updateCalendarState: (_UpdateCalendarStateDetails details) {
      _updatePainterProperties(details);
    });

    return _selectionPainter;
  }

  Widget _getTimelineViewHeader(double width, double height, String locale) {
    _timelineViewHeader = _TimelineViewHeaderView(
        widget._visibleDates,
        this,
        ValueNotifier<bool>(false),
        widget._calendar.viewHeaderStyle,
        widget._calendar.timeSlotViewSettings,
        _getViewHeaderHeight(
            widget._calendar.viewHeaderHeight, widget._calendar.view),
        _isRTL,
        widget._calendar.todayHighlightColor ??
            widget._calendarTheme.todayHighlightColor,
        widget._locale,
        widget._calendarTheme,
        widget._calendar.minDate,
        widget._calendar.maxDate);
    return ListView(
        padding: const EdgeInsets.all(0.0),
        controller: _timelineViewHeaderScrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          CustomPaint(
            painter: _timelineViewHeader,
            size: Size(width, height),
          )
        ]);
  }
}
