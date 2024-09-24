import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:report/src/feature/calender/widget/sticknote_calender.dart';
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
  Map<List<DateTime>, Event> _dateRangeEvents = {};

  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<DateTime> days = [];

  @override
  void initState() {
    super.initState();
    loadPreviousEvents();
    _selectedDay = _focusedDay;
    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _selectedEvents = ValueNotifier(_getEventsForRange(_rangeStart, _rangeEnd));
  }

  /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  // Gets the events for a specific date range
  List<Event> _getEventsForRange(DateTime? start, DateTime? end) {
    List<Event> eventsInRange = [];

    // Ensure both start and end are not null
    if (start != null && end != null) {
      days = daysInRange(start, end);

      // Add events for each day within the range
      for (final day in days) {
        eventsInRange.addAll(_getEventsForDay(day));
      }

      // Check for any events tied to multi-day ranges stored in _dateRangeEvents
      _dateRangeEvents.forEach((dateRange, event) {
        DateTime rangeStart = dateRange.first;
        DateTime rangeEnd = dateRange.last;

        // If there's an overlap between the selected range and event range
        if (!(rangeEnd.isBefore(start) || rangeStart.isAfter(end))) {
          eventsInRange.add(event);
        }
      });
    }

    return eventsInRange;
  }

//*GET EVENTS PER DAY
  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;

        // Clear range selection when a single day is selected
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;

        // Load events for the selected day
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }

    _showFAB.value = true;
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null; // Clear single-day selection
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    _selectedEvents.value.clear();

    if (start != null && end != null) {
      // Load events for the selected date range
      _selectedEvents.value = _getEventsForRange(start, end);
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
              const SizedBox(
                height: 16,
              ),
              TableCalendar(
                daysOfWeekStyle: const DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: Colors.blue)),
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
                eventLoader: (day) {
                  // Get events for the exact day
                  List<Event> dayEvents = _getEventsForDay(day);

                  // Check for any events that occur within a date range including this day
                  _dateRangeEvents.forEach((dateRange, event) {
                    DateTime rangeStart = dateRange.first;
                    DateTime rangeEnd = dateRange.last;

                    // If the current day falls within the range
                    if (day.isAfter(
                            rangeStart.subtract(const Duration(days: 1))) &&
                        day.isBefore(rangeEnd.add(const Duration(days: 1)))) {
                      dayEvents.add(event);
                    }
                  });

                  return dayEvents;
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if (events.isNotEmpty) {
                      // Check if the day belongs to a single event or date range
                      bool isSingleDayEvent = _getEventsForDay(day).isNotEmpty;
                      bool isInRange = _dateRangeEvents.keys.any((range) =>
                          day.isAfter(
                              range.first.subtract(const Duration(days: 1))) &&
                          day.isBefore(
                              range.last.add(const Duration(days: 1))));

                      // Define different marker colors based on the event type
                      Color markerColor = isSingleDayEvent
                          ? Colors.redAccent
                              .withOpacity(0.5) // Color for single-day events
                          : (isInRange
                              ? Colors.blueAccent
                                  .withOpacity(0.5) // Color for range events
                              : Colors.transparent);

                      return Align(
                          alignment: Alignment.bottomCenter,
                          child: Icon(
                            Icons.star,
                            size: 14,
                            color: markerColor,
                          ));
                    }
                    return null; // No marker if there are no events
                  },
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                    markerDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error),
                    selectedDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary),
                    weekendDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    todayTextStyle: const TextStyle(color: Colors.blue),
                    todayDecoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: false,
                    markersMaxCount: 2),
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
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
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
                                      StickyNoteCalendar(event: e),
                                      Positioned(
                                        top: -10,
                                        right: -5,
                                        child: IconButton(
                                            onPressed: () {
                                              if (_selectedDay != null) {
                                                // Single day is selected, so remove a single event
                                                _removeEvent();
                                              } else if (_rangeStart != null &&
                                                  _rangeEnd != null) {
                                                // Date range is selected, so remove events for the range
                                                _removeEventsForDateRange(
                                                    _rangeStart!, _rangeEnd!);
                                              }
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
            hintText: 'Tit',
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey)),
      ),
      content: Column(
        children: [
          TextField(
            maxLines: 2,
            controller: _fromController,
            decoration: InputDecoration(
              hintText: 'description',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.grey),
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
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (_titleController.text.isNotEmpty &&
                _fromController.text.isNotEmpty) {
              if (_selectedDay != null && _rangeEnd == null) {
                // Single date selection
                var date = DateTime(
                  _selectedDay!.year,
                  _selectedDay!.month,
                  _selectedDay!.day,
                  _timeOfDay.hour, // Ensure _timeOfDay is not null
                  _timeOfDay.minute,
                );

                final selectedEvent = Event(
                  title: _titleController.text,
                  description: _fromController.text,
                  timeStamp: DateFormat.MMMEd().format(date),
                );

                // Add event to single-day events
                events[_selectedDay!] = [
                  ..._selectedEvents.value,
                  selectedEvent
                ];

                await SharedPreferencesSingleton().saveEvents(events);

                _selectedEvents.value = _getEventsForDay(_selectedDay!);
              } else if (_rangeStart != null && _rangeEnd != null) {
                // Date range selection

                final event = Event(
                  title: _titleController.text,
                  description: _fromController.text,
                  timeStamp:
                      "${DateFormat.MMMEd().format(_rangeStart!)} - ${DateFormat.MMMEd().format(_rangeEnd!)}",
                );

                if (days.isNotEmpty) {
                  // Add the date range and event to _dateRangeEvents
                  // Create a copy of the 'days' list to avoid shared reference issues
                  _dateRangeEvents[List<DateTime>.from(days)] = event;

                  // Save the date range events to SharedPreferences
                  await SharedPreferencesSingleton()
                      .saveEventsWithDateRange(_dateRangeEvents);

                  // Retrieve the saved events
                  var savedEvents =
                      SharedPreferencesSingleton().getEventsWithDateRange();
                  debugPrint('Retrieved events: $savedEvents');
                }
              }

              // Close the popup if it's still mounted
              if (contextPopup.mounted) {
                Navigator.of(contextPopup).pop();
              }

              // Clear the input fields
              _titleController.clear();
              _fromController.clear();
            } else if (contextPopup.mounted) {
              // Close the popup if the context is still mounted and inputs are invalid
              Navigator.of(contextPopup).pop();
            }
            setState(() {
              _rangeSelectionMode = RangeSelectionMode.toggledOff;
            });
          },
          child: const Text('Soumèt'),
        )
      ],
    );
  }

  void loadPreviousEvents() async {
    events = SharedPreferencesSingleton().getEvents();
    _dateRangeEvents = SharedPreferencesSingleton().getEventsWithDateRange();
    setState(() {});
  }

  void _showTimePicker() {
    showTimePicker(
            context: context,
            initialEntryMode: TimePickerEntryMode.inputOnly,
            initialTime: TimeOfDay.now())
        .then((value) {
      if (value != null) {
        setState(() {
          _timeOfDay = value;
        });
      }
    });
  }

  void _removeEvent() {
    setState(() {
      _selectedEvents.value.clear();

      events.removeWhere((key, value) => key.day == _selectedDay!.hour);
      SharedPreferencesSingleton().saveEvents(events);
      _selectedEvents.value = _getEventsForDay(_selectedDay!);

      _getEventsForDay(_selectedDay!);
      loadPreviousEvents();
      _showFAB.value = false;

      _getEventsForDay;
    });
  }

  void _removeEventsForDateRange(DateTime start, DateTime end) {
    setState(() {
      // Remove events from the date range map that fall within the selected date range
      _dateRangeEvents.removeWhere((dateList, event) {
        // Check if any date in the list falls within the selected date range
        return dateList.any((date) {
          return date.isBefore(end.add(const Duration(days: 1))) &&
              date.isAfter(start.subtract(const Duration(days: 1)));
        });
      });

      // Save the updated events to SharedPreferences
      SharedPreferencesSingleton().saveEventsWithDateRange(_dateRangeEvents);

      // Determine the updated date range for which to refresh events
      DateTime? newStart;
      DateTime? newEnd;

      if (_dateRangeEvents.isNotEmpty) {
        // Get the new range from the updated _dateRangeEvents
        final firstEntry = _dateRangeEvents.keys.first;
        newStart = firstEntry.first;
        newEnd = firstEntry.last;
      } else {
        // Handle the case where no date range is left
        newStart = null;
        newEnd = null;
      }

      // Refresh the displayed events based on the new date range
      if (newStart != null && newEnd != null) {
        _selectedEvents.value = _getEventsForRange(newStart, newEnd);
      } else {
        // Handle case where no valid date range is available
        _selectedEvents.value = [];
      }

      // Optionally reload previous events if needed
      loadPreviousEvents();
    });
    _rangeSelectionMode = RangeSelectionMode.toggledOff;
  }
}
