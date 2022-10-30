import 'package:dio/dio.dart';
import 'package:customer_portal/components/AppDrawer.dart';
import 'package:customer_portal/components/customLoader.dart';
import 'package:customer_portal/pages/dashboard.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderPage extends StatefulWidget {
  @override
  _CalenderPageState createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  List _events = [];
  bool isLoading = false;
  @override
  initState() {
    super.initState();
    getEvents();
  }

  getEvents() async {
    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    //print(_token);
    // return;
    setState(() {
      isLoading = true;
    });
    ApiHelper()
        .dio
        .get(
          "events",
        )
        .then((value) {
      //print(value.data);
      value.data.forEach((e) {
        _events.add(e);
      });
      setState(() {
        // _events = value.data.data;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        centerTitle: false,
        backgroundColor: Colors.white10,
        elevation: 0,
      ),
      drawer: Navigator.canPop(context) ? null : AppDrawer(),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          opacity: 0.3,
          color: Colors.black,
          progressIndicator: CustomLoader(),
          child: Container(
            color: Colors.white10,
            padding: EdgeInsets.only(top: 5),
            child: SfCalendar(
              backgroundColor: Colors.white10,
              view: CalendarView.month,
              showDatePickerButton: true,
              cellBorderColor: Colors.transparent,
              allowViewNavigation: true,
              headerStyle: CalendarHeaderStyle(
                textStyle: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                ),
              ),
              todayHighlightColor: accent,

              // allowedViews: [
              //   CalendarView.month,
              //   // CalendarView.schedule,
              // ],
              dataSource: _getCalendarDataSource(_events),

              monthViewSettings: MonthViewSettings(
                showAgenda: true,
                agendaItemHeight: 50,
                agendaStyle: AgendaStyle(),
                // agendaViewHeight: 100,
              ),
              showCurrentTimeIndicator: true,
              headerDateFormat: "MMM y",
            ),
          ),
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

DataSource _getCalendarDataSource(List events) {
  List<Appointment> appointments = <Appointment>[];

  events.forEach((event) {
    // //print();
    appointments.add(Appointment(
      startTime: DateTime.parse(event['date']),
      endTime: DateTime.parse(event['date']),
      isAllDay: false,
      subject: event['event_name'],
      notes: "sdsd",
      color: event['type'] == "event" ? Colors.blue : Colors.green,
      startTimeZone: '',
      endTimeZone: '',
    ));
  });

  return DataSource(appointments);
}
