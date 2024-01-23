import 'package:flutter/material.dart';
import 'package:uperitivo/Utils/helpers.dart';

class EventDay extends StatefulWidget {
  final Function(
          String selectedDate, int selectedDay, bool isEventoUnicoSelected)
      onSelectionChanged;
  const EventDay({Key? key, required this.onSelectionChanged})
      : super(key: key);

  @override
  State<EventDay> createState() => _EventDayState();
}

class _EventDayState extends State<EventDay> {
  String selectedDate = '';
  int selectedDay = 1;
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
                value: 0,
                groupValue: isEventoUnicoSelected ? 0 : null,
                fillColor: MaterialStateColor.resolveWith(
                    (states) => const Color(0xFFEC6500)),
                onChanged: (value) {
                  setState(() {
                    selectedDay = value as int;
                    isEventoUnicoSelected = true;
                  });
                  widget.onSelectionChanged(
                      selectedDate, selectedDay, isEventoUnicoSelected);
                },
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
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Color(0xFFEC6500),
              ),
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
                      selectedDate = formatDate(pickedDate);
                    });
                    widget.onSelectionChanged(
                        selectedDate, selectedDay, isEventoUnicoSelected);
                  }
                },
                child: Text(
                  selectedDate.isEmpty ? 'GG/MM/AAAA' : selectedDate,
                ),
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
        Radio(
          value: value,
          groupValue: isEventoUnicoSelected ? null : selectedDay,
          fillColor: MaterialStateColor.resolveWith(
              (states) => const Color(0xFFEC6500)),
          onChanged: (value) {
            setState(() {
              selectedDay = value as int;
              isEventoUnicoSelected = false;
            });
            widget.onSelectionChanged(
                selectedDate, selectedDay, isEventoUnicoSelected);
          },
        ),
        Text(label),
      ],
    );
  }
}
