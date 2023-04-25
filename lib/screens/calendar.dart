import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'models/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  PageController pageController = PageController(initialPage: 0, keepPage: false);

  List<Appointment> appointments = <Appointment>[];
  List apps = [];
  final DateTime startTime = DateTime.utc(2023, 4, 1, 11, 00);
  int daysRow = 2;
  int daysInterval = 3;

  String getRecurrenceRule() {
    int interval = daysRow + daysInterval;
    String recurrenceRule = 'FREQ=DAILY;INTERVAL=$interval;';
    return recurrenceRule;
  }

  AppointmentDataSource getCalendarDataSource() {
    return AppointmentDataSource(appointments);
  }

  addAppointment() {
    DateTime start = startTime;
    for( var i = 0 ; i < daysRow; i++ ) {
      print('*************'); 
      print(i);
      
      DateTime startLoop = start.add(Duration(days: i));
      
      setState(() {
        appointments.add(
          Appointment(
            startTime: startLoop,
            endTime: startLoop.add(Duration(hours: 8)),
            subject: 'work',
            color: Colors.blue,
            recurrenceRule: getRecurrenceRule(),
          )
        );
      });

      print(appointments.length);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: PageView(
        controller: pageController,
        children:[
          SafeArea(
            child: SfCalendar(
              firstDayOfWeek: 1,
              view: CalendarView.month,
              monthViewSettings: const MonthViewSettings(
                showAgenda: true,
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              ),
              dataSource: getCalendarDataSource(),
            ),
          ),
          Column(
            children: [
              Text('list'),
            ],
          ),
          Column(
            children: [
              Text('add')
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addAppointment,
        child: const Icon(Icons.add),
      ),
    );
  }
}


class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}