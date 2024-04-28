import 'package:flutter/material.dart';
import 'package:uperitivo/Utils/helpers.dart';

class EventDay extends StatefulWidget {
  final Function(List<int> selectedDays, String selectedDate,
      bool isEventoUnicoSelected) onSelectionChanged;
  String selectedDate;
  final List<int> selectedDays;
  bool isEventoUnicoSelected;

  EventDay({
    Key? key,
    required this.onSelectionChanged,
    required this.selectedDate,
    required this.selectedDays,
    required this.isEventoUnicoSelected,
  }) : super(key: key);

  @override
  State<EventDay> createState() => _EventDayState();
}

class _EventDayState extends State<EventDay> {
  // String selectedDate = '';
  // List<int> selectedDays = [];
  // bool isEventoUnicoSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD5D7E3)),
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Radio(
                value: true,
                groupValue: widget.isEventoUnicoSelected,
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      widget.isEventoUnicoSelected = value;
                      widget.selectedDays
                          .clear(); // Clear days when "Evento unico" is selected
                    });
                    widget.onSelectionChanged(widget.selectedDays,
                        widget.selectedDate, widget.isEventoUnicoSelected);
                  }
                },
                fillColor: MaterialStateColor.resolveWith(
                    (states) => const Color(0xFFEC6500)),
              ),
              const Text('Evento unico'),
            ],
          ),
          const Divider(),
          Column(
            children: [
              buildDayRow(1, 'Lunedì'),
              buildDayRow(2, 'Martedì'),
              buildDayRow(3, 'Mercoledì'),
              buildDayRow(4, 'Giovedì'),
              buildDayRow(5, 'Venerdì'),
              buildDayRow(6, 'Sabato'),
              buildDayRow(7, 'Domenica'),
            ],
          ),
          const Text('Fino al (compreso):'),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Color(0xFFEC6500)),
              const SizedBox(width: 10.0),
              InkWell(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: const Color(0xFFEC6500),
                          colorScheme: const ColorScheme.light(
                              primary: Color(0xFFEC6500)),
                          buttonTheme: const ButtonThemeData(
                              textTheme: ButtonTextTheme.primary),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    setState(() {
                      widget.selectedDate = formatDate(
                          pickedDate); // Make sure the formatDate function exists and works as expected
                    });
                    widget.onSelectionChanged(widget.selectedDays,
                        widget.selectedDate, widget.isEventoUnicoSelected);
                  }
                },
                child: Text(widget.selectedDate.isEmpty
                    ? 'GG/MM/AAAA'
                    : widget.selectedDate),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDayRow(int value, String label) {
    return Row(
      children: [
        Checkbox(
          value: widget.selectedDays.contains(value),
          onChanged: (bool? selected) {
            setState(() {
              if (selected == true) {
                if (!widget.selectedDays.contains(value)) {
                  widget.selectedDays.add(value);
                }
              } else {
                widget.selectedDays.remove(value);
              }
              widget.isEventoUnicoSelected =
                  false; // Automatically deselect "Evento unico" when any day is selected
            });
            widget.onSelectionChanged(widget.selectedDays, widget.selectedDate,
                widget.isEventoUnicoSelected);
          },
        ),
        Text(label),
      ],
    );
  }
}
