import 'package:flutter/material.dart';
import 'package:uperitivo/Utils/helpers.dart';

class EventDateTimePickerRow extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController timeController;

  const EventDateTimePickerRow({
    super.key,
    required this.dateController,
    required this.timeController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: DCTBTextField(
            controller: dateController,
            hintText: 'GG/MM/AAAA',
            textAlign: TextAlign.center,
            icon: Icons.calendar_today,
            onTap: () => _selectDate(context),
            readOnly: true,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: DCTBTextField(
            controller: timeController,
            hintText: 'HH:MM',
            textAlign: TextAlign.center,
            icon: Icons.access_time,
            onTap: () => _selectTime(context),
            readOnly: true,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFFEC6500),
            colorScheme: const ColorScheme.light(primary: Color(0xFFEC6500)),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != dateController.text) {
      dateController.text = formatDate(pickedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFFEC6500),
            colorScheme: const ColorScheme.light(primary: Color(0xFFEC6500)),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      timeController.text = formatTime(pickedTime);
    }
  }
}

class DCTBTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextAlign textAlign;
  final String? letter;
  final IconData? icon;
  final VoidCallback? onTap;
  final int? characterLimit;
  final double? height;
  final bool autoMoveToNextLine;
  final bool readOnly;

  const DCTBTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.textAlign = TextAlign.center,
    this.letter,
    this.icon,
    this.onTap,
    this.characterLimit = 500,
    this.height,
    this.autoMoveToNextLine = false,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: autoMoveToNextLine ? null : 1,
      maxLength: characterLimit,
      textAlign: textAlign,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 10.0,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF7E84A3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xFFD5D7E3),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xFFD5D7E3),
            width: 1.0,
          ),
        ),
        prefixIcon: letter != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    letter!,
                    style: const TextStyle(
                      color: Color(0xFFEC6500),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : icon != null
                ? Icon(icon, color: const Color(0xFFEC6500))
                : null,
      ),
      style: TextStyle(height: height),
    );
  }
}
