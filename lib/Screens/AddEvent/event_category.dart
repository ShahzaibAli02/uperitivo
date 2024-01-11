import 'package:flutter/material.dart';

class EventDay extends StatefulWidget {
  const EventDay({Key? key}) : super(key: key);

  @override
  _EventDayState createState() => _EventDayState();
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
                    isEventoUnicoSelected = true;
                  });
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
                    firstDate: DateTime(2000),
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
                      selectedDate =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    });
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
          },
        ),
        Text(label),
      ],
    );
  }
}

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  int? selectedValue;

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
          Column(
            children: [
              buildCategoryRow(1, 'Vino', Colors.red),
              buildCategoryRow(2, 'Spritz', Colors.blue),
              buildCategoryRow(3, 'Bollicine', Colors.green),
              buildCategoryRow(4, 'Spirit', Colors.orange),
              buildCategoryRow(5, 'Analcolico', Colors.purple),
              buildCategoryRow(6, 'Street Food', Colors.brown),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCategoryRow(int value, String label, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Radio(
          value: value,
          fillColor: MaterialStateColor.resolveWith(
              (states) => const Color(0xFFEC6500)),
          groupValue: selectedValue,
          onChanged: (int? value) {
            setState(() {
              selectedValue = value;
            });
          },
        ),
        Text(label),
        const SizedBox(
          width: 10,
        ),
        Container(
          width: 30.0,
          height: 20.0,
          color: color,
        ),
      ],
    );
  }
}
