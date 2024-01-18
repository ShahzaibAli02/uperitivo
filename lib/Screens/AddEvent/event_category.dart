import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  final Function(String selectedCategory, Color selectedColor)
      onCategoryChanged;

  const Category({Key? key, required this.onCategoryChanged}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
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

  Color getCategoryColor(int categoryValue) {
    switch (categoryValue) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.purple;
      case 6:
        return Colors.brown;
      default:
        return Colors.black; // Default color if value is not recognized
    }
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

            // Call the callback function immediately when a value is selected
            if (selectedValue != null) {
              widget.onCategoryChanged(
                  label!, getCategoryColor(selectedValue!));
            }
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
