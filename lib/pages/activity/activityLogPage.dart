import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ActivityLogPage extends StatefulWidget {
  @override
  _ActivityLogPageState createState() => _ActivityLogPageState();
}

class _ActivityLogPageState extends State<ActivityLogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        title: Text("Activity Log"),
      ),
      body: SafeArea(
        child: SfCalendar(
          showDatePickerButton: true,
          showNavigationArrow: true,
          showCurrentTimeIndicator: true,
          viewNavigationMode: ViewNavigationMode.snap,
          allowViewNavigation: true,
          view: CalendarView.schedule,
          dataSource: _getCalendarDataSource(),
          monthViewSettings: MonthViewSettings(
              showAgenda: true,
              agendaItemHeight: 50,
              agendaStyle: AgendaStyle()),
        ),
      ),
    );
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

DataSource _getCalendarDataSource() {
  List<Appointment> appointments = <Appointment>[];
  appointments.add(Appointment(
    startTime: DateTime.now(),
    endTime: DateTime.now().add(Duration(hours: 2)),
    isAllDay: false,
    subject: 'Property Visit',
    color: Colors.blue,
    startTimeZone: '',
    endTimeZone: '',
  ));
  appointments.add(Appointment(
    startTime: DateTime.now().add(Duration(days: 3)),
    endTime: DateTime.now().add(Duration(days: 3)),
    isAllDay: false,
    subject: 'Maintanence work',
    color: Colors.green,
    startTimeZone: '',
    endTimeZone: '',
  ));
  appointments.add(Appointment(
    startTime: DateTime.now(),
    endTime: DateTime.now().add(Duration(hours: 2)),
    isAllDay: true,
    subject: 'Meeting',
    color: Colors.blue,
    startTimeZone: '',
    endTimeZone: '',
  ));
  appointments.add(Appointment(
    startTime: DateTime.now().add(Duration(days: 1)),
    endTime: DateTime.now().add(Duration(hours: 2)),
    isAllDay: true,
    subject: 'Meeting',
    color: Colors.blue,
    startTimeZone: '',
    endTimeZone: '',
  ));

  return DataSource(appointments);
}
