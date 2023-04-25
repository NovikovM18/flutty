import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  final DateTime startTime = DateTime.utc(2023, 4, 1, 11, 00);
  int daysRow = 3;
  int daysInterval = 4;

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
            id: 'sdawdasdaw' + i.toString(),
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
        title: Text('Calendar'),
      ),
      body: PageView(
        controller: pageController,
        children:[
          Container(
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
              Text('List'),
              ListView.separated(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final app = appointments[index];
                  return Slidable(
                    key: Key(app['id']),
                    startActionPane: ActionPane(
                      extentRatio: 0.25,
                      // dismissible: DismissiblePane(onDismissed: () => showDialogs('Complited')), 
                      motion: const StretchMotion(), 
                      children: [
                        SlidableAction(
                          onPressed: (context) => {},
                          backgroundColor: Colors.red,
                          icon: Icons.delete_forever,
                          label: 'Delete',
                        )
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(),
                      title: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(app['subject'], 
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                      ],),
                      subtitle: Row(
                        children: [
                          Text(app['description'], 
                            style:Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Chat(chatId: chat.id,)),
                        // );
                      },
                      onLongPress: () {},
                    ),
                  );
                }, 
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 4);
                },
              ),
            ],
          ),
          Column(
            children: [
              Text('333333333')
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