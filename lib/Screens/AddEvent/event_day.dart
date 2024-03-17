import 'package:flutter/material.dart';
import 'package:uperitivo/Utils/helpers.dart'; // Make sure this import path is correct for your formatDate function

class EventDay extends StatefulWidget {
  final Function(List<int> selectedDays, String selectedDate,
      bool isEventoUnicoSelected) onSelectionChanged;

  const EventDay({Key? key, required this.onSelectionChanged})
      : super(key: key);

  @override
  State<EventDay> createState() => _EventDayState();
}

class _EventDayState extends State<EventDay> {
  String selectedDate = '';
  List<int> selectedDays = [];
  bool isEventoUnicoSelected = true;

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
                groupValue: isEventoUnicoSelected,
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      isEventoUnicoSelected = value;
                      selectedDays
                          .clear(); // Clear days when "Evento unico" is selected
                    });
                    widget.onSelectionChanged(
                        selectedDays, selectedDate, isEventoUnicoSelected);
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
                      selectedDate = formatDate(
                          pickedDate); // Make sure the formatDate function exists and works as expected
                    });
                    widget.onSelectionChanged(
                        selectedDays, selectedDate, isEventoUnicoSelected);
                  }
                },
                child: Text(selectedDate.isEmpty ? 'GG/MM/AAAA' : selectedDate),
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
          value: selectedDays.contains(value),
          onChanged: (bool? selected) {
            setState(() {
              if (selected == true) {
                if (!selectedDays.contains(value)) {
                  selectedDays.add(value);
                }
              } else {
                selectedDays.remove(value);
              }
              isEventoUnicoSelected =
                  false; // Automatically deselect "Evento unico" when any day is selected
            });
            widget.onSelectionChanged(
                selectedDays, selectedDate, isEventoUnicoSelected);
          },
        ),
        Text(label),
      ],
    );
  }
}
