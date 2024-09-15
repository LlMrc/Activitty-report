import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../local/local.dart';
import '../../model/event.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});
  static const routeName = '/calendar_screen';
  @override
  // ignore: library_private_types_in_public_api
  _CalenderScreenState createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final ValueNotifier<bool> _showFAB = ValueNotifier<bool>(false);
  //----------------------------

  Map<DateTime, List<Event>> events = {};
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    loadPreviousEvents();
  }

//*GET EVENTS PER DAY
  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

//*GET EVENT RANGE
  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return [
      for (final day in days) ..._getEventsForDay(day),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
    _showFAB.value = true;
    debugPrint('${_selectedEvents.value}');
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = _selectedDay; // Initialize with a non-null value
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // *`start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
    _showFAB.value = true;
  }

  final _titleController = TextEditingController();
  final _fromController = TextEditingController();

  // //Clear text controller

  TimeOfDay _timeOfDay = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < 0) {
          _showFAB.value = false;
        } else {
          _showFAB.value = true;
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                child: Text(
                  textAlign: TextAlign.center,
                  DateFormat('MMMM yyyy').format(_selectedDay!),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TableCalendar(
                headerStyle: HeaderStyle(
                    formatButtonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(),
                        color: Theme.of(context).colorScheme.tertiaryContainer),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onInverseSurface)),
                firstDay: DateTime.utc(2010, 12, 31),
                lastDay: DateTime.utc(2030, 01, 01),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                rangeSelectionMode: _rangeSelectionMode,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  markerDecoration:
                      BoxDecoration(color: Theme.of(context).colorScheme.error),
                  selectedDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary),
                  weekendDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  todayDecoration: const BoxDecoration(
                    image: DecorationImage(
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                        image: AssetImage('images/car.jpeg')),
                    shape: BoxShape.circle,
                  ),
                  // Use `CalendarStyle` to customize the UI
                  outsideDaysVisible: false,
                ),
                onDaySelected: _onDaySelected,
                onRangeSelected: _onRangeSelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ValueListenableBuilder(
                  builder: (context, value, _) {
                    return Center(
                      child: Wrap(
                        spacing: 10,
                        children: value
                            .map((e) => Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Stack(
                                    children: [
                                      stickyNote(context, e),
                                      Positioned(
                                        top: -10,
                                        right: -5,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _selectedEvents.value.clear();
                                                events.removeWhere(
                                                    (key, value) =>
                                                        key.day ==
                                                        _selectedDay!.day);
                                                SharedPreferencesSingleton()
                                                    .saveEvents(events);
                                                _selectedEvents.value =
                                                    _getEventsForDay(
                                                        _selectedDay!);

                                                _getEventsForDay(_selectedDay!);
                                                loadPreviousEvents();
                                                _showFAB.value = false;

                                                _getEventsForDay;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.push_pin_rounded,
                                              color: Colors.blue,
                                            )),
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    );
                  },
                  valueListenable: _selectedEvents,
                ),
              )
            ],
          ),
        ),
        floatingActionButton: ValueListenableBuilder(
          builder: (context, isVisible, _) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: isVisible ? 1.0 : 0.0,
              child: FloatingActionButton.extended(
                onPressed: () {
                  //  Show dialog to user to input event
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => myDialog(context));
                },
                label: const Text('Add Events'),
                icon: const Icon(Icons.add),
              ),
            );
          },
          valueListenable: _showFAB,
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _fromController.dispose();
    _titleController.dispose();

    super.dispose();
  }

//ALERT DIALOG
  Widget myDialog(BuildContext contextPopup) {
    return AlertDialog.adaptive(
      scrollable: true,
      title: TextField(
        controller: _titleController,
        decoration: const InputDecoration(
            hintText: 'Title',
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey)),
      ),
      content: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  maxLines: 5,
                  controller: _fromController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: .5),
                    ),
                    labelText: 'description',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(_timeOfDay.format(context),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith()),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        shape: BoxShape.circle),
                    child: GestureDetector(
                      onTap: () => _showTimePicker(),
                      child: Icon(
                        Icons.watch_later_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(contextPopup).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            )),
        ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty &&
                  _fromController.text.isNotEmpty) {
                var date = DateTime(_selectedDay!.year, _selectedDay!.month,
                    _selectedDay!.day, _timeOfDay.hour, _timeOfDay.minute);
                final selectedEvent = Event(
                    title: _titleController.text,
                    description: _fromController.text,
                    timeStamp: DateFormat.MMMEd().format(date));
                events.addAll({
                  _selectedDay!: [..._selectedEvents.value, selectedEvent]
                });

                await SharedPreferencesSingleton().saveEvents(events);

                _selectedEvents.value = _getEventsForDay(_selectedDay!);
                if (contextPopup.mounted) {
                  Navigator.of(contextPopup).pop();
                }
                _titleController.clear();
                _fromController.clear();
              } else if (contextPopup.mounted) {
                Navigator.of(contextPopup).pop();
              }
            },
            child: const Text('Submit'))
      ],
    );
  }

  void loadPreviousEvents() async {
    events = SharedPreferencesSingleton().getEvents();
    setState(() {});
  }

  void _showTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        _timeOfDay = value!;
      });
    });
  }

  Widget stickyNote(BuildContext context, Event e) {
    return Container(
      constraints: const BoxConstraints(minHeight: 150, maxWidth: 300),
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 240, 241, 184),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          width: double.maxFinite,
          color: const Color.fromARGB(255, 234, 235, 176),
          child: Text(e.title.toUpperCase(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(e.description,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        )
      ]),
    );
  }
}
