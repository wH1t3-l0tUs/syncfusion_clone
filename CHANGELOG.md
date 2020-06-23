## [18.1.42-beta] - 04/01/2020

No changes.

## [18.1.36-beta] - 03/19/2020

**Features**
* Right-to-left direction support.
* Localization support.
* Accessibility support.
* Calendar web support.
* Minimum and maximum date support.
* Theme support.
* Calendar controller for programmatic date selection and date navigation.

## [17.4.51-beta] - 02/25/2020

No changes.

## [17.4.50-beta] - 02/19/2020

No changes.

## [17.4.46-beta] - 01/30/2020

**Features**
* Provided the all-day appointment expander support in day/week/work week views.
* Provided the `appointments` property setter in `CalendarDataSource`.

## [17.4.43-beta] - 01/14/2020

No changes.

## [17.4.40-beta] - 12/18/2019

**Breaking changes**
* Renamed the `dataSource` property as `appointments` in `CalendarDataSource` abstract class.
* The `appointmentMapper` implementation replaced by override methods for custom appointments.
* The `timeZone` package updated to latest version and its database updated.
* The enum properties in `CalendarDataSourceAction` renamed as `add`, `remove` and `reset` instead of `Add`, `Remove` and `Reset`.

## [17.4.39-beta] - 12/17/2019

Initial release.

**Features** 
* Day, week, workweek, timeline day, timeline week, timeline workweek, and month. Seven built-in calendar views.
* Appointment scheduling. Default and custom appointments supported.
* Recursive appointments with daily, weekly, monthly, and yearly recurrence types.
* Time zones support for events and calendar.
* Different nonworking days.
* Different first day of week for all applicable views.
* Flexible start and end hours for time slot views.
* Agenda view support in calendar month view.
* Additional features like customizable calendar appearance and format.
